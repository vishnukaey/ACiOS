//
//  LCCreatePostViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCreatePostViewController.h"


#define POSTTEXT_FONT [UIFont fontWithName:@"Gotham-Book" size:12]
@interface LCCreatePostViewController ()
{
  UIImageView *interstIconImageView;
  UITextView *postTextView;
  UILabel *tagsLabel;
  UIImageView *postImageView;
  
  int keyBoardHeight;
  NSArray *taggedFriendsArray;
  
  UILabel *placeHolderLabel;
  
  NSString *taggedLocation;
  
  IBOutlet UIImageView *tagFriendsIcon, *cameraIcon, *tagLocationIcon, *milestoneIcon;
  IBOutlet UILabel *postingToLabel;
}
@end

static NSString *ktagFriendIconImageName = @"createPost_tagFriends";
static NSString *ktagLocationIconImageName = @"createPost_location";
static NSString *kcameraIconImageName = @"createPost_cameraGrey";
static NSString *kmilestoneIconImageName = @"MilestoneIcon";

@implementation LCCreatePostViewController
#pragma mark - lifecycle methods
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
  
  _popUpView.layer.cornerRadius = 5;
  
  
  _popUpViewHeightConstraint.constant = 500;
  
  
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardShown:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardHidden:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  
  [self initialiseScrollSubviewsForPosting];
  [postTextView becomeFirstResponder];
  taggedLocation = [[NSMutableString alloc] initWithString:@""];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - initial setup
- (void)initialiseScrollSubviewsForPosting
{
//  _postScrollView.layer.borderColor = [UIColor redColor].CGColor;
//  _postScrollView.layer.borderWidth = 3;
  
  float topmargin = 8;
  interstIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 50, 50)];
  [_postScrollView addSubview:interstIconImageView];
  interstIconImageView.backgroundColor = [UIColor blackColor];
  
  postTextView = [[UITextView alloc] initWithFrame:CGRectMake(interstIconImageView.frame.origin.x + interstIconImageView.frame.size.width + 8, topmargin, _postScrollView.frame.size.width - (interstIconImageView.frame.origin.x + interstIconImageView.frame.size.width + 8), 35)];
  postTextView.text = @"";
  [postTextView setFrame:CGRectMake(postTextView.frame.origin.x, postTextView.frame.origin.y, postTextView.frame.size.width, postTextView.contentSize.height)];
  [postTextView setFont:POSTTEXT_FONT];
  
//  postTextView.backgroundColor = [UIColor yellowColor];
  [_postScrollView addSubview:postTextView];
  postTextView.delegate = self;
  
  placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(postTextView.frame.origin.x+5, postTextView.frame.origin.y, postTextView.frame.size.width, postTextView.frame.size.height)];
  [placeHolderLabel setFont:POSTTEXT_FONT];
  [placeHolderLabel setText:@"Share your legacy"];
  [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
  [_postScrollView addSubview:placeHolderLabel];

  
  tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(postTextView.frame.origin.x, postTextView.frame.origin.y + postTextView.frame.size.height, postTextView.frame.size.width, 0)];
  tagsLabel.numberOfLines = 0;
//  tagsLabel.backgroundColor = [UIColor orangeColor];
  [_postScrollView addSubview:tagsLabel];
  
  postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, interstIconImageView.frame.origin.y + interstIconImageView.frame.size.height + 8, _postScrollView.frame.size.width, 0)];
//  postImageView.backgroundColor = [UIColor greenColor];
  [_postScrollView addSubview:postImageView];
  
}

#pragma mark - keyboard functions
- (void)keyboardShown:(NSNotification *)notification
{
  // Get the size of the keyboard.
  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  //Given size may not account for screen rotation
  keyBoardHeight = MIN(keyboardSize.height,keyboardSize.width);
  
  float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self.view layoutIfNeeded];
  [UIView animateWithDuration:duration animations:^
   {
      _popUpViewHeightConstraint.constant = self.view.frame.size.height - 2 *_popUpView.frame.origin.y - keyBoardHeight;
     [self.view layoutIfNeeded];
   }completion:^(BOOL finished) {
     [self adjustScrollViewOffsetWhileTextEditing :postTextView];
   }];
}

