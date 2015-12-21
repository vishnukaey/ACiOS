//
//  LCOnboardingHelper.h
//  LegacyConnect
//
//  Created by Jijo on 12/17/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCOnboardingHelper : NSObject

+ (void)removeInterest :(LCInterest *)interest;
+ (void)removeCause :(LCCause *)cause;
+ (void)addCause :(LCCause *)cause andInterest:(LCInterest *)interest;//pass associated interest when adding causes. Pass nil for causes if adding interests
+ (BOOL)isInterestSelected :(LCInterest *)interest;
+ (BOOL)isCauseSelected:(LCCause *)cause;
+ (NSArray *)sortCausesInInterest:(LCInterest*)interest;
+ (NSArray *)sortInterests:(NSArray*)interests forTheme:(LCTheme *)theme;

+(NSMutableDictionary*) selectedItemsDictionary;
@end
