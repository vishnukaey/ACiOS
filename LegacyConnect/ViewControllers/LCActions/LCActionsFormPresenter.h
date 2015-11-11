//
//  LCActionsFormPresenter.h
//  LegacyConnect
//
//  Created by Jijo on 11/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCActionsForm.h"


@interface LCActionsFormPresenter : NSObject

+ (LCActionsForm *)getCreateActionsControllerWithInterest :(LCInterest *)interest;
+ (LCActionsForm *)getEditActionsControllerWithEvent :(LCEvent *)event;

@end
