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


@implementation LCFeedsCommentsController
@synthesize feedObject;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];

  [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

  mainTable.rowHeight = UITableViewAutomaticDimension;
  mainTable.estimatedRowHeight = 76.0;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                   selector:@selector(changeFirstResponder)
                                       name:UIKeyboardDidShowNotification
                                     object:nil];

  [self loadFeedAndComments];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - setup functions
-(void)loadFeedAndComments
{
  cellsData = [[NSMutableArray alloc]init];
  [cellsData addObject:feedObject];
  [cellsData addObjectsFromArray:[LCDummyValues dummyCommentArray]];
  [mainTable reloadData];

  UIView* commentntField = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40)];
  [commentntField setBackgroundColor:[UIColor orangeColor]];

  float com_IC_hight = 25;
  float postBut_width = 60;
  float cellMargin_x = 8;
  UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(cellMargin_x, (commentntField.frame.size.height - com_IC_hight)/2, com_IC_hight, com_IC_hight)];
  [commentIcon setImage:[UIImage imageNamed:@"clock.jpg"]];
  [commentntField addSubview:commentIcon];

  commmentTextField = [[UITextField alloc] initWithFrame:CGRectMake(commentIcon.frame.origin.x + commentIcon.frame.size.width + 10, 0, commentntField.frame.size.width - (commentIcon.frame.origin.x + commentIcon.frame.size.width + 10) - postBut_width, commentntField.frame.size.height)];
  [commentntField addSubview:commmentTextField];
  commmentTextField.delegate = self;
  [commmentTextField setBackgroundColor:[UIColor whiteColor]];

  UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(commentntField.frame.size.width - postBut_width, 0, postBut_width, commentntField.frame.size.height)];
  [commentntField addSubview:postButton];
  [postButton setTitle:@"Post" forState:UIControlStateNormal];
  [postButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];

  commmentTextField_dup = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 50, 50)];
  [self.view addSubview:commmentTextField_dup];
  commmentTextField_dup.delegate = self;
  commmentTextField_dup.inputAccessoryView = commentntField;
  [commmentTextField_dup becomeFirstResponder];
}

#pragma mark - button actions
-(void)postAction
{
  [commmentTextField resignFirstResponder];
  [commmentTextField_dup resignFirstResponder];
}

-(void)changeFirstResponder
{
  [commmentTextField becomeFirstResponder]; //will return YES;
}

- (IBAction)backAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  return cellsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCFeedCellView *feedCell;
  LCCommentCell *commentCell;
  if (indexPath.row == 0)//feedcell
  {
    
    static NSString *MyIdentifier = @"LCFeedCell";
    feedCell = (LCFeedCellView *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (feedCell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
      // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
      feedCell = [topLevelObjects objectAtIndex:0];
    }
    [feedCell setData:[cellsData objectAtIndex:indexPath.row] forPage:kCommentsfeedCellID];
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
    static NSString *MyIdentifier = @"LCCommentCell";
    commentCell = (LCCommentCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (commentCell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCCommentCellXIB" owner:self options:nil];
      // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
      commentCell = [topLevelObjects objectAtIndex:0];
    }
    [commentCell setData:[cellsData objectAtIndex:indexPath.row]];
    return commentCell;
  }
  return commentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed*)feed
{
  if (type == kFeedCellActionComment) {
    if (!commmentTextField.isFirstResponder) {
      [commmentTextField_dup becomeFirstResponder];
    }
  }
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
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
  [commmentTextField resignFirstResponder];
  [commmentTextField_dup resignFirstResponder];

  return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
