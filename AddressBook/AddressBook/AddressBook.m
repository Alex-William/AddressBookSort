//
//  AddressBook.m
//  AddressBook
//
//  Created by irene on 16/3/29.
//  Copyright © 2016年 HZYuanzhoulvNetwork. All rights reserved.
//

#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressBookModel.h"

@implementation AddressBook

#pragma mark 单例
+ (instancetype)share {
    return [[self alloc] init];
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static AddressBook *instance;
    //dispatch_once是线程安全的，onceToken默认为0
    //且dispatch_once 可以保证块代码中的指令只被执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark - GetPhoneContacts
- (NSArray *)getPhoneContacts {
    NSMutableArray *addressBookList = [NSMutableArray array];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        // 获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    // 获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 获取通讯录中的人数
    CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
    // 循环获取每个人的个人信息
    for (NSInteger i = 0; i < personCount; i++) {
        // 新建一个model,存储addressBook信息
        AddressBookModel *addressBookModel = [[AddressBookModel alloc] init];
        // 获取某个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        // 获取个人名字
        CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFTypeRef fullName = ABRecordCopyCompositeName(person);
        NSString *nameStr = (__bridge NSString *)firstName;
        if ((__bridge id)fullName != nil) {
            nameStr = (__bridge NSString *)fullName;
        } else {
            if ((__bridge id)lastName != nil) {
                nameStr = [NSString stringWithFormat:@"%@ %@",(__bridge NSString *)firstName,(__bridge NSString *)lastName];
            }
        }
        addressBookModel.name = nameStr;
        addressBookModel.firstCharactor = [[self firstCharactor:nameStr] uppercaseString];
        addressBookModel.recordID = (NSInteger)ABRecordGetRecordID(person);
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {
                        // Phone number
                        addressBookModel.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {
                        // Email
                        addressBookModel.email = (__bridge NSString*)value;
                        break;
                    }
                    default:
                        break;
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [addressBookList addObject:addressBookModel];
        //        NSLog(@"通讯录首字母：%@",addressBookModel.firstCharactor);
        
        if (firstName) CFRelease(firstName);
        if (lastName) CFRelease(lastName);
        if (fullName) CFRelease(fullName);
    }
    
    // sort
    return [self ContactSortWithAddressBookList:addressBookList];
}

#pragma mark - sort Method
- (NSArray *)ContactSortWithAddressBookList:(NSArray *)addressBookList {
    NSMutableDictionary *addressBookSection = [NSMutableDictionary dictionary];
    for (int i = 0; i < 26; i++) {
        [addressBookSection setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    }
    [addressBookSection setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    for (NSInteger i = 0; i < addressBookList.count; i++) {
        AddressBookModel *addressBookModel = addressBookList[i];
        
        if (![addressBookModel.firstCharactor isEqualToString:@""]) {
            char first = [addressBookModel.firstCharactor characterAtIndex:0];
            if ((first >= 'a' && first <= 'z') || (first >= 'A' && first <= 'Z')) {
                if([addressBookModel.name isEqualToString:@"曾"])
                    addressBookModel.firstCharactor = @"Z";
                else if([addressBookModel.name isEqualToString:@"解"])
                    addressBookModel.firstCharactor = @"X";
                else if([addressBookModel.name isEqualToString:@"仇"])
                    addressBookModel.firstCharactor = @"Q";
                else if([addressBookModel.name isEqualToString:@"朴"])
                    addressBookModel.firstCharactor = @"P";
                else if([addressBookModel.name isEqualToString:@"查"])
                    addressBookModel.firstCharactor = @"Z";
                else if([addressBookModel.name isEqualToString:@"能"])
                    addressBookModel.firstCharactor = @"N";
                else if([addressBookModel.name isEqualToString:@"乐"])
                    addressBookModel.firstCharactor = @"Y";
                else if([addressBookModel.name isEqualToString:@"单"])
                    addressBookModel.firstCharactor = @"S";
            } else {
                addressBookModel.firstCharactor = [[NSString stringWithFormat:@"%c",'#'] uppercaseString];
            }
        } else {
            addressBookModel.firstCharactor = [[NSString stringWithFormat:@"%c",'#'] uppercaseString];
        }
        
        if ([[addressBookModel.tel substringToIndex:1] isEqualToString:@"+"]) {
            addressBookModel.tel = [addressBookModel.tel substringFromIndex:3];
        }
        [[addressBookSection objectForKey:addressBookModel.firstCharactor] addObject:addressBookModel];
    }
    
    NSArray *keysArray = [addressBookSection allKeys];
    NSArray *resultArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *addressBookLists = [NSMutableArray array];
    for (NSString *key in resultArray) {
        [addressBookLists addObject:[addressBookSection objectForKey:key]];
    }
    return addressBookLists;
}

#pragma mark - getFirstCharactor Method
- (NSString *)firstCharactor:(NSString *)aString
{
    if (aString == nil) {
        return @"";
    }
    aString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    aString = [aString stringByReplacingOccurrencesOfString:@")" withString:@""];
    // 判断首字符是中文还是英文
    NSString *temp = [aString substringWithRange:NSMakeRange(0,1)];
    const char *u8Temp = [temp UTF8String];
    if (3==strlen(u8Temp)){
        //转成了可变字符串
        NSMutableString *str = [NSMutableString stringWithString:aString];
        //先转换为带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
        //再转换为不带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
        //转化为大写拼音
        NSString *pinYin = [str capitalizedString];
        //获取并返回首字母
        return [pinYin substringToIndex:1];
    }
    return [aString substringToIndex:1];
}

@end
