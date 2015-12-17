//
//  LCOnboardingHelper.m
//  LegacyConnect
//
//  Created by Jijo on 12/17/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardingHelper.h"

@implementation LCOnboardingHelper

+ (void)addCause :(LCCause *)cause andInterest:(LCInterest *)interest toDictionary:(NSMutableDictionary *)dictionary
{
  if (cause && [dictionary objectForKey:cause.interestID])//interest of the cause is already added
  {
    LCInterest *parentInterest = dictionary[cause.interestID];
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
        [dictionary setObject:parentInterest forKey:cause.interestID];
      }
    }
  }
  else if (cause && ![dictionary objectForKey:cause.interestID])//interest of the cause is not added yet
  {
    interest.causes = [NSArray arrayWithObjects:cause, nil];
    [dictionary setObject:interest forKey:cause.interestID];
  }
  else if (!cause && interest)//add an interest
  {
    if (![dictionary objectForKey:interest.interestID])
    {
      interest.causes = nil;
      [dictionary setObject:interest forKey:interest.interestID];
    }
  }
  
}

+ (void)removeCause :(LCCause *)cause fromDictionary:(NSMutableDictionary *)dictionary
{
    LCInterest *parentInterest = dictionary[cause.interestID];
    NSMutableArray *subcauses = [[NSMutableArray alloc] initWithArray:parentInterest.causes];
    for(LCCause *subcause_ in subcauses)
    {
      if ([cause.causeID isEqualToString:subcause_.causeID]) {
        [subcauses removeObject:subcause_];
        break;
      }
    }
    parentInterest.causes = [NSArray arrayWithArray:subcauses];
    [dictionary setObject:parentInterest forKey:parentInterest.interestID];
}

+ (void)removeInterest :(LCInterest *)interest fromDictionary:(NSMutableDictionary *)dictionary
{
  [dictionary removeObjectForKey:interest.interestID];
}

@end
