//
//  iPhoneBitcoinAppDelegate.h
//  iPhoneBitcoin
//
//  Created by Jeremias Kangas on 2/18/11.
//  Copyright 2011 Kangas Bros. Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface iPhoneBitcoinAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	NSDictionary* lastTicker;
	NSDictionary* marketDepth;
	NSDictionary* recentTrades;
	NSDate *lastFetch;
	BOOL errorShown;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (retain) NSDictionary *lastTicker;
@property (retain) NSDictionary *marketDepth;
@property (retain) NSDictionary *recentTrades;
@property (retain) NSDate *lastFetch;

@end
