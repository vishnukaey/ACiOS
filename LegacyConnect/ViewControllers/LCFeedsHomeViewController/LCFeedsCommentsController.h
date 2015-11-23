//
//  LCFeedsCommentsController.h
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"
#import "LCCommentsController.h"

@interface LCFeedsCommentsController : LCCommentsController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
  __weak IBOutlet UILabel *commentTitleLabel;
}

@property(nonatomic, retain)NSString *feedId;
@property(nonatomic, retain)LCFeed *feedObject;

- (IBAction)backAction;

@end
