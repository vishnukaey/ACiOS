//
//  LCActionHelper.h
//  LegacyConnect
//
//  Created by qbuser on 02/02/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCActionsHeader.h"

@interface LCActionHelper : NSObject

+ (NSString*)getEventDateInfo:(LCEvent*)eventObject;
+ (LCActionsHeader*)getActionsHeaderForSection:(NSInteger)section;

@end
