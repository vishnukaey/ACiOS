//
//  LCCreatePostViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCreatePostViewController.h"
#import "UIImage+LCImageFix.h"

#define ICONBACK_COLOR [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]
#define kListFriendSBID @"LCListFriendsToTagViewController"
#define kListLocationSBID @"LCListLocationsToTagVC"
#define kListInterestsAndCauseSBID @"LCListInterestsAndCausesVC"
@interface LCCreatePostViewController ()
{
  int keyBoardHeight;
  IBOutlet UIView *fadedActivityView;
}
@end


@implementation LCCreatePostViewController
#pragma mark - lifecycle methods
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
  self.popUpView.layer.cornerRadius = 5;
  self.popUpViewHeightConstraint.constant = 500;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardShown:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardHidden:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  self.taggedLocation = [[NSMutableString alloc] initWithString:@""];
  self.postingToLabel.text = @"";
  
  if (!self.postFeedObject)
  {
    self.postFeedObject = [[LCFeed alloc] init];
  }
  
  
  if (self.selectedCause || self.selectedInterest) {
      [self didfinishPickingInterest:self.selectedInterest andCause:self.selectedCause];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard functions
- (void)keyboardShown:(NSNotification *)notification
{
  // Get the size of the keyboard.
  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  keyBoardHeight = MIN(keyboardSize.height,keyboardSize.width);
  
  float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self.view layoutIfNeeded];
  [UIView animateWithDuration:duration animations:^
   {
      self.popUpViewHeightConstraint.constant = self.view.frame.size.height - 2 *self.popUpView.frame.origin.y - keyBoardHeight;
     [self.view layoutIfNeeded];
   }completion:^(BOOL finished) {
     [self adjustScrollViewOffsetWhileTextEditing :self.postTextView];
   }];
}

- (void)keyboardHidden:(NSNotification *)notification
{
  float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self.view layoutIfNeeded];
  [UIView animateWithDuration:duration
                      animations:^
   {
     self.popUpViewHeightConstraint.constant = self.view.frame.size.height - 2 *self.popUpView.frame.origin.y;
     [self.view layoutIfNeeded];
   }];
}

#pragma mark - button actions
- (IBAction)closeButtonClicked:(id)sender
{
  UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"close_post", nil) message:NSLocalizedString(@"close_post_message", nil) preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *deletePostAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"discard", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
  [deleteAlert addAction:deletePostAction];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [deleteAlert addAction:cancelAction];
  [self presentViewController:deleteAlert animated:YES completion:nil];
}

- (IBAction)addFriendsToPostButtonClicked:(id)sender
{
  UIStoryboard*  createPostSB = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
  LCListFriendsToTagViewController *contactListVC = [createPostSB instantiateViewControllerWithIdentifier:kListFriendSBID];
  contactListVC.alreadySelectedFriends = self.taggedFriendsArray;
  contactListVC.delegate = self;
  [self presentViewController:contactListVC animated:YES completion:nil];
  
}

- (IBAction)addLocationToPostButtonClicked:(id)sender
{
  UIStoryboard*  createPostSB = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
  LCListLocationsToTagVC *locationsVC = [createPostSB instantiateViewControllerWithIdentifier:kListLocationSBID];
  locationsVC.alreadyTaggedLocation = self.taggedLocation;
  locationsVC.delegate = self;
  [self presentViewController:locationsVC animated:YES completion:nil];
}

- (IBAction)postPhotoButtonClicked
{
  [self.postTextView resignFirstResponder];
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select_photo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"from_library", nil), NSLocalizedString(@"from_camera", nil), nil];
  [sheet showInView:self.view];
}

- (IBAction)milestonesButtonClicked
{
  if (self.milestoneIcon.tag == 0)
  {
    self.milestoneIcon.tag = 1;
    [self.milestoneIcon setImage:[UIImage imageNamed:kmilestoneIconImg]];
  }
  else
  {
    self.milestoneIcon.tag = 0;
    UIImage *miles_im = [UIImage imageNamed:kmilestoneIconImg];
    miles_im = [miles_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.milestoneIcon.image = miles_im;
    [self.milestoneIcon setTintColor:[UIColor grayColor]];
  }
}

- (IBAction)intersestDownArrowClicked
{
  UIStoryboard*  createPostSB = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
  LCListInterestsAndCausesVC *interestCauseVC = [createPostSB instantiateViewControllerWithIdentifier:kListInterestsAndCauseSBID];
  interestCauseVC.delegate = self;
  interestCauseVC.selectedCause = self.selectedCause;
  interestCauseVC.selectedInterest = self.selectedInterest;
  [self presentViewController:interestCauseVC animated:YES completion:nil];
}

- (BOOL)validatPostFieldsWithPostText :(NSString *)post_Text
{
  if (self.selectedInterest)
  {
    self.postFeedObject.postToType = kFeedTagTypeInterest;
    self.postFeedObject.postToID = self.selectedInterest.interestID;
  }
  else if (self.selectedCause)
  {
    self.postFeedObject.postToType = kFeedTagTypeCause;
    self.postFeedObject.postToID = self.selectedCause.causeID;
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:NSLocalizedString(@"missing_fields", nil) andMessage:NSLocalizedString(@"interest_tag_missing_message", nil)];
    return false;
  }
  if (post_Text.length<1 && !self.postImageView.image) {
    [LCUtilityManager showAlertViewWithTitle:NSLocalizedString(@"missing_fields", nil) andMessage:NSLocalizedString(@"text_missing_message", nil)];
    return false;
  }
  return true;
}

