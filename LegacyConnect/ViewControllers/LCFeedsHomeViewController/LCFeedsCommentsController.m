//
//  LCFeedsCommentsController.m
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsCommentsController.h"
#import "LCCommentCell.h"


@implementation LCFeedsCommentsController

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];

  [H_mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  H_mainTable.estimatedRowHeight = 44.0;
  H_mainTable.rowHeight = UITableViewAutomaticDimension;

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
  NSDictionary *postDetail = [[LCDummyValues dummyFeedArray] objectAtIndex:0];//post data
  H_cellsData = [[NSMutableArray alloc]init];
  [H_cellsData addObject:postDetail];
  [H_cellsData addObjectsFromArray:[LCDummyValues dummyCommentArray]];
  [H_mainTable reloadData];

  UIView* commentntField = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40)];
  [commentntField setBackgroundColor:[UIColor orangeColor]];

  float com_IC_hight = 25;
  float postBut_width = 60;
  float cellMargin_x = 8;
  UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(cellMargin_x, (commentntField.frame.size.height - com_IC_hight)/2, com_IC_hight, com_IC_hight)];
  [commentIcon setImage:[UIImage imageNamed:@"clock.jpg"]];
  [commentntField addSubview:commentIcon];

  H_commmentTextField = [[UITextField alloc] initWithFrame:CGRectMake(commentIcon.frame.origin.x + commentIcon.frame.size.width + 10, 0, commentntField.frame.size.width - (commentIcon.frame.origin.x + commentIcon.frame.size.width + 10) - postBut_width, commentntField.frame.size.height)];
  [commentntField addSubview:H_commmentTextField];
  H_commmentTextField.delegate = self;
  [H_commmentTextField setBackgroundColor:[UIColor whiteColor]];

  UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(commentntField.frame.size.width - postBut_width, 0, postBut_width, commentntField.frame.size.height)];
  [commentntField addSubview:postButton];
  [postButton setTitle:@"Post" forState:UIControlStateNormal];
  [postButton addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];

  H_dup = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 50, 50)];
  [self.view addSubview:H_dup];
  H_dup.delegate = self;
  H_dup.inputAccessoryView = commentntField;
//  [H_dup becomeFirstResponder];
}

#pragma mark - button actions
-(void)postAction
{
  [H_commmentTextField resignFirstResponder];
  [H_dup resignFirstResponder];
}

-(void)changeFirstResponder
{
  [H_commmentTextField becomeFirstResponder]; //will return YES;
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
    
  return H_cellsData.count;
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
    [feedCell setData:[H_cellsData objectAtIndex:indexPath.row] forPage:kCommentsfeedCellID];
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
    [commentCell setData:[H_cellsData objectAtIndex:indexPath.row]];
    return commentCell;
  }
  return commentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
-(void)feedCellActionWithType:(NSString *)type andID:(NSString *)postID
{
  NSLog(@"actionTypecommentpage--->>>%@", type);
  if ([type isEqualToString:kFeedCellActionComment])
  {
    [H_dup becomeFirstResponder];
  }
}

#pragma mark - textfield delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [H_commmentTextField resignFirstResponder];
  [H_dup resignFirstResponder];

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
