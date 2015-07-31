//
//  LCProfileViewVC.m
//  LegacyConnect
//
//  Created by User on 7/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCProfileViewVC.h"


@implementation LCProfileViewVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self prepareCells];
  [self prepareInterests];
  // Do any additional setup after loading the view.
  self.navigationController.navigationBarHidden = true;
  H_interestsScrollview.hidden = true;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
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


#pragma mark - setup functions
- (void)prepareInterests
{
  UIButton *anInterest = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
  [anInterest setTitle:@"An interest" forState:UIControlStateNormal];
  [H_interestsScrollview addSubview:anInterest];
  anInterest.backgroundColor = [UIColor orangeColor];
  anInterest.center = CGPointMake(H_interestsScrollview.frame.size.width/2, H_interestsScrollview.frame.size.height/2);
  [anInterest addTarget:self action:@selector(interestClicked:) forControlEvents:UIControlEventTouchUpInside];
}
   
-(void)prepareCells
{
  NSArray *feedsArray = [LCDummyValues dummyPROFILEFeedArray];
  
  H_cellsViewArray = [[NSMutableArray alloc]init];
  for (int i=0; i<feedsArray.count; i++)
  {
    LCFeedCellView *celViewFinal = [[LCFeedCellView alloc]init];
    [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:H_milestonesTable.frame.size.width forPage:kHomefeedCellID];
    celViewFinal.delegate = self;
    [H_cellsViewArray addObject:celViewFinal];
  }
}

#pragma mark - button actions
- (IBAction)backAction:(id)sender
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)interestClicked :(UIButton *)sender
{
  NSLog(@"interest clicked----->");
}

- (IBAction)toggleInterestOrMilestones:(UIButton *)sender
{
  if (sender.tag == 1)//milestones
  {
    H_milestonesTable.hidden = false;
    H_interestsScrollview.hidden = true;
  }
  else//interests
  {
    H_milestonesTable.hidden = true;
    H_interestsScrollview.hidden = false;
  }
}

- (IBAction)editClicked:(UIButton *)sender
{
  NSLog(@"edit clicked-->>");
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
- (void)feedCellActionWithType:(NSString *)type andID:(NSString *)postID
{
  NSLog(@"actionType--->>>%@", type);
}


@end
