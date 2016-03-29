# AddressBookSort
AddressBookSort

导入：
import <AddressBook/AddressBook.h>
import <AddressBookUI/AddressBookUI.h>
import "AddressBookModel.h"
import "AddressBook.h"

使用：
1.单例获取对象
+ (instancetype)share;

2.调用方法获取分组完的数据
- (NSArray *)getPhoneContacts;
