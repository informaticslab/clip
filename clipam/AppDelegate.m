//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController2.h"
#import "ClipWS.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize vc1;
@synthesize vc2;
@synthesize transitionController, cdMgr, clipWS;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 760, 1024)];
    splashView.image = [UIImage imageNamed:@"splash_CLIP.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];

    // Do your time consuming setup
    //#ifndef DEBUG       
    [NSThread sleepForTimeInterval:0.75]; // simulate waiting for server response//
    //#endif
    
    // Override point for customization after application launch.
    self.vc1 = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    // new transitionController
    self.transitionController = [[TransitionController alloc] initWithViewController:self.vc1];
    self.window.rootViewController = self.transitionController;


    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"" forKey:@"facility_preference"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];

    // set up clip data manager
    self.cdMgr = [[ClipDataManager alloc] init];

    // get any needed data from CLIP web service 
    clipWS = [[ClipWS alloc] initWithClipDataManager:self.cdMgr];
//  [clipWS getDefaultFacilityLocations];
    
    
    
    [self.window makeKeyAndVisible];
    [splashView removeFromSuperview];
    
    return YES;
    
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

@end
