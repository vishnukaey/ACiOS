//
//  LCInterestActions.h
//  LegacyConnect
//
//  Created by Akhil K C on 1/4/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTTableViewController.h"

@protocol LCInterestActionsDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCInterestActions : JTTableViewController

@property(nonatomic, retain) LCInterest *interest;
@property (nonatomic, assign) id<LCInterestActionsDelegate> delegate;
- (void) loadActionsInCurrentInterest;

@end
