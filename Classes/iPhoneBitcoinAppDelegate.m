//
//  iPhoneBitcoinAppDelegate.m
//  iPhoneBitcoin
//
//  Created by Jeremias Kangas on 2/18/11.
//  Copyright 2011 Kangas Bros. Innovations. All rights reserved.
//

#import "iPhoneBitcoinAppDelegate.h"
#import	"ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"

@implementation iPhoneBitcoinAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize lastTicker, marketDepth, recentTrades, lastFetch;

#pragma mark Update mtgox data

- (IBAction)grabURLInBackground:(id)sender
{
	NSURL *url = [NSURL URLWithString:@"http://mtgox.com/code/data/ticker.php"];
	[ASIHTTPRequest setDefaultTimeOutSeconds:999];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setTimeOutSeconds:999]; 
	[request setDelegate:self];
	[request startAsynchronous];
	url = [NSURL URLWithString:@"http://mtgox.com/code/data/getDepth.php"];
	request = [ASIHTTPRequest requestWithURL:url];
	[request setTimeOutSeconds:999]; 
	[request setDelegate:self];
	[request startAsynchronous];
	url = [NSURL URLWithString:@"http://mtgox.com/code/data/getTrades.php"];
	request = [ASIHTTPRequest requestWithURL:url];
	[request setTimeOutSeconds:999]; 
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	// Use when fetching binary data
	//NSData *responseData = [request responseData];
	
	if ([[request originalURL] isEqual:[NSURL URLWithString:@"http://mtgox.com/code/data/ticker.php"]])
	{
		NSLog(responseString);
		NSError *error = nil;
		self.lastTicker = [NSDictionary dictionaryWithJSONString:responseString error:&error];
		NSLog(@"lastTicker");
	}
	else if ([[request originalURL] isEqual:[NSURL URLWithString:@"http://mtgox.com/code/data/getDepth.php"]])
	{
		NSLog(responseString);
		NSError *error = nil;
		self.marketDepth = [NSDictionary dictionaryWithJSONString:responseString error:&error];
		NSLog(@"marketDepth");
	}
	else if ([[request originalURL] isEqual:[NSURL URLWithString:@"http://mtgox.com/code/data/getTrades.php"]])
	{
		NSLog(responseString);
		NSError *error = nil;
		self.recentTrades = [NSDictionary dictionaryWithJSONString:responseString error:&error];
		NSLog(@"recentTrades");
		NSLog(@"JSON Object: %@ %p (Error: %@)", [self.recentTrades class], 
			  	  self.recentTrades, error);
	}
	lastFetch=[NSDate date];
	
	[[tabBarController.viewControllers objectAtIndex:0] refreshChart];
	[[tabBarController.viewControllers objectAtIndex:1] refreshChart2];
	
	//NSLog(@"JSON Object: %@ %p (Error: %@)", [[[dictionary objectForKey:@"ticker"] objectForKey:@"last"] class], 
	//	  [[dictionary objectForKey:@"ticker"] objectForKey:@"last"], error);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"(Error: %@)", error);
	NSLog(@"Error fetching data");
	if (!errorShown)
	{
		errorShown=YES;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Failed" 
													message:@"Can't fetch data from mtgox.com. Check your internet connection."
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
		
	}
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
	lastTicker=nil;
	marketDepth=nil;
	recentTrades=nil;
	errorShown=NO;
	[self grabURLInBackground:self];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	//[self grabURLInBackground:self];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	errorShown=NO;
	[self grabURLInBackground:self];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

