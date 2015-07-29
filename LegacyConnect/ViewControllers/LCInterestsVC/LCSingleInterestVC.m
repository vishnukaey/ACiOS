//
//  LCSingleInterestVC.m
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSingleInterestVC.h"
#import "LCSingleCauseVC.h"


@implementation LCSingleInterestVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self prepareCauses];
  [self prepareCells];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
}

#pragma mark - setup functions
- (void)prepareCauses
{
  UIButton *aCause = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
  [aCause setTitle:@"A Cause" forState:UIControlStateNormal];
  [H_causesScrollView addSubview:aCause];
  aCause.backgroundColor = [UIColor orangeColor];
  aCause.center = CGPointMake(H_causesScrollView.frame.size.width/2, H_causesScrollView.frame.size.height/2);
  [aCause addTarget:self action:@selector(causesClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)prepareCells
{
  NSArray *feedsArray = [LCDummyValues dummyFeedArray];
  
  H_cellsViewArray = [[NSMutableArray alloc]init];
  for (int i=0; i<feedsArray.count; i++)
  {
    LCFeedCellView *celViewFinal = [[LCFeedCellView alloc]init];
    [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:H_feedsTable.frame.size.width forPage:1];
    celViewFinal.delegate = self;
    [H_cellsViewArray addObject:celViewFinal];
  }
}

#pragma mark - button actions
- (IBAction)followButtonAction:(id)sender
{
  NSLog(@"follow button clicked-->>");
}

- (IBAction)toggleHelpsORCauses:(UIButton *)sender
{
  if (sender.tag == 1)//helps
  {
    H_feedsTable.hidden = false;
    H_causesScrollView.hidden = true;
  }
  else//causes--tag is 2
  {
    H_feedsTable.hidden = true;
    H_causesScrollView.hidden = false;
  }
}

- (IBAction)backAction:(id)sender
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)causesClicked :(UIButton *)sender
{
  NSLog(@"cause clicked0-->>>");
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
  LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
  [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(int)type andID:(NSString *)postID
{
  NSLog(@"actionType--->>>%d", type);
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
