//
//  LCEventDetailsBaseController.h
//  LegacyConnect
//
//  Created by qbuser on 09/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCommentsController.h"

@interface LCEventDetailsBC : LCCommentsController {
  __weak IBOutlet UIButton *settingsButton;
}

@property (nonatomic, retain) LCEvent *eventObject;

- (void)refreshEventDetails;
- (void)dataPopulation;

@end
