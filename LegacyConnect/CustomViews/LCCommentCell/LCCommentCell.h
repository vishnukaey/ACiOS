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

@interface LCCommentCell : UITableViewCell
{
  IBOutlet UIImageView *profilePic;
  IBOutlet LCTaggedLabel *userNameLabel;
  IBOutlet UILabel*timeLabel;
  IBOutlet UITextView *commentLabel;
}

@property (nonatomic, strong) LCComment * comment;
@property (readwrite, copy) CommentCellTagAction commentCellTagAction;
@property (weak, nonatomic) IBOutlet UIImageView *seperator;

- (void)setComment:(LCComment *)comment;

@end
