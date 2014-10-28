//
//  AppDelegate.m
//  Wiggers
//
//  Created by Ben Smith on 31/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MainScreenVC.h"
#import "DefaultSHKConfigurator.h"
#import "MySHKConfigurator.h"
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "Constants.h"
#import "iNotify.h"
#import "Flurry.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"7e8051c2a51aca626c6c3d07e6bf5b4d_MTQ0MTk0MjAxMi0xMC0xNiAxOTo0MTo1OS4wMzY5NTE"];
    [Flurry startSession:@"7X9SX6XWH3Q6ZTJGG3GF"];

    DefaultSHKConfigurator *configurator = [[MySHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"%@", self.window);

    // Override point for customization after application launch.
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MainScreenVC alloc] initWithNibName:@"MainScreenCopy" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    //}
//    else {
//        self.viewController = [[MainScreenVC alloc] initWithNibName:@"MainScreenVC_iPad" bundle:nil];
//    }
    //[self logInstalledFonts];
    [[IAPStoreManager sharedInstance] autoUpdate];
    

    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)logInstalledFonts
{
    for (NSString *familyName in [UIFont familyNames])
    {
        NSLog(@"Font Family --> %@", familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName])
        {
            NSLog(@"\tFont Name: %@", fontName);
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return (UIInterfaceOrientationMaskPortrait);
}




#pragma mark - Single Sign on with Facebook
- (BOOL)handleOpenURL:(NSURL*)url
{
//    NSString* scheme = [url scheme];
//    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
//    if ([scheme hasPrefix:prefix])
//        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
    return [self handleOpenURL:url];  
}

@end
