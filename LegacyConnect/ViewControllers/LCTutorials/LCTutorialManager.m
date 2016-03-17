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

@implementation LCTutorialManager

+ (void)showHomeFeedTutorial
{
  LCHomeFeedTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCHomeFeedTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showNotificationsTutorial
{
  LCNotificationsTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCNotificationsTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showProfileTutorial
{
  LCProfileTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCProfileTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showInterestListTutorial
{
  LCInterestListTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCInterestListTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showInterestTutorial
{
  LCInterestTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCInterestTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
}

+ (void)showCauseTutorial
{
  LCCauseTutorial *rootView = [LCTutorialManager getViewFromXIBForClass:[LCCauseTutorial class]];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.window addSubview:rootView];
  [rootView setFrame:appdel.window.frame];
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

@end
