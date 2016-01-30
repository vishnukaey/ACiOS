//
//  TableViewCell.h
//  LegacyConnect
//
//  Created by User on 8/10/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTaggedLabel.h"

typedef void (^CommentCellTagAction)(NSDictionary* tagDetails);
typedef void (^CommentCellMoreAction)();

@interface LCCommentCell : UITableViewCell
{
  IBOutlet UIImageView *profilePic;
  IBOutlet LCTaggedLabel *userNameLabel;
  IBOutlet UILabel*timeLabel;
  IBOutlet UITextView *commentLabel;
  __weak IBOutlet UIButton *moreButton;
  
}

@property (nonatomic, strong) LCComment * comment;
@property (readwrite, copy) CommentCellTagAction commentCellTagAction;
@property (readwrite, copy) CommentCellMoreAction commentCellMoreAction;
@property (weak, nonatomic) IBOutlet UIImageView *seperator;

- (void)setComment:(LCComment *)comment;

@end
