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
//  [self prepareCauses];
//  [self prepareCells];
  [self initialSetup];
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


- (void) initialSetup
{
  [self updateInterestDetails];
  [self addTabMenu];
}

- (void) updateInterestDetails
{
  interestName.text = _interest.name;
  interestDescription.text = _interest.descriptionText;
  [interestImage sd_setImageWithURL:[NSURL URLWithString:_interest.logoURLSmall] placeholderImage:nil];
  [interestBGImage sd_setImageWithURL:[NSURL URLWithString:_interest.logoURLLarge] placeholderImage:nil];
  if (_interest.isFollowing)
  {
    [interestFollowButton setTitle:@"Unfollow" forState:UIControlStateNormal];
  }
  else
  {
    [interestFollowButton setTitle:@"Follow" forState:UIControlStateNormal];
  }
}

- (void)addTabMenu
{
  tabmenu = [[LCTabMenuView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [tabMenuContainer addSubview:tabmenu];
  //[tabmenu setBackgroundColor:[UIColor whiteColor]];
  tabmenu.translatesAutoresizingMaskIntoConstraints = NO;
  tabMenuContainer.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
  
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:top];
  
  NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:bottom];
  
  NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:left];
  
  NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:right];
  
  //  tabmenu.layer.borderWidth = 3;
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:postsButton, causesButton, actionsButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:postsContainer, causesContainer, actionsContainer, nil];
}


- (IBAction)backAction:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}



//#pragma mark - setup functions
//- (void)prepareCauses
//{
//  UIButton *aCause = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
//  [aCause setTitle:@"A Cause" forState:UIControlStateNormal];
//  [causesScrollView addSubview:aCause];
//  aCause.backgroundColor = [UIColor orangeColor];
//  aCause.center = CGPointMake(causesScrollView.frame.size.width/2, causesScrollView.frame.size.height/2);
//  [aCause addTarget:self action:@selector(causesClicked:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//-(void)prepareCells
//{
//  NSArray *feedsArray = [LCDummyValues dummyFeedArray];
//  
//  cellsViewArray = [[NSMutableArray alloc]init];
//  for (int i=0; i<feedsArray.count; i++)
//  {
//    LCFeedCellView *celViewFinal = [[LCFeedCellView alloc]init];
////    [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:feedsTable.frame.size.width forPage:kHomefeedCellID];
//    __weak typeof(self) weakSelf = self;
//    celViewFinal.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
//      [weakSelf feedCellActionWithType:actionType andFeed:feed];
//    };
//    celViewFinal.feedCellTagAction = ^ (NSDictionary * tagDetails) {
//      [weakSelf tagTapped:tagDetails];
//    };
//
//    [cellsViewArray addObject:celViewFinal];
//  }
//}
//
//#pragma mark - button actions
//- (IBAction)followButtonAction:(id)sender
//{
//  NSLog(@"follow button clicked-->>");
//}
//
//- (IBAction)toggleHelpsORCauses:(UIButton *)sender
//{
//  if (sender.tag == 1)//helps
//  {
//    feedsTable.hidden = false;
//    causesScrollView.hidden = true;
//  }
//  else//causes--tag is 2
//  {
//    feedsTable.hidden = true;
//    causesScrollView.hidden = false;
//  }
//}
//
//- (IBAction)backAction:(id)sender
//{
//  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
//  [appdel.GIButton setHidden:NO];
//  [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)causesClicked :(UIButton *)sender
//{
//  NSLog(@"cause clicked0-->>>");
//  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
//  LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
//  [self.navigationController pushViewController:vc animated:YES];
//}
//
//#pragma mark - TableView delegates
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//  return 1;    //count of section
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  
//  return cellsViewArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  static NSString *MyIdentifier = @"MyIdentifier";
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
//  if (cell == nil)
//  {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
//  }
//  [[cell viewWithTag:10] removeFromSuperview];
//  
//  UIView *cellView = (UIView *)[cellsViewArray objectAtIndex:indexPath.row];
//  [cell addSubview:cellView];
//  cellView.tag = 10;
//  
//  return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  UIView *cellView = (UIView *)[cellsViewArray objectAtIndex:indexPath.row];
//  
//  return cellView.frame.size.height;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  NSLog(@"selected row-->>>%d", (int)indexPath.row);
//}
//
//#pragma mark - feedCell delegates
//- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
//{
//  NSLog(@"actionType--->>>%u", type);
//}
//
//- (void)tagTapped:(NSDictionary *)tagDetails
//{
//  NSLog(@"tag details-->>%@", tagDetails);
//}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

@end
