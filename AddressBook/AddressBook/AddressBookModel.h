//
//  AddressBookModel.h
//  AddressBook
//
//  Created by irene on 16/3/29.
//  Copyright © 2016年 HZYuanzhoulvNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject

@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, assign) NSInteger recordID;
@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSString  *email;
@property (nonatomic, retain) NSString  *tel;
@property (nonatomic, retain) NSString  *logo;
@property (nonatomic, retain) NSString  *friendstatus;
@property (nonatomic, copy)   NSString  *firstCharactor;

@end
