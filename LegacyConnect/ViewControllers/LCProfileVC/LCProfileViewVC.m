//
//  LCProfileViewVC.m
//  LegacyConnect
//
//  Created by User on 7/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCProfileViewVC.h"
#import "LCTabMenuView.h"
#import "LCCommunityInterestCell.h"


@implementation LCProfileViewVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  milestonesTable.estimatedRowHeight = 44.0;
  milestonesTable.rowHeight = UITableViewAutomaticDimension;
  
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePic.clipsToBounds = YES;
  
  
  [self addTabMenu];
  
  [self loadMileStones];
  [self loadInterests];
  // Do any additional setup after loading the view.
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

- (void)addTabMenu
{
  UIButton *mileStonesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [mileStonesButton setTitle:@"MileStones" forState:UIControlStateNormal];
  UIButton *interestsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [interestsButton setTitle:@"Interests" forState:UIControlStateNormal];
  
  LCTabMenuView *tabmenu = [[LCTabMenuView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [tabMenuContainer addSubview:tabmenu];
  [tabmenu setBackgroundColor:[UIColor whiteColor]];
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
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:mileStonesButton, interestsButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:milestonesTable,  interestsCollectionView, nil];
  tabmenu.highlightColor = [UIColor orangeColor];
  tabmenu.normalColor = [UIColor blackColor];
}

- (void)loadInterests
{
  [LCAPIManager getInterestsWithSuccess:^(NSArray *response)
   {
     NSLog(@"%@",response);
     interestsArray = response;
     [interestsCollectionView reloadData];
   }
                             andFailure:^(NSString *error)
   {
     NSLog(@"%@",error);
   }
   ];
}
   
-(void)loadMileStones
{
  MileStones = [[NSMutableArray alloc]initWithArray:[LCDummyValues dummyPROFILEFeedArray]];
  [milestonesTable reloadData];
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

- (IBAction)editClicked:(UIButton *)sender
{
  NSLog(@"edit clicked-->>");
}

#pragma mark - scrollview delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  float collapseConstant = 0;;
  if (self.collapseViewHeight.constant>0)
  {
    collapseConstant = self.collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (self.collapseViewHeight.constant<170 && scrollView.contentOffset.y<0)
  {
    collapseConstant = self.collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseConstant<0)
  {
    collapseConstant = 0;
  }
  if (collapseConstant>170)
  {
    collapseConstant = 170;
  }
  self.collapseViewHeight.constant = collapseConstant;
}

#pragma mark - collection view delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return interestsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"LCInterestCell";
  LCCommunityInterestCell *cell = (LCCommunityInterestCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  if (cell == nil)
  {
    NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCCommunityInterestCell class]) owner:nil options:nil];
    cell=cells[0];
  }
  LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
  cell.interestNameLabel.text = interstObj.name;
  [cell.interestIcon sd_setImageWithURL:[NSURL URLWithString:interstObj.logoURL] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"interest clicked--->>>");
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return MileStones.count;
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
  [cell setData:[MileStones objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  
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
