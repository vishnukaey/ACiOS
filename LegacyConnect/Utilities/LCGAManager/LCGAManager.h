//
//  LCGAManager.h
//  LegacyConnect
//
//  Created by Kaey on 11/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCGAManager : NSObject

+(void)ga_trackViewWithName:(NSString*)screenName;
+(void)ga_trackEventWithCategory:(NSString*)category action:(NSString*)action andLabel:(NSString*)label;

@end
