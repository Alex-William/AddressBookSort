//
//  FirstViewController.m
//  AddressBook
//
//  Created by irene on 16/3/29.
//  Copyright © 2016年 HZYuanzhoulvNetwork. All rights reserved.
//

#import "FirstViewController.h"
#import "MainViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushContract)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)pushContract {
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mainVC animated:YES];
}

@end
