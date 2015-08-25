//
//  feedCellView.h
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTaggedLabel.h"

//--------------protocols
@protocol feedCellDelegate <NSObject>

-(void)feedCellActionWithType :(NSString *)type andFeed:(LCFeed *)feed;
-(void)tagTapped :(NSDictionary *)tagDetails;

@end

//---------------interface
@interface LCFeedCellView : UITableViewCell
{
  IBOutlet UIImageView *profilePic;
  IBOutlet UIImageView *postPhoto;
  IBOutlet UILabel *usernameLabel, *createdLabel, *timeLabel, *thanksLabel, *commentsLabel;
  IBOutlet LCTaggedLabel *postDescription;
  IBOutlet NSLayoutConstraint *postPhotoHeight, *topBorderheight, *bottomBorderHeight;
}

@property(nonatomic, retain)id delegate;
@property(nonatomic, weak)LCFeed *feedObject;

- (void)setData :(NSDictionary *)dic forPage :(NSString *)pageType;
- (IBAction)likeAction;
- (IBAction)commentAction;
- (IBAction)imageFullscreenAction;

@end
