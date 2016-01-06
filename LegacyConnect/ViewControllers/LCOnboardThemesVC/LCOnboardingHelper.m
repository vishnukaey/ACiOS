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
  LCInterest *interestToAdd = [interest copy];
  if (cause && [[self selectedItemsDictionary] objectForKey:cause.interestID])//interest of the cause is already added
  {
    if (![self isCauseSelected:cause]) {
      LCInterest *parentInterest = [self selectedItemsDictionary][cause.interestID];
      NSMutableArray *newCauses = [[NSMutableArray alloc] initWithArray:parentInterest.causes];
      [newCauses addObject:cause];
      parentInterest.causes = [NSArray arrayWithArray:newCauses];
      [[self selectedItemsDictionary] setObject:parentInterest forKey:cause.interestID];
    }
  }
  else if (cause && ![[self selectedItemsDictionary] objectForKey:cause.interestID])//interest of the cause is not added yet
  {
    interestToAdd.causes = [NSArray arrayWithObjects:cause, nil];
    [[self selectedItemsDictionary] setObject:interestToAdd forKey:cause.interestID];
  }
  else if (!cause && interest)//add an interest
  {
    if (![[self selectedItemsDictionary] objectForKey:interest.interestID])
    {
      interestToAdd.causes = nil;
      [[self selectedItemsDictionary] setObject:interestToAdd forKey:interestToAdd.interestID];
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

+ (BOOL)isCauseSelected:(LCCause *)cause
{
  if ([[self selectedItemsDictionary] objectForKey:cause.interestID])
  {
    LCInterest *parentInterest = [self selectedItemsDictionary][cause.interestID];
    for (int i = 0 ;i<parentInterest.causes.count ;i++) {
      LCCause *subcause = parentInterest.causes[i];
      if ([subcause.causeID isEqualToString:cause.causeID]) {
        return YES;
      }
    }
  }
  return NO;
}

+ (BOOL)noInterestSelected
{
  if ([[LCOnboardingHelper selectedItemsDictionary] allKeys].count > 0) {
    return NO;
  }
  return YES;
}


//+ (NSArray *)sortAndCombineCausesArray:(NSArray*)causes
//{
//  LCCause *cause = [causes firstObject];
//  LCInterest *selectedInterest = [[self selectedItemsDictionary] objectForKey:cause.interestID];
//  NSArray *selectedCauses = selectedInterest.causes;
//  selectedCauses = [self sortCausesArrayWithName:selectedCauses];
//  
//  NSMutableArray *allCauses = [[NSMutableArray alloc] initWithArray: causes];
//  [allCauses removeObjectsInArray:selectedCauses];
//  NSArray *remaingCauses = [self sortCausesArrayWithName:allCauses];
//  
//  NSMutableArray *combinedArray = [[NSMutableArray alloc] initWithArray:selectedCauses];
//  [combinedArray addObjectsFromArray:remaingCauses];
//  
//  return combinedArray;
//}

//+ (NSArray *)sortInterests:(NSArray*)interests forTheme:(LCTheme *)theme
//{
//  NSMutableArray *allSelectedInterests = [[NSMutableArray alloc]initWithArray:[selectedItemsDictionary allValues]];
//  
//  NSArray *selectedInterests = [NSArray arrayWithArray:[allSelectedInterests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"themeID == '%@'",theme.themeID]]]];
//  selectedInterests = [self sortCausesArrayWithName:selectedInterests];
//  
//  NSMutableArray *allInterests = [[NSMutableArray alloc] initWithArray: interests];
//  for (int i = 0; i<selectedInterests.count; i++)
//  {
//    LCInterest *_interest = selectedInterests[i];
//    [allInterests removeObjectsInArray:[allInterests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"interestID == '%@'",_interest.interestID]]]];
//  }
//  
//  NSArray *remaingInterests = [self sortCausesArrayWithName:allInterests];
//  NSMutableArray *combinedArray = [[NSMutableArray alloc] initWithArray:selectedInterests];
//  [combinedArray addObjectsFromArray:remaingInterests];
//  return combinedArray;
//}

//+ (NSArray*)sortCausesArrayWithName:(NSArray*)array {
//  
//  NSSortDescriptor *sortDescriptor;
//  sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
//                                               ascending:YES];
//  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//  NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
//  return sortedArray;
//
//}

@end
