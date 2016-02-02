//
//  LCCreatePostBC.h
//  LegacyConnect
//
//  Created by Jijo on 2/2/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ktagFriendIconImg = @"createPost_tagFriends";
static NSString *ktagLocationIconImg = @"createPost_location";
static NSString *kcameraIconImg = @"createPost_cameraGrey";
static NSString *kmilestoneIconImg = @"MilestoneIcon";

@interface LCCreatePostBC : UIViewController<UITextViewDelegate>

@property(nonatomic, strong) UITextView *postTextView;
@property(nonatomic, strong) UIImageView *postImageView;
@property(nonatomic, retain) UIImage *photoPostPhoto;
@property(nonatomic, retain) LCFeed *postFeedObject;
@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *taggedLocation;
@property(nonatomic, retain) UIImageView *interstIconImageView;
@property(nonatomic, retain) LCInterest *selectedInterest;
@property(nonatomic, retain) LCCause *selectedCause;
@property(nonatomic, retain) NSArray *taggedFriendsArray;

@property(nonatomic,retain) IBOutlet UIView *popUpView;
@property(nonatomic,retain) IBOutlet UIScrollView *postScrollView;
@property(nonatomic,retain) IBOutlet NSLayoutConstraint *popUpViewHeightConstraint;
@property(weak, nonatomic) IBOutlet UIButton *facebookButton;
@property(weak, nonatomic) IBOutlet UIButton *twitterButton;
@property(weak, nonatomic) IBOutlet UIImageView *tagFriendsIcon, *cameraIcon, *tagLocationIcon, *milestoneIcon;
@property(weak, nonatomic) IBOutlet UILabel *postingToLabel;


- (void)adjustScrollViewOffsetWhileTextEditing :(UITextView *)textView;
- (void)arrangeScrollSubviewsForPosting;
- (void)arrangePostImageView;
- (void)arrangeTaggedLabel;
- (void)didfinishPickingInterest:(LCInterest *)interest andCause:(LCCause *)cause;

@end
