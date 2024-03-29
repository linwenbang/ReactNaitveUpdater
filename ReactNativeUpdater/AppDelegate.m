//
//  AppDelegate.m
//  ReactNativeUpdater
//
//  Created by Hao on 16/4/26.
//  Copyright © 2016年 RainbowColors. All rights reserved.
//

#import "AppDelegate.h"
#import "ReactNativeUpdater.h"
#import "DiffMatchPatch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self checkForUpdate];
    
    [self displayUI];
    
    return YES;
}
- (void)checkForUpdate {
    ReactNativeUpdater *update = [ReactNativeUpdater sharedInstance];
   
    [update updateWithConfigUrl:@"https://www.baidu.com" bundleUrl:@"https://www.baiud.com" Success:^(UpdateOperation *opreation) {
        NSLog(@"---%@",opreation.message);
        
    } failure:^(UpdateOperation *opreation) {
        
        NSLog(@"===%@",opreation.message);
        
    }];
}

- (void)displayUI {
    UIViewController *viewController = [[UIViewController alloc]init];
    viewController.view.backgroundColor = [UIColor whiteColor];
    
    NSURL *googleUrl = [[NSBundle mainBundle] URLForResource:@"google" withExtension:@"html"];
    NSString *googleString = [NSString stringWithContentsOfURL:googleUrl encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *baiduUrl = [[NSBundle mainBundle] URLForResource:@"baidu" withExtension:@"html"];
    NSString *baiduString = [NSString stringWithContentsOfURL:baiduUrl encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *diffUrl = [[NSBundle mainBundle]URLForResource:@"bundle" withExtension:@"diff"];
    NSData *diffData = [NSData dataWithContentsOfURL:diffUrl];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:diffData];
    DiffMatchPatch *match = [[DiffMatchPatch alloc]init];
    NSArray *currentArray = [match patch_apply:array toString:googleString];
    NSString *string = currentArray[0];
    
    if ([string isEqualToString:baiduString]) {
        NSLog(@"google页面加上增量修改后，完全等于baidu 页面的内容");
    }
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:viewController.view.frame];
    [web loadRequest:[NSURLRequest requestWithURL:baiduUrl]];
    [viewController.view addSubview:web];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
