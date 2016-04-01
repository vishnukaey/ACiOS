//
//  LCTutorialManager.m
//  LegacyConnect
//
//  Created by Jijo on 3/16/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCTutorialManager.h"
#import "LCHomeFeedTutorial.h"
#import "LCNotificationsTutorial.h"
#import "LCProfileTutorial.h"
#import "LCInterestListTutorial.h"
#import "LCInterestTutorial.h"
#import "LCCauseTutorial.h"
#import "LCLeftMenuTutorial.h"
#import "LCGIButtonTutorial.h"
#import "LCCreatePostTutorial.h"

NSString *const kHomeFeedTutorial = @"kHomeFeedTutorial";
NSString *const kNotificationsTutorial = @"kNotificationsTutorial";
NSString *const kProfileTutorial = @"kProfileTutorial";
NSString *const kInterestListTutorial = @"kInterestListTutorial";
NSString *const kInterestTutorial = @"kInterestTutorial";
NSString *const kCauseTutorial = @"kCauseTutorial";
NSString *const kLeftMenuTutorial = @"kLeftMenuTutorial";
NSString *const kGIButtonTutorial = @"kGIButtonTutorial";
NSString *const kCreatePostTutorial = @"kCreatePostTutorial";


@implementation LCTutorialManager

+ (void)showHomeFeedTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kHomeFeedTutorial]) {
    return;
  }
  
  LCHomeFeedTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCHomeFeedTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showNotificationsTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kNotificationsTutorial]) {
    return;
  }
  
  LCNotificationsTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCNotificationsTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showProfileTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kProfileTutorial]) {
    return;
  }
  LCProfileTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCProfileTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showInterestListTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kInterestListTutorial]) {
    return;
  }
  LCInterestListTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCInterestListTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showInterestTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kInterestTutorial]) {
    return;
  }
  LCInterestTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCInterestTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showCauseTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kCauseTutorial]) {
    return;
  }
  LCCauseTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCCauseTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showLeftMenuTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kLeftMenuTutorial]) {
    return;
  }
  LCLeftMenuTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCLeftMenuTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showGIButtonTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kGIButtonTutorial]) {
    return;
  }
  LCGIButtonTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCGIButtonTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (BOOL)showCreatePostTutorial
{
  if ([LCTutorialManager tutorialShownForKey:kCreatePostTutorial]) {
    return false;
  }
  LCGIButtonTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCCreatePostTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
  return true;
}


+(id)getViewFromXIBForClass :(Class)classType{
  id result = nil;
  NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"Tutorials" owner:self options: nil];
  for (id anObject in elements)
  {
    if ([anObject isKindOfClass:classType])
    {
      result = anObject;
      break;
    }
  }
  return result;
}

+ (BOOL)tutorialShownForKey :(NSString *)key
{
  if ([[NSUserDefaults standardUserDefaults] objectForKey:key] != nil) {
    return YES;
  }
  else
  {
    [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:key];
  }
  return NO;
}

+ (void)setTutorialPersistance
{
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kHomeFeedTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kNotificationsTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kProfileTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kInterestListTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kInterestTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kCauseTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kLeftMenuTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kGIButtonTutorial];
  [[NSUserDefaults standardUserDefaults]setObject:@"shown" forKey:kCreatePostTutorial];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)resetTutorialPersistance
{
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kHomeFeedTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kNotificationsTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kProfileTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kInterestListTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kInterestTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kCauseTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kLeftMenuTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kGIButtonTutorial];
  [[NSUserDefaults standardUserDefaults]removeObjectForKey:kCreatePostTutorial];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
}

@end
