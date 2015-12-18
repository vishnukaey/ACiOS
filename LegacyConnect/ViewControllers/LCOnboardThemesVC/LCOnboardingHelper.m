//
//  LCOnboardingHelper.m
//  LegacyConnect
//
//  Created by Jijo on 12/17/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardingHelper.h"

static NSMutableDictionary *selectedItemsDictionary;

@implementation LCOnboardingHelper

+(NSMutableDictionary*) selectedItemsDictionary
{
  if (selectedItemsDictionary == nil)
  {
    selectedItemsDictionary = [[NSMutableDictionary alloc] init];
  }
  return selectedItemsDictionary;
}


+ (void)addCause :(LCCause *)cause andInterest:(LCInterest *)interest
{
  if (cause && [[self selectedItemsDictionary] objectForKey:cause.interestID])//interest of the cause is already added
  {
    LCInterest *parentInterest = [self selectedItemsDictionary][cause.interestID];
    for (int i = 0 ;i<parentInterest.causes.count ;i++) {
      LCCause *subcause = parentInterest.causes[i];
      if ([subcause.causeID isEqualToString:cause.causeID]) {
        break;
      }
      else if(i==parentInterest.causes.count-1)
      {
        NSMutableArray *newCauses = [[NSMutableArray alloc] initWithArray:parentInterest.causes];
        [newCauses addObject:cause];
        parentInterest.causes = [NSArray arrayWithArray:newCauses];
        [[self selectedItemsDictionary] setObject:parentInterest forKey:cause.interestID];
      }
    }
  }
  else if (cause && ![[self selectedItemsDictionary] objectForKey:cause.interestID])//interest of the cause is not added yet
  {
    interest.causes = [NSArray arrayWithObjects:cause, nil];
    [[self selectedItemsDictionary] setObject:interest forKey:cause.interestID];
  }
  else if (!cause && interest)//add an interest
  {
    if (![[self selectedItemsDictionary] objectForKey:interest.interestID])
    {
      interest.causes = nil;
      [[self selectedItemsDictionary] setObject:interest forKey:interest.interestID];
    }
  }
}

+ (void)removeCause :(LCCause *)cause
{
    LCInterest *parentInterest = [self selectedItemsDictionary][cause.interestID];
    NSMutableArray *subcauses = [[NSMutableArray alloc] initWithArray:parentInterest.causes];
    for(LCCause *subcause_ in subcauses)
    {
      if ([cause.causeID isEqualToString:subcause_.causeID]) {
        [subcauses removeObject:subcause_];
        break;
      }
    }
    parentInterest.causes = [NSArray arrayWithArray:subcauses];
    [[self selectedItemsDictionary] setObject:parentInterest forKey:parentInterest.interestID];
}

+ (void)removeInterest :(LCInterest *)interest
{
  [[self selectedItemsDictionary] removeObjectForKey:interest.interestID];
}

+ (BOOL)isInterestSelected :(LCInterest *)interest
{
  if ([[LCOnboardingHelper selectedItemsDictionary] objectForKey:interest.interestID])
  {
    return YES;
  }
  return NO;
}

@end
