//
//  LCFeedsCommentsController.m
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsCommentsController.h"


@implementation LCFeedsCommentsController

- (void)viewDidLoad
{
  [super viewDidLoad];

  H_mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y)];

  H_mainTable.layer.borderColor = [UIColor greenColor].CGColor;
  H_mainTable.layer.borderWidth = 3;
  H_mainTable.delegate = self;
  H_mainTable.dataSource = self;
  [H_mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                   selector:@selector(changeFirstResponder)
                                       name:UIKeyboardDidShowNotification
                                     object:nil];

  [self prepareCells];
}

-(void)prepareCells
{
  NSDictionary *postDetail = [[LCDummyValues dummyFeedArray] objectAtIndex:0];//post data
  NSArray *commentsArray = [LCDummyValues dummyCommentArray];

  H_cellsViewArray = [[NSMutableArray alloc]init];

  LCFeedCellView *postView = [[LCFeedCellView alloc]init];
  [postView arrangeSelfForData:postDetail forWidth:H_mainTable.frame.size.width forPage:2];
  postView.delegate = self;
  [H_cellsViewArray addObject:postView];

  UIFont *bigFont = [UIFont systemFontOfSize:15];
  UIFont *smallFont = [UIFont systemFontOfSize:12];
  float cellMargin_x = 15, cellMargin_y = 8;
  float dp_im_hight = 60;
  float timeWidth_ = 80;
  float in_margin = 10;
  
  for (int i=0; i<commentsArray.count; i++)
  {
    NSString  *userName = [[commentsArray objectAtIndex:i] valueForKey:@"user_name"];
    NSString *time_ = [[commentsArray objectAtIndex:i] valueForKey:@"time"];
    NSString *comments_ = [[commentsArray objectAtIndex:i] valueForKey:@"comment"];
    float top_space = cellMargin_y;

    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, H_mainTable.frame.size.width, 0)];
    UIImageView *dp_view = [[UIImageView alloc]initWithFrame:CGRectMake(cellMargin_x, top_space, dp_im_hight, dp_im_hight)];
    [dp_view setImage:[UIImage imageNamed:@"clock.jpg"]];
    [cellView addSubview:dp_view];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(dp_view.frame.origin.x
                                                                 + dp_view.frame.size.width + in_margin, top_space, (cellView.frame.size.width - cellMargin_x - timeWidth_) - (dp_view.frame.origin.x
                                                                                                                                                                               + dp_view.frame.size.width + in_margin), 0)];
    nameLabel.font = bigFont;
    nameLabel.numberOfLines = 0;
    [cellView addSubview:nameLabel];
    NSMutableAttributedString * name_attributtedString = [[NSMutableAttributedString alloc] initWithString:userName attributes : @{
                                                                                                                                NSFontAttributeName : bigFont,
                                                                                                                                NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                                                                }];
    [nameLabel setAttributedText:name_attributtedString];

    CGRect  rect = [name_attributtedString boundingRectWithSize:CGSizeMake(nameLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, nameLabel.frame.size.width, rect.size.height)];

    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellView.frame.size.width - cellMargin_x - timeWidth_, top_space, timeWidth_, 15)];
    timeLabel.font = smallFont;
    timeLabel.text = time_;
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setTextColor:[UIColor lightGrayColor]];
    [cellView addSubview:timeLabel];

    top_space +=nameLabel.frame.size.height + in_margin;

    UILabel *postLabel = [[UILabel alloc]initWithFrame:CGRectMake(dp_view.frame.origin.x
                                                                  + dp_view.frame.size.width + in_margin, top_space, cellView.frame.size.width - 2*cellMargin_x - dp_view.frame.size.width - in_margin, 0)];
    postLabel.font = bigFont;
    postLabel.numberOfLines = 0;
    [cellView addSubview:postLabel];
    NSMutableAttributedString * post_attributtedString = [[NSMutableAttributedString alloc] initWithString:comments_ attributes : @{
                                                                                                                                   NSFontAttributeName : bigFont,
                                                                                                                                   NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                                                                   }];
    [postLabel setAttributedText:post_attributtedString];

    rect = [post_attributtedString boundingRectWithSize:CGSizeMake(postLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    [postLabel setFrame:CGRectMake(postLabel.frame.origin.x, postLabel.frame.origin.y, postLabel.frame.size.width, rect.size.height)];

    top_space = top_space + postLabel.frame.size.height;
    if (top_space<dp_view.frame.origin.y + dp_view.frame.size.height)
    {
      top_space = dp_view.frame.origin.y + dp_view.frame.size.height;
    }
    top_space+=cellMargin_y;

    [cellView setFrame:CGRectMake(cellView.frame.origin.x, cellView.frame.origin.y, cellView.frame.size.width, top_space)];
    [H_cellsViewArray addObject:cellView];
  }
  [self.view addSubview:H_mainTable];

  UIView* commentntField = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
  [commentntField setBackgroundColor:[UIColor orangeColor]];

  float com_IC_hight = 25;
  float postBut_width = 60;
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
  [H_dup becomeFirstResponder];
}

-(void)postAction
{
  [H_commmentTextField resignFirstResponder];
  [H_dup resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)changeFirstResponder
{
  [H_commmentTextField becomeFirstResponder]; //will return YES;
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  return H_cellsViewArray.count;    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  
  [[cell viewWithTag:10] removeFromSuperview];
  UIView *cellView = (UIView *)[H_cellsViewArray objectAtIndex:indexPath.row];
  [cell addSubview:cellView];
  cellView.tag = 10;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIView *cellView = (UIView *)[H_cellsViewArray objectAtIndex:indexPath.row];

  return cellView.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
-(void)feedCellActionWithType:(int)type andID:(NSString *)postID
{
  NSLog(@"actionTypecommentpage--->>>%d", type);
  if (type == 2)
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
