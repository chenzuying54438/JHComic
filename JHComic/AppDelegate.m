//
//  AppDelegate.m
//  Demo_Navigation
//
//  Created by chenzuying on 2017/11/25.
//  Copyright © 2017年 chenzuying. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MyTabBarViewController.h"
#import "MyNavigationViewController.h"

#import "NewsMainViewController.h"
#import "NewsViewController.h"
#import "LiveViewController.h"
#import "TopicViewController.h"
#import "MeViewController.h"
#import "Utility.h"


#import "ComicMainCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MyTabBarViewController *tabBarViewController = [[MyTabBarViewController alloc] init];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"NewsMainViewController" bundle:nil];
    NewsMainViewController *mainController = [storyboard instantiateViewControllerWithIdentifier:@"NewsMainViewController"];
    NewsViewController *newsController = [[NewsViewController alloc] initWithTitle:@"News"];
    MyNavigationViewController *nav1 = [[MyNavigationViewController alloc] initWithRootViewController:mainController];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(105, 145);
    flowLayout.minimumLineSpacing = 8;
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    ComicMainCollectionViewController *comicVc = [[ComicMainCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    comicVc.title = @"漫画";
    MyNavigationViewController *nav2 = [[MyNavigationViewController alloc] initWithRootViewController:comicVc];
    
    TopicViewController *topicController = [[TopicViewController alloc] initWithTitle:@"Topic"];
    MyNavigationViewController *nav3 = [[MyNavigationViewController alloc] initWithRootViewController:topicController];
    
    MeViewController *meController = [[MeViewController alloc] initWithTitle:@"Me"];
    MyNavigationViewController *nav4 = [[MyNavigationViewController alloc] initWithRootViewController:meController];
    
    NSArray *controllers = @[nav1, nav2, nav3, nav4];
    tabBarViewController.viewControllers = controllers;
    tabBarViewController.selectedIndex = 0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarViewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
