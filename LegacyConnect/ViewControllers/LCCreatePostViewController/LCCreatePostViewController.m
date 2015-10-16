//
//  LCCreatePostViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCreatePostViewController.h"
#import "LCListFriendsToTagViewController.h"
#import "LCListLocationsToTagVC.h"
#import <CoreText/CoreText.h>

@interface LCCreatePostViewController ()
{
  LCListFriendsToTagViewController *contactListVC;
  
  UIImageView *interstIconImageView;
  UITextView *postTextView;
  UILabel *tagsLabel;
  UIImageView *postImageView;
  
  int keyBoardHeight;
}
@end

#pragma mark - lifecycle methods
@implementation LCCreatePostViewController
@synthesize taggedLocation, friendsTagArray, causesTagArray;
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
  friendsTagArray = [[NSMutableArray alloc] init];
  causesTagArray = [[NSMutableArray alloc] init];
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
//  postTextView.backgroundColor = [UIColor yellowColor];
  [_postScrollView addSubview:postTextView];
  postTextView.delegate = self;
  
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
  for (NSString *cause in causesTagArray) {
    tagsString = [NSString stringWithFormat:@"%@ @%@",tagsString, cause];
  }
  for (NSString *friend in friendsTagArray) {
    tagsString = [NSString stringWithFormat:@"%@ @%@",tagsString, friend];
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
  [friendsTagArray addObject:@"friend1"];
  [friendsTagArray addObject:@"friend2"];
  [friendsTagArray addObject:@"friend3"];
  [self arrangeTaggedLabel];
//  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
//  contactListVC = [sb instantiateViewControllerWithIdentifier:@"LCListFriendsToTagViewController"];
//  [self presentViewController:contactListVC animated:YES completion:nil];
  
}

- (IBAction)addLocationToPostButtonClicked:(id)sender
{
  taggedLocation = [@"cochin" mutableCopy];
  [self arrangeTaggedLabel];
//  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
//  LCListLocationsToTagVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCListLocationsToTagVC"];
//  [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)postPhotoButtonClicked
{
  [postTextView resignFirstResponder];
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library", @"From Camera", nil];
  [sheet showInView:self.view];
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
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

@end
