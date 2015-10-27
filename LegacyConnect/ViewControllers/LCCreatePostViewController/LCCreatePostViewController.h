//
//  LCCreatePostViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCListFriendsToTagViewController.h"
#import "LCListLocationsToTagVC.h"
#import "LCListInterestsAndCausesVC.h"
#import "LCSocialShareManager.h"

@interface LCCreatePostViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, LCListFriendsToTagViewControllerDelegate, LCListLocationsToTagVCDelegate, LCListInterestsAndCausesVCDelegate>


@property(nonatomic,retain) IBOutlet UIView *popUpView;
@property(nonatomic,retain) IBOutlet UIScrollView *postScrollView;
@property(nonatomic,retain) IBOutlet NSLayoutConstraint *popUpViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;


@property(nonatomic, retain) LCFeed *postFeedObject;
@property(nonatomic, retain) UIImage *photoPostPhoto;
@property(nonatomic, retain) LCInterest *selectedInterest;
@property(nonatomic, retain) LCCause *selectedCause;
@property(nonatomic, assign) BOOL isEditing;

@property(nonatomic, retain)LCSocialShareManager *TWsocialShare;

@end
