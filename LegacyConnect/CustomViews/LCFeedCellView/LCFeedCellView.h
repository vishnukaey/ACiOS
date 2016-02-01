//
//  feedCellView.h
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTaggedLabel.h"
#import "LCThanksButtonImage.h"

typedef enum {
  kFeedCellActionLike,
  kFeedCellActionComment,
  kkFeedCellActionViewImage,
  kkFeedCellActionLoadMore,
  kkFeedCellActionReport
} kkFeedCellActionType;

typedef enum
{
  kkFeedTagTypeCause,
  kkFeedTagTypeUser
} kkFeedTagType;

typedef void (^FeedCellAction)(kkFeedCellActionType feedCellAction, LCFeed * feed);
typedef void (^FeedCellTagAction)(NSDictionary* tagDetails);

@interface LCFeedCellView : UITableViewCell
{
  IBOutlet UIImageView *profilePic;
  IBOutlet UIImageView *postPhoto;
  IBOutlet UIImageView *moreIcon,*milestoneImage;
  LCThanksButtonImage *thanksBtnImage;
  IBOutlet UILabel  *timeLabel, *thanksLabel, *commentsLabel;
  IBOutlet LCTaggedLabel *usernameLabel, *createdLabel, *postDescription;
  IBOutlet NSLayoutConstraint *postPhotoHeight, *topBorderheight, *bottomBorderHeight;
  IBOutlet UIButton * likeBtn;
  IBOutlet UIButton *fullScreenImageButton;
  IBOutlet UIButton *retryButton;
  IBOutlet UIActivityIndicatorView *imageLoadingActivity;
}

@property(nonatomic, retain)id delegate;
@property(nonatomic, weak)LCFeed *feedObject;
@property(nonatomic, weak)IBOutlet UIButton *moreButton;
@property(nonatomic, weak)IBOutlet UIButton *reportButton;
@property (readwrite, copy) FeedCellAction feedCellAction;
@property (readwrite, copy) FeedCellTagAction feedCellTagAction;

+ (NSString*)getFeedCellIdentifier;

- (void)setData :(LCFeed *)dic forPage :(NSString *)pageType;
@end
