//
//  LCListInterestsAndCausesVCViewController.m
//  LegacyConnect
//
//  Created by Jijo on 10/19/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCListInterestsAndCausesVC.h"
#import "LCTabMenuView.h"
#import "LCInterestsCellView.h"

@interface LCListInterestsAndCausesVC ()
{
  IBOutlet UIView *tabMenuContainer;
  IBOutlet UICollectionView *causesCollectionView;
  IBOutlet UITableView *interestsTableView;
  
  IBOutlet UIButton *interestsButton, *causesButton;
  
  NSArray *interestsArray;
  NSMutableArray *interestsSearchArray;
  
  LCInterest *selectedInterest;
}
@end

static NSString *kUnCheckedImageName = @"tagFirend_unselected";
static NSString *kCheckedImageName = @"contact_tick";

@implementation LCListInterestsAndCausesVC
#pragma mark - lifecycle methods
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  interestsSearchArray = [[NSMutableArray alloc] init];
  [self addTabMenu];
  [self loadInterests];
  
  UIView *zeroRectView = [[UIView alloc] initWithFrame:CGRectZero];
  interestsTableView.tableFooterView = zeroRectView;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - setup functions
- (void)addTabMenu
{
  
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
  
  
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:interestsButton, causesButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:interestsTableView,  causesCollectionView, nil];
  
  tabmenu.highlightColor = [UIColor colorWithRed:239.0f/255.0 green:100.0f/255.0 blue:77.0f/255.0 alpha:1.0];
  tabmenu.normalColor = [UIColor colorWithRed:40.0f/255.0 green:40.0f/255.0 blue:40.0f/255.0 alpha:1.0];
}

- (void)loadInterests
{
  [MBProgressHUD showHUDAddedTo:interestsTableView animated:YES];
  [LCAPIManager getInterestsForUser:[LCDataManager sharedDataManager].userID withSuccess:^(NSArray *responses) {
    interestsArray = responses;
    [interestsSearchArray addObjectsFromArray:responses];
    [interestsTableView reloadData];
    [MBProgressHUD hideAllHUDsForView:interestsTableView animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:interestsTableView animated:YES];
    NSLog(@"%@",error);
  }];
}

#pragma mark - button actions
-(IBAction)doneButtonAction
{
  NSLog(@"done button clicked-->>>");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - searchfield delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  [interestsSearchArray removeAllObjects];
  if([searchText length] != 0) {
    for (int i = 0; i<interestsArray.count ; i++)
    {
      LCInterest *interest = interestsArray[i];
      NSString * tempStr = interest.name;
      NSComparisonResult result = [tempStr compare:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchBar.text length])];
      if (result == NSOrderedSame)
      {
        [interestsSearchArray addObject:interest];
      }
    }
  }
  else
  {
    [interestsSearchArray addObjectsFromArray:interestsArray];
  }
  [interestsTableView reloadData];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (interestsArray.count==0)
  {
    return 1;
  }
  return interestsSearchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (interestsArray.count == 0)
  {
    NSString * message = @"Search and add interests from the menu.";
    UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    return cell;
  }
  else
  {
    static NSString *MyIdentifier = @"LCInterestsCell";
    LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
      cell = [topLevelObjects objectAtIndex:0];
    }
    
    LCInterest *interstObj = [interestsSearchArray objectAtIndex:indexPath.row];
    [cell setData:interstObj];
    tableView.backgroundColor = [tableView.superview backgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.allowsSelection = YES;
    
    UIView *sel_but = [cell viewWithTag:10];
    [sel_but removeFromSuperview];
    
    UIButton *selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    selectionButton.center = CGPointMake(cell.frame.size.width - 30, cell.frame.size.height/2 - 8);
    [cell addSubview:selectionButton];
    selectionButton.tag = 10;
    selectionButton.userInteractionEnabled = NO;
    if ([interstObj isEqual:selectedInterest])
    {
      [selectionButton setImage:[UIImage imageNamed:kCheckedImageName] forState:UIControlStateNormal];
    }
    else
    {
      [selectionButton setImage:[UIImage imageNamed:kUnCheckedImageName] forState:UIControlStateNormal];
    }
    
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedInterest = [interestsSearchArray objectAtIndex:indexPath.row];
  
  [interestsTableView reloadData];
}

@end
