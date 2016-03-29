//
//  AddressBook.h
//  AddressBook
//
//  Created by irene on 16/3/29.
//  Copyright © 2016年 HZYuanzhoulvNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBook : NSObject

+ (instancetype)share;

- (NSArray *)getPhoneContacts;

@end
