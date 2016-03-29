//
//  AppDelegate.m
//  AddressBook
//
//  Created by irene on 16/3/29.
//  Copyright © 2016年 HZYuanzhoulvNetwork. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:firstVC];
    self.window.rootViewController = nav;
    
    return YES;
}

@end
