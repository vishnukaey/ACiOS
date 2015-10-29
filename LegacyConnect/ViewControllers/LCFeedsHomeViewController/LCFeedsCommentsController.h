//
//  LCFeedsCommentsController.h
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedCellView.h"
#import <JTTableViewController.h>

@interface LCFeedsCommentsController : JTTableViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
  UITextField *commentTextField, *commentTextField_dup;//h_dup is for pushing the keyboard as it wont push for commentfield as it is the input accessory view
  UIButton * postBtn,*dummyPostBtn;
  __weak IBOutlet UILabel *commentTitleLabel;
}

@property(nonatomic, retain)LCFeed *feedObject;

- (IBAction)backAction;

@end
