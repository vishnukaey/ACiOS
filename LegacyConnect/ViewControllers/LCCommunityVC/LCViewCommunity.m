//
//  LCViewCommunity.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCViewCommunity.h"


@implementation LCViewCommunity

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationController.navigationBarHidden = true;
  
  [self prepareCells];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.menuButton setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

#pragma mark - setup functions
-(void)prepareCells
{
  NSArray *commentsArray = [LCDummyValues dummyCommentArray];
  
  H_cellsViewArray = [[NSMutableArray alloc]init];
  
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
    
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, H_commentsTable.frame.size.width, 0)];
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
  [H_commentsTable reloadData];
}

#pragma mark - button actions
- (IBAction)backAction:(id)sender
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)settingsAction:(id)sender
{
  NSLog(@"settings clicked-->>");
}

- (IBAction)membersAction:(id)sender
{
  NSLog(@"members clicked-->>");
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return H_cellsViewArray.count;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
