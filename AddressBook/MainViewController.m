//
//  MainViewController.m
//  AddressBook
//
//  Created by irene on 16/3/29.
//  Copyright © 2016年 HZYuanzhoulvNetwork. All rights reserved.
//

#import "MainViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressBookModel.h"
#import "AddressBook.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView           *tableView;

@property (nonatomic, strong) NSArray               *addressBookList;

@end

@implementation MainViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init
    [self initSubviews];
    
    [self initParma];
    
    AddressBook *addressBook = [AddressBook share];
    self.addressBookList = [addressBook getPhoneContacts];
}

#pragma mark - init Method
- (void)initSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)initParma {
    _addressBookList = [NSArray array];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.addressBookList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addressBookList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    AddressBookModel *bookModel = [self.addressBookList[section] firstObject];
    if (!bookModel) {
        return 0.0001f;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"identifer%ld%ld",(long) indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    AddressBookModel *bookModel = self.addressBookList[indexPath.section][indexPath.row];
    cell.textLabel.text = bookModel.name;
    cell.detailTextLabel.text = bookModel.tel;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerIdentifier = @"HeaderId";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 30)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:101.0 / 255.0 green:101.0 / 255.0 blue:101.0 / 255.0 alpha:1.0f];
        label.tag = 1000;
        
        [headerView addSubview:label];
    }
    AddressBookModel *bookModel = [self.addressBookList[section] firstObject];
    UILabel *label = [headerView viewWithTag:1000];
    label.text = bookModel.firstCharactor;
    return headerView;
}


@end
