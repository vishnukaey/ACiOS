//
//  LCGAManager.m
//  LegacyConnect
//
//  Created by Kaey on 11/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCGAManager.h"
#import <Google/Analytics.h>


@implementation LCGAManager

+(void)ga_trackViewWithName:(NSString*)screenName
{
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker set:kGAIScreenName value:screenName];
  [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


+(void)ga_trackEventWithCategory:(NSString*)category action:(NSString*)action andLabel:(NSString*)label
{
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                                        action:action  // Event action (required)
                                                         label:label          // Event label
                                                         value:nil] build]];
}

@end
