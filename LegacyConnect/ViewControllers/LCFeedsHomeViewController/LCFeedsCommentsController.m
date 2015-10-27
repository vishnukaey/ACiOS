//
//  LCFeedsCommentsController.m
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsCommentsController.h"
#import "LCCommentCell.h"
#import "LCSingleCauseVC.h"
#import "LCProfileViewVC.h"
#import "LCLoadingCell.h"
#import "LCFullScreenImageVC.h"

static CGFloat kCommentFieldHeight = 45.0f;
static CGFloat kCellForPostDetails = 1;
static CGFloat kCellForLoadMoreBtn = 1;
static CGFloat kIndexForPostDetails = 0;

#define kPostButtonDisabledColor [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define kPostButtonEnabledColor [UIColor colorWithRed:239.0/255 green:100.0/255 blue:77.0/255 alpha:0.9]
#define kPostButtonTextColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
#define kPostBtnFont [UIFont fontWithName:@"Gotham-Book" size:12.0f]
#define kCommentFieldBGColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
#define kCommentFieldBorderColor [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1]
#define kCommentsFieldTextColor [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]
#define kCommentsFieldFont [UIFont fontWithName:@"Gotham-Book" size:16]

@implementation LCFeedsCommentsController
@synthesize feedObject;

#pragma mark - private method implementation
- (void)initialUISetUp
{
  [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  mainTable.rowHeight = UITableViewAutomaticDimension;
  mainTable.estimatedRowHeight = 68.0;
  [self setUpCpmmentsUI];
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

-(void)loadFeedAndCommentsWithLastCommentId:(NSString*)lastId ofCell:(LCLoadingCell*)cell
{
  if(!cell)
  {
    cell = (LCLoadingCell*)[[UIView alloc] init];
  }
  
  [MBProgressHUD showHUDAddedTo:cell animated:YES];
  isLoadingMoreComments = YES;
  [LCAPIManager getCommentsForPost:feedObject.entityID lastCommentId:lastId withSuccess:^(id response, BOOL isMore) {
    isLoadingMoreComments = NO;
    moreCommentsPresent = isMore;
    [commentsArray addObjectsFromArray:(NSArray*)response];
    [MBProgressHUD hideAllHUDsForView:cell animated:YES];
    [mainTable reloadData];
    }andfailure:^(NSString *error){
    isLoadingMoreComments = NO;
    [MBProgressHUD hideAllHUDsForView:cell animated:YES];
    [mainTable reloadData];
  }];
}

- (void)setUpCpmmentsUI
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
  [commentTextField setPlaceholder:@"Comment"];
  [commentTextField setTextColor:kCommentsFieldTextColor];
  [commentTextField setFont:kCommentsFieldFont];
  
  UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(commentField.frame.size.width - postBut_width, 0, postBut_width, commentField.frame.size.height)];
  [postButton setBackgroundColor:kPostButtonDisabledColor];
  [postButton.titleLabel setFont:kPostBtnFont];
  [commentField addSubview:postButton];
  [postButton setTitle:@"POST" forState:UIControlStateNormal];
  [postButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
  postBtn = postButton;
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
  [commentTextField_dup setPlaceholder:@"Comment"];
  [commentTextField_dup setTextColor:kCommentsFieldTextColor];
  [commentTextField_dup setFont:kCommentsFieldFont];
  commentTextField_dup.inputAccessoryView = view;
  
  UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(dummyCommentField.frame.size.width - postBut_width, 0, postBut_width, dummyCommentField.frame.size.height)];
  [postButton setBackgroundColor:kPostButtonDisabledColor];
  [postButton.titleLabel setFont:kPostBtnFont];
  [dummyCommentField addSubview:postButton];
  [postButton setTitle:@"POST" forState:UIControlStateNormal];
  [postButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
  dummyPostBtn = postButton;
  [self.view addSubview:dummyCommentField];
}

-(void)changeFirstResponder
{
  [commentTextField becomeFirstResponder]; //will return YES;
}

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

- (void)changeUpdateButtonState
{
  [postBtn setBackgroundColor: commentTextField.text.length > 0 ? kPostButtonEnabledColor : kPostButtonDisabledColor];
  [dummyPostBtn setBackgroundColor: commentTextField.text.length > 0 ? kPostButtonEnabledColor : kPostButtonDisabledColor];
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  commentsArray = [[NSMutableArray alloc]init];
  moreCommentsPresent = YES;
  [self loadFeedAndCommentsWithLastCommentId:nil ofCell:nil];
  
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:NO];
  [self addKeyBoardNotificationObserver];
  [self addTextFieldTextDidChangeNotifiaction];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [self removeKeyBoardNotificationObserver];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
  [self removeTextFieldTextDidChangeNotifiaction];
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - button actions
-(void)postAction
{
  if (commentTextField.text.length > 0) {
    [self resignAllResponders];
    
    [LCAPIManager commentPost:self.feedObject.entityID comment:commentTextField.text withSuccess:^(id response) {
      [commentsArray insertObject:(LCComment*)response atIndex:0];
      self.feedObject.commentCount = [NSString stringWithFormat:@"%li",[commentsArray count]];
      [commentTextField setText:nil];
      [commentTextField_dup setText:nil];
      [self changeUpdateButtonState];
      [mainTable reloadData];
    } andFailure:^(NSString *error) {
      LCDLog(@"----- Fail to add new comment");
    }];
  }
}

- (IBAction)backAction
{
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return kCellForPostDetails + commentsArray.count + (moreCommentsPresent ? kCellForLoadMoreBtn : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  LCDLog(@"index path row : %li",indexPath.row);
  if (indexPath.row == kIndexForPostDetails)
  {
    LCFeedCellView *feedCell;
    feedCell = (LCFeedCellView *)[tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
    if (feedCell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
      feedCell = [topLevelObjects objectAtIndex:0];
    }
    [feedCell setData:feedObject forPage:kCommentsfeedCellID];
    __weak typeof(self) weakSelf = self;
    feedCell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
      [weakSelf feedCellActionWithType:actionType andFeed:feed];
    };
    feedCell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
      [weakSelf tagTapped:tagDetails];
    };
    return feedCell;
  }
  else //comment cell
  {
    if (moreCommentsPresent && indexPath.row -1 == commentsArray.count)
    {
      LCLoadingCell * loadingCell = (LCLoadingCell*)[tableView dequeueReusableCellWithIdentifier:[LCLoadingCell getFeedCellidentifier]];
      if (loadingCell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCLoadingCell" owner:self options:nil];
        loadingCell = [topLevelObjects objectAtIndex:0];
      }
      return loadingCell;
    }
    else
    {
      LCCommentCell *commentCell;
      static NSString *MyIdentifier = @"LCCommentCell";
      commentCell = (LCCommentCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
      if (commentCell == nil)
      {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCCommentCellXIB" owner:self options:nil];
        commentCell = [topLevelObjects objectAtIndex:0];
      }
      NSInteger rowNo = indexPath.row - 1;
      [commentCell setComment:[commentsArray objectAtIndex:rowNo]];
      [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
      __weak typeof(self) weakSelf = self;
      commentCell.commentCellTagAction = ^ (NSDictionary * tagDetails) {
        [weakSelf tagTapped:tagDetails];
      };
      return commentCell;
    }
  }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row  == commentsArray.count && moreCommentsPresent && !isLoadingMoreComments) {
    if([LCUtilityManager isNetworkAvailable])
    {
      [self loadFeedAndCommentsWithLastCommentId:[(LCComment*)[commentsArray lastObject] commentId] ofCell:(LCLoadingCell*)cell];
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCDLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed*)feed
{
  if (type == kFeedCellActionComment) {
    if (!commentTextField.isFirstResponder) {
      [commentTextField_dup becomeFirstResponder];
    }
  }
  else if (type == kkFeedCellActionViewImage)
  {
    [self showFullScreenImage:feed];
  }
}

- (void)showFullScreenImage:(LCFeed*)feed
{
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
  LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
  vc.feed = feed;
  vc.commentAction = ^ (id sender, BOOL showComments) {
    [sender dismissViewControllerAnimated:YES completion:nil];
  };
  vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:vc animated:YES completion:nil];
}


- (void)tagTapped:(NSDictionary *)tagDetails
{
  LCDLog(@"tag details-->>%@", tagDetails);
  if ([tagDetails[@"type"] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else if ([tagDetails[@"type"] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

#pragma mark - textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self resignAllResponders];
  return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self resignAllResponders];
}

- (void)resignAllResponders
{
  [commentTextField resignFirstResponder];
  [commentTextField_dup resignFirstResponder];
  [commentTextField_dup setText:commentTextField.text];
}

@end
