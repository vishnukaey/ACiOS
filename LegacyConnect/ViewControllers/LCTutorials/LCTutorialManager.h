//
//  LCTutorialManager.h
//  LegacyConnect
//
//  Created by Jijo on 3/16/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCTutorialManager : NSObject

+ (void)showHomeFeedTutorial;
+(id)getViewFromXIBForClass :(Class)classType;

@end