- (IBAction)postButtonAction
{
  NSString *text_to_post = [LCUtilityManager getSpaceTrimmedStringFromString:self.postTextView.text];
  if ([self validatPostFieldsWithPostText:text_to_post] == false) {
    return;
  }
  
  [self.postTextView resignFirstResponder];
  self.postFeedObject.message = text_to_post;
  self.postFeedObject.location = self.taggedLocation;
  NSMutableArray *posttags_ = [[NSMutableArray alloc] init];
  for (LCFriend *friend in self.taggedFriendsArray)
  {
    LCTag *tag = [[LCTag alloc] init];
    tag.type = kFeedTagTypeUser;
    tag.tagID = friend.friendId;
    tag.text = [NSString stringWithFormat:@"%@ %@", [LCUtilityManager performNullCheckAndSetValue:friend.firstName],
                [LCUtilityManager performNullCheckAndSetValue:friend.lastName]];
    [posttags_ addObject:tag];
  }
  
  self.postFeedObject.postTags = [posttags_ copy];
  self.postFeedObject.isMilestone = [NSString stringWithFormat:@"%ld",(long)self.milestoneIcon.tag];
  //posting api
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  fadedActivityView.hidden = false;
  if (_isEditing)
  {
    [self invokeUpdatePostAPI];
  }
  else//new
  {
    [self invokeCreateNewPostAPI];
  }
}

- (void)invokeUpdatePostAPI
{
  UIImage *imageToUpload = nil;
  if (self.isImageEdited) {
    imageToUpload = self.postImageView.image;
  }
  [LCPostAPIManager updatePost:self.postFeedObject withImage:imageToUpload withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    fadedActivityView.hidden = true;
    [self shareToSocialMedia];
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    fadedActivityView.hidden = true;
  }];
}

- (void)invokeCreateNewPostAPI
{
  [LCPostAPIManager createNewPost:self.postFeedObject withImage:self.postImageView.image withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    fadedActivityView.hidden = true;
    [self shareToSocialMedia];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.postImageView.image)
    {
      //GA Tracking
      [LCGAManager ga_trackEventWithCategory:@"Impacts" action:@"Post Created" andLabel:@"Post created without media"];
    }
    else
    {
      //GA Tracking
      [LCGAManager ga_trackEventWithCategory:@"Impacts" action:@"Post Created" andLabel:@"Post created with media content"];
    }
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    fadedActivityView.hidden = true;
  }];
}

- (IBAction)facebookButtonAction:(id)sender {
  
  if (self.facebookButton.isSelected) {
    self.facebookButton.selected = NO;
  }
  else{
    
    [LCSocialShareManager canShareToFacebook:^(BOOL canShare) {
      
      if (canShare) {
        self.facebookButton.selected = YES;
      }
    }];
  }
}

- (IBAction)twitterButtonAction:(id)sender {
  
  if (self.twitterButton.isSelected) {
    
    self.twitterButton.selected = NO;
  }
  else {
    self.twitterButton.enabled = NO;
    self.TWsocialShare = [[LCSocialShareManager alloc] init];
    self.TWsocialShare.presentingController = self;
    [self.TWsocialShare canShareToTwitter:^(BOOL canShare) {
      if (canShare) {
        self.twitterButton.selected = YES;
      }
      self.twitterButton.enabled = YES;
    }];
  }
}

- (void)shareToSocialMedia {
  
  //facebook sharing
  if (self.facebookButton.isSelected) {
    
    LCSocialShareManager *socialShare = [[LCSocialShareManager alloc] init];
    [socialShare shareToFacebookWithMessage:self.postFeedObject.message andImage:self.postImageView.image];
  }
  
  //twitter sharing
  if (self.twitterButton.isSelected) {
    
    [self.TWsocialShare shareToTwitterWithStatus:self.postFeedObject.message andImage:self.postImageView.image];
  }
}




#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex < 2)
  {
    LCImagePickerController * imagePicker = [[LCImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
      type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1)
    {
      type = UIImagePickerControllerSourceTypeCamera;
    }
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{ }];
  }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  UIImage *normalzedImage = [chosenImage normalizedImage];
  
  [self.postImageView setImage:normalzedImage];
  [self arrangePostImageView];
  [LCUtilityManager setLCStatusBarStyle];
  
  self.isImageEdited = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
  [LCUtilityManager setLCStatusBarStyle];
}

#pragma mark - LCListFriendsToTagViewControllerDelegate
- (void)didFinishPickingFriends:(NSArray *)friendsArray
{
  self.taggedFriendsArray = [NSArray arrayWithArray:friendsArray];
  [self arrangeTaggedLabel];
}

#pragma mark - LCListLocationsToTagVCDelegate
- (void)didfinishPickingLocation:(NSString *)location
{
  self.taggedLocation = location;
  [self arrangeTaggedLabel];
}

#pragma mark - LCListInterestsAndCausesVCDelegate
- (void)didfinishPickingInterest:(LCInterest *)interest andCause:(LCCause *)cause
{
  [super didfinishPickingInterest:interest andCause:cause];
}

@end