- (void)keyboardHidden:(NSNotification *)notification
{
  float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self.view layoutIfNeeded];
  [UIView animateWithDuration:duration
                      animations:^
   {
     _popUpViewHeightConstraint.constant = self.view.frame.size.height - 2 *_popUpView.frame.origin.y;
     [self.view layoutIfNeeded];
   }];
   
  }

#pragma mark - view arrangement
- (void)arrangeTaggedLabel
{
  NSString *tagsString = @"";
  for (LCFriend *friend in taggedFriendsArray)
  {
    NSString *friend_name = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    tagsString = [NSString stringWithFormat:@"%@ @%@",tagsString, friend_name];
  }
  
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:@""];
  NSAttributedString *attributtedTagString = [[NSAttributedString alloc] initWithString : tagsString
                                                                             attributes : @{
                                                                                            NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:12],
                                                                                            NSForegroundColorAttributeName : [UIColor colorWithRed:239/255.0 green:100/255.0 blue:77/255.0 alpha:1],
                                                                                            }];
  [attributtedString appendAttributedString:attributtedTagString];
  if (taggedLocation.length>0)
  {
    NSAttributedString *attributtedLocationString = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@"--at %@", taggedLocation]
                                                                                    attributes : @{
                                                                                                   NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:12],
                                                                                                   NSForegroundColorAttributeName : [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1],
                                                                                                   }];
    [attributtedString appendAttributedString:attributtedLocationString];
  }
  [tagsLabel setAttributedText:attributtedString];

  CGRect rect = [attributtedString boundingRectWithSize:CGSizeMake(tagsLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
  [tagsLabel setFrame:CGRectMake(tagsLabel.frame.origin.x, tagsLabel.frame.origin.y, tagsLabel.frame.size.width, rect.size.height)];
  
  [self arrangeScrollSubviewsForPosting];
}

- (void)arrangePostImageView
{
  float ratio = postImageView.image.size.width / postImageView.frame.size.width;
  float height = postImageView.image.size.height / ratio;
  CGSize size = CGSizeMake(postImageView.frame.size.width, height);
  [postImageView setFrame:CGRectMake(postImageView.frame.origin.x, postImageView.frame.origin.y, size.width, size.height)];
  [self arrangeScrollSubviewsForPosting];
}

- (void)arrangeScrollSubviewsForPosting
{
  [tagsLabel setFrame:CGRectMake(postTextView.frame.origin.x, postTextView.frame.origin.y + postTextView.frame.size.height, postTextView.frame.size.width, tagsLabel.frame.size.height)];
  
  float postImageYorigin = tagsLabel.frame.origin.y + tagsLabel.frame.size.height + 8;
  if (postImageYorigin < interstIconImageView.frame.origin.y + interstIconImageView.frame.size.height+8) {
    postImageYorigin = interstIconImageView.frame.origin.y + interstIconImageView.frame.size.height+8;
  }
  [postImageView setFrame:CGRectMake(0, postImageYorigin, _postScrollView.frame.size.width, postImageView.frame.size.height)];
  
  [_postScrollView setContentSize:CGSizeMake(_postScrollView.contentSize.width, postImageView.frame.origin.y + postImageView.frame.size.height)];
  
  UIImage *tagfirends_im = [UIImage imageNamed:ktagFriendIconImageName];
  tagfirends_im = [tagfirends_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  tagFriendsIcon.image = tagfirends_im;
  [tagFriendsIcon setTintColor:[UIColor grayColor]];
  
  UIImage *cam_im = [UIImage imageNamed:kcameraIconImageName];
  cam_im = [cam_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  cameraIcon.image = cam_im;
  [cameraIcon setTintColor:[UIColor grayColor]];
  
  UIImage *tagloc_im = [UIImage imageNamed:ktagLocationIconImageName];
  tagloc_im = [tagloc_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  tagLocationIcon.image = tagloc_im;
  [tagLocationIcon setTintColor:[UIColor grayColor]];
  
  UIImage *miles_im = [UIImage imageNamed:kmilestoneIconImageName];
  miles_im = [miles_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  milestoneIcon.image = miles_im;
  [milestoneIcon setTintColor:[UIColor grayColor]];

  if (taggedFriendsArray.count > 0) {
    [tagFriendsIcon setTintColor:[UIColor blackColor]];
  }
  
  if (taggedLocation.length>0)
  {
    [tagLocationIcon setTintColor:[UIColor blackColor]];
  }
  
  if (postImageView.image)
  {
    [cameraIcon setTintColor:[UIColor blackColor]];
  }
  
  if (1) {
    [milestoneIcon setImage:[UIImage imageNamed:kmilestoneIconImageName]];
  }
}

- (void)adjustScrollViewOffsetWhileTextEditing :(UITextView *)textView
{
  if (textView.selectedTextRange) {
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    float bottommarginAdjustment = textView.font.pointSize*2;
    if (cursorPosition.y + postTextView.frame.origin.y >= _postScrollView.frame.size.height - bottommarginAdjustment + _postScrollView.contentOffset.y) {
      CGPoint pointToScroll = CGPointMake(_postScrollView.contentOffset.x, postTextView.frame.origin.y + cursorPosition.y - _postScrollView.frame.size.height + bottommarginAdjustment);
      [_postScrollView setContentOffset:pointToScroll];
    }
  }
}

#pragma mark - button actions
- (IBAction)closeButtonClicked:(id)sender
{
  [self.delegate dismissCreatePostView];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addFriendsToPostButtonClicked:(id)sender
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
  LCListFriendsToTagViewController *contactListVC = [sb instantiateViewControllerWithIdentifier:@"LCListFriendsToTagViewController"];
  contactListVC.alreadySelectedFriends = taggedFriendsArray;
  contactListVC.delegate = self;
  [self presentViewController:contactListVC animated:YES completion:nil];
  
}

- (IBAction)addLocationToPostButtonClicked:(id)sender
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
  LCListLocationsToTagVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCListLocationsToTagVC"];
  vc.alreadyTaggedLocation = taggedLocation;
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)postPhotoButtonClicked
{
  [postTextView resignFirstResponder];
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library", @"From Camera", nil];
  [sheet showInView:self.view];
}

- (IBAction)intersestDownArrowClicked
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
  LCListInterestsAndCausesVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCListInterestsAndCausesVC"];
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""])
  {
    placeHolderLabel.hidden = false;
  }
  else
  {
    placeHolderLabel.hidden = true;
  }
  [self adjustScrollViewOffsetWhileTextEditing:textView];
  
  CGRect frame = textView.frame;
  frame.size.height = textView.contentSize.height;
  textView.frame = frame;
  [self arrangeScrollSubviewsForPosting];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
////  if ([text isEqualToString:@"\n"]) {
//////    NSLog(@"Return pressed, do whatever you like here");
////    return NO; // or true, whetever you's like
////  }
//  
//  return YES;
//}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex < 2)
  {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    switch (buttonIndex)
    {
      case 0:
        type = UIImagePickerControllerSourceTypePhotoLibrary;
        break;
      case 1:
        type = UIImagePickerControllerSourceTypeCamera;
        break;
        
      default:
        break;
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
  [postImageView setImage:chosenImage];
  [self arrangePostImageView];
}

#pragma mark - LCListFriendsToTagViewControllerDelegate
- (void)didFinishPickingFriends:(NSArray *)friendsArray
{
  taggedFriendsArray = [NSArray arrayWithArray:friendsArray];
  [self arrangeTaggedLabel];
}

#pragma mark - LCListLocationsToTagVCDelegate
- (void)didfinishPickingLocation:(NSString *)location
{
  taggedLocation = location;
  [self arrangeTaggedLabel];
}

#pragma mark - LCListInterestsAndCausesVCDelegate
- (void)didfinishPickingInterest:(LCInterest *)interest andCause:(LCCause *)cause
{
  if (interest) {
    postingToLabel.text = interest.name;
  }
  else if (cause)
  {
    postingToLabel.text = cause.name;
  }
}

@end
