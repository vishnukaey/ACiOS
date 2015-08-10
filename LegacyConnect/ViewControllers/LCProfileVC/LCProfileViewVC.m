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
  H_milestonesTable.estimatedRowHeight = 44.0;
  H_milestonesTable.rowHeight = UITableViewAutomaticDimension;
  [self loadMileStones];
  [self loadInterests];
  // Do any additional setup after loading the view.
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
- (void)loadInterests
{
  UIButton *anInterest = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
  [anInterest setTitle:@"An interest" forState:UIControlStateNormal];
  [H_interestsScrollview addSubview:anInterest];
  anInterest.backgroundColor = [UIColor orangeColor];
  anInterest.center = CGPointMake(H_interestsScrollview.frame.size.width/2, H_interestsScrollview.frame.size.height/2);
  [anInterest addTarget:self action:@selector(interestClicked:) forControlEvents:UIControlEventTouchUpInside];
}
   
-(void)loadMileStones
{
  H_MileStones = [[NSMutableArray alloc]initWithArray:[LCDummyValues dummyPROFILEFeedArray]];
  [H_milestonesTable reloadData];
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
  
  return H_MileStones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"LCFeedCell";
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
  }
  cell.delegate = self;
  [cell setData:[H_MileStones objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  
  return cell;
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
