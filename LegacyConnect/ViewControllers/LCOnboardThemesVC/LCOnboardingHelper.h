//
//  LCOnboardingHelper.h
//  LegacyConnect
//
//  Created by Jijo on 12/17/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCOnboardingHelper : NSObject

+ (void)removeInterest :(LCInterest *)interest fromDictionary:(NSMutableDictionary *)dictionary;
+ (void)removeCause :(LCCause *)cause fromDictionary:(NSMutableDictionary *)dictionary;
+ (void)addCause :(LCCause *)cause andInterest:(LCInterest *)interest toDictionary:(NSMutableDictionary *)dictionary;//pass associated interest when adding causes. Pass nil for causes if adding interests

@end
