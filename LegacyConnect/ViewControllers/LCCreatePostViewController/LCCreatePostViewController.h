//
//  LCCreatePostViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol createPostDelegate <NSObject>

- (void)dismissView;

@end

@interface LCCreatePostViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>


@property (nonatomic, unsafe_unretained) NSObject <createPostDelegate> *delegate;

@property(nonatomic,retain) IBOutlet UIButton *closeButton;
@property(nonatomic,retain) IBOutlet UIButton *postButton;
@property(nonatomic,retain) IBOutlet UIButton *postToFacebook;
@property(nonatomic,retain) IBOutlet UIButton *postToTwitter;
@property(nonatomic,retain) IBOutlet UIButton *selectInterest;

@property(nonatomic,retain) IBOutlet UIButton *addFriendsToPost;
@property(nonatomic,retain) IBOutlet UIButton *addImageToPost;
@property(nonatomic,retain) IBOutlet UIButton *addLocationToPost;
@property(nonatomic,retain) IBOutlet UIButton *addMilestone;

@property(nonatomic,retain) IBOutlet UIImageView *interestImageView;
@property(nonatomic,retain) IBOutlet UIImageView *postImageView;

@property(nonatomic,retain) IBOutlet UITextView *postTextView;
@property(nonatomic,retain) IBOutlet UILabel *placeHolderText;


@end
