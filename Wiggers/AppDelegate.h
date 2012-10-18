//
//  AppDelegate.h
//  Wiggers
//
//  Created by Ben Smith on 31/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestFlight.h"
#import "Sound.h"

@class MainScreenVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Sound *soundPlayer;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainScreenVC *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;
@end
