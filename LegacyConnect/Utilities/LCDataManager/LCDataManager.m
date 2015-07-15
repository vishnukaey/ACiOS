//
//  LCDataManager.m
//  LegacyConnect
//
//  Created by qbuser on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCDataManager.h"

static LCDataManager *sharedManager = nil;

@implementation LCDataManager

+ (LCDataManager *)sharedDataManager
{
  if (!sharedManager)
  {
    sharedManager = [[LCDataManager alloc] init];
  }
  return sharedManager;
}

@end
