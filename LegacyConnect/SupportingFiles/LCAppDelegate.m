//
//  AppDelegate.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//


//left menu implementation
//--created MFmenucontainer controller and made the center controller the homefeed controller and leftmenu  the leftmenuController.
//Gibutton Implementation.
//--created the GIbutton and added it to the app delegate window from the homefeed controller. Now the actions are written in the Homefeed controller
//left menu button implementation.
//--Added to the window as the same way as GIbutton. Actions are driven to homefeed controller by delegate mechanism.

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LCAppDelegate.h"
#import "LCAppLaunchHelper.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "LCSpecialContainerView.h"
#import "LCLoginViewController.h"
#import "LCFeedsCommentsController.h"
#import "LCViewActions.h"

@interface LCAppDelegate ()

@end

@implementation LCAppDelegate
@synthesize menuButton, GIButton, isCreatePostOpen;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [LCUtilityManager setLCStatusBarStyle];
  [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
  [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[LCLoginViewController class]];
  [[IQKeyboardManager sharedManager] disableInViewControllerClass:[LCFeedsCommentsController class]];
  [[IQKeyboardManager sharedManager] disableInViewControllerClass:[LCViewActions class]];

  [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[LCSpecialContainerView class]];
  [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                  didFinishLaunchingWithOptions:launchOptions];
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  BOOL boolValue = false;
  
  if ([[url scheme] caseInsensitiveCompare:kTwitterUrlScheme] == NSOrderedSame)
  {
    NSDictionary *userInfo = [LCUtilityManager parametersDictionaryFromQueryString:[url query]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTwitterCallbackNotification
                                                        object:nil
                                                      userInfo:userInfo];
    return YES;
  }
  
  if([[url scheme] caseInsensitiveCompare:kLCUrlScheme] == NSOrderedSame)
  {
    boolValue = true;
    NSString * tokenString = [LCAppLaunchHelper getPasswordResetTokenFromURLQuery:[url query]];
    if (tokenString) {
      NSDictionary * userInfo = @{kResetPasswordTokenKey: tokenString};
      [[NSNotificationCenter defaultCenter] postNotificationName:kResetPasswordNotificationName
                                                          object:nil
                                                        userInfo:userInfo];
    }
    return boolValue;
  }
  else
  {
    boolValue = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                               openURL:url
                                                     sourceApplication:sourceApplication
                                                            annotation:annotation];
    return boolValue;
  }
}

+ (LCAppDelegate *)appDelegate
{
  return (LCAppDelegate *)[UIApplication sharedApplication];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
  [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
  
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


- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
