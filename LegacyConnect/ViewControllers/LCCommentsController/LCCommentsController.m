//
//  LCCommentsController.m
//  LegacyConnect
//
//  Created by qbuser on 05/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCCommentsController.h"
#import "LCSingleCauseVC.h"
#import "LCProfileViewVC.h"

static CGFloat kCommentFieldHeight = 45.0f;
#define kPostButtonDisabledColor [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define kPostButtonEnabledColor [LCUtilityManager getThemeRedColor]
#define kPostButtonTextColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
#define kPostBtnFont [UIFont fontWithName:@"Gotham-Book" size:12.0f]
#define kCommentFieldBGColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
#define kCommentFieldBorderColor [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1]
#define kCommentsFieldTextColor [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]
#define kCommentsFieldFont [UIFont fontWithName:@"Gotham-Book" size:16]

@implementation LCCommentsController

#pragma mark - view life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self setUpCommentsUI];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self addTextFieldTextDidChangeNotifiaction];
  [self addKeyBoardNotificationObserver];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [self resignAllResponders];
  [self removeTextFieldTextDidChangeNotifiaction];
  [self removeKeyBoardNotificationObserver];
  [super viewWillDisappear:animated];
}

#pragma mark - private methods
#pragma mark - Comment fields setup
- (void)setUpCommentsUI
{
  UIView* commentField = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, kCommentFieldHeight)];
  [commentField setBackgroundColor:kCommentFieldBGColor];
  [commentField.layer setBorderColor:kCommentFieldBorderColor.CGColor];
  [commentField.layer setBorderWidth:1.0f];
  
  float com_IC_hight = 20;
  float postBut_width = 60;
  float cellMargin_x = 8;
  UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(cellMargin_x, (commentField.frame.size.height - com_IC_hight)/2, com_IC_hight, com_IC_hight)];
  [commentIcon setImage:[UIImage imageNamed:@"CommentIcon"]];
  [commentField addSubview:commentIcon];
  
  commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(commentIcon.frame.origin.x + commentIcon.frame.size.width + 10, 0, commentField.frame.size.width - (commentIcon.frame.origin.x + commentIcon.frame.size.width + 10) - postBut_width, commentField.frame.size.height)];
  [commentField addSubview:commentTextField];
  commentTextField.delegate = self;
  [commentTextField setBackgroundColor:[UIColor clearColor]];
  [commentTextField setPlaceholder:NSLocalizedString(@"comment_placeholder", @"placeholder")];
  [commentTextField setTextColor:kCommentsFieldTextColor];
  [commentTextField setFont:kCommentsFieldFont];
  
  UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(commentField.frame.size.width - postBut_width, 0, postBut_width, commentField.frame.size.height)];
  [postButton setBackgroundColor:kPostButtonDisabledColor];
  [postButton.titleLabel setFont:kPostBtnFont];
  [commentField addSubview:postButton];
  [postButton setTitle:NSLocalizedString(@"post_caps", @"post button title") forState:UIControlStateNormal];
  [postButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
  postBtn = postButton;
  commentFieldView = commentField;
  [self createDummyCommentFieldViewWithinputAccessoryView:commentField];
}

- (void)createDummyCommentFieldViewWithinputAccessoryView:(UIView*)view
{
  UIView* dummyCommentField = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
  [dummyCommentField setBackgroundColor:kCommentFieldBGColor];
  [dummyCommentField.layer setBorderColor:kCommentFieldBorderColor.CGColor];
  [dummyCommentField.layer setBorderWidth:1.0f];
  
  float com_IC_hight = 20;
  float postBut_width = 60;
  float cellMargin_x = 8;
  UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(cellMargin_x, (dummyCommentField.frame.size.height - com_IC_hight)/2, com_IC_hight, com_IC_hight)];
  [commentIcon setImage:[UIImage imageNamed:@"CommentIcon"]];
  [dummyCommentField addSubview:commentIcon];
  
  commentTextField_dup = [[UITextField alloc] initWithFrame:CGRectMake(commentIcon.frame.origin.x + commentIcon.frame.size.width + 10, 0, dummyCommentField.frame.size.width - (commentIcon.frame.origin.x + commentIcon.frame.size.width + 10) - postBut_width, dummyCommentField.frame.size.height)];
  [dummyCommentField addSubview:commentTextField_dup];
  commentTextField_dup.delegate = self;
  [commentTextField_dup setBackgroundColor:[UIColor clearColor]];
  [commentTextField_dup setPlaceholder:NSLocalizedString(@"comment_placeholder", @"placeholder")];
  [commentTextField_dup setTextColor:kCommentsFieldTextColor];
  [commentTextField_dup setFont:kCommentsFieldFont];
  commentTextField_dup.inputAccessoryView = view;
  
  UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(dummyCommentField.frame.size.width - postBut_width, 0, postBut_width, dummyCommentField.frame.size.height)];
  [postButton setBackgroundColor:kPostButtonDisabledColor];
  [postButton.titleLabel setFont:kPostBtnFont];
  [dummyCommentField addSubview:postButton];
  [postButton setTitle:NSLocalizedString(@"post_caps", @"post button title") forState:UIControlStateNormal];
  [postButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
  dummyPostBtn = postButton;
  [self.view addSubview:dummyCommentField];
  dummyCommentFieldView = dummyCommentField;
}

- (void)hideCommentsFields
{
  [commentFieldView setHidden:YES];
  [dummyCommentFieldView setHidden:YES];
}

- (void)showCommentsField
{
  [commentFieldView setHidden:NO];
  [dummyCommentFieldView setHidden:NO];
}

- (void)resignAllResponders
{
  [commentTextField setEnabled:NO];
  [commentTextField_dup setEnabled:NO];
  [commentTextField resignFirstResponder];
  [commentTextField setEnabled:YES];
  [commentTextField_dup setEnabled:YES];
  [commentTextField_dup setText:commentTextField.text];
}

-(void)changeFirstResponder
{
  if (commentTextField_dup.isFirstResponder) {
    [commentTextField becomeFirstResponder];
  }
}

- (void)changeUpdateButtonState
{
  [postBtn setBackgroundColor:[LCUtilityManager isEmptyString:commentTextField.text] ? kPostButtonDisabledColor : kPostButtonEnabledColor];
  [dummyPostBtn setBackgroundColor:[LCUtilityManager isEmptyString:commentTextField.text] ? kPostButtonDisabledColor : kPostButtonEnabledColor];
}

- (void)enableCommentField:(BOOL)enable
{
  [commentTextField setEnabled:enable];
  [commentTextField_dup setEnabled:enable];
  [postBtn setEnabled:enable];
  [dummyPostBtn setEnabled:enable];
}

- (void)postAction
{
  
}

#pragma mark - textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self resignAllResponders];
  return YES;
}

#pragma mark - UIScrollViewDelegate implementation
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self resignAllResponders];
}

#pragma maek - Notification add/remove methods

- (void)addTextFieldTextDidChangeNotifiaction
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeUpdateButtonState)
                                               name:UITextFieldTextDidChangeNotification
                                             object:nil];
}

- (void)removeTextFieldTextDidChangeNotifiaction
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextFieldTextDidChangeNotification
                                                object:nil];
}

- (void)addKeyBoardNotificationObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeFirstResponder)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
}

- (void)removeKeyBoardNotificationObserver
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - other private methods
- (void)tagTapped:(NSDictionary *)tagDetails
{
  if ([tagDetails[kWordType] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else if ([tagDetails[kWordType] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

@end
