//
//  LCSearchViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 8/26/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSearchViewController.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCUserTableViewCell.h"
#import "LCInterestsTableViewCell.h"
#import "LCCausesTableViewCell.h"
#import "LCSingleCauseVC.h"
#import "LCSingleInterestVC.h"
#import "LCProfileViewVC.h"
#import "LCChooseInterestCVC.h"

#import "LCSearchTopViewController.h"
#import "LCSearchUsersViewController.h"
#import "LCSearchInterestsViewController.h"
#import "LCSearchCausesViewController.h"

@interface LCSearchViewController ()
{
  LCSearchResult *searchResultObject;
  NSArray *tableData;
  NSTimer *searchTimer;
  
  LCSearchTopViewController *searchTopResultsVC;
  LCSearchUsersViewController *searchUsersVC;
  LCSearchInterestsViewController *searchInterestsVC;
  LCSearchCausesViewController *searchCausesVC;
}
@end

@implementation LCSearchViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [topButton setTitle:@"TOP" forState:UIControlStateNormal];
  [topButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:12.0f]];
  
  UIButton *usersButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [usersButton setTitle:@"USERS" forState:UIControlStateNormal];
  [usersButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:12.0f]];

  UIButton *interestsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [interestsButton setTitle:@"INTERESTS" forState:UIControlStateNormal];
  [interestsButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:12.0f]];

  UIButton *causesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [causesButton setTitle:@"CAUSES" forState:UIControlStateNormal];
  [causesButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:12.0f]];

  
  self.tabMenu.menuButtons = @[topButton,usersButton ,interestsButton, causesButton];
  self.tabMenu.views = @[_topContainer, _usersContainer, _interestsContainer, _causesContainer];
  self.tabMenu.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
  self.tabMenu.highlightColor = [UIColor colorWithRed:240.0/255.0 green:100/255.0 blue:77/255.0 alpha:1.0];
  self.tabMenu.normalColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
  
  // For fixing unnecessary border above search bar
  [_searchBar setBackgroundImage:[UIImage new]];
  
  _searchBar.layer.cornerRadius = 6.0;
  _searchBar.clipsToBounds = YES;
  [_searchBar setReturnKeyType:UIReturnKeyDone];
  // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [self reloadAllViews];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if (searchTimer)
  {
    if ([searchTimer isValid]) { [searchTimer invalidate]; }
    searchTimer = nil;
  }
 searchText = [searchText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
  if(searchBar.text.length == 0 || searchText == nil)
  {
    searchResultObject = nil;
    [self reloadAllViews];
  }
  else
  {
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchRequest:) userInfo:searchText repeats:NO];
  }
}


-(void) searchRequest:(NSTimer*)sender
{
  [LCAPIManager searchForItem:sender.userInfo withSuccess:^(LCSearchResult *searchResult) {
    searchResultObject = searchResult;
    [self reloadAllViews];
  } andFailure:^(NSString *error) {
  }];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
}

- (IBAction)searchCancelButtonClicked:(UIButton *)cancelButton
{
  [self.navigationController popViewControllerAnimated:NO];
}

-(void)reloadAllViews
{
  
  searchTopResultsVC.searchResultObject = searchResultObject;
  [searchTopResultsVC.topTableView reloadData];
  
  [searchUsersVC setUsersArray:searchResultObject.usersArray];
  searchUsersVC.searchKey = _searchBar.text;
  [searchUsersVC.tableView reloadData];
  
  searchInterestsVC.interestsArray = searchResultObject.interestsArray;
  [searchInterestsVC.interestsCollectionView reloadData];
  
  searchCausesVC.causesArray = searchResultObject.causesArray;
  [searchCausesVC.causesCollectionView reloadData];
  
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"LCSearchTopSegue"]) {
    
    searchTopResultsVC = segue.destinationViewController;
  }
  else if ([segue.identifier isEqualToString:@"LCSearchUsersSegue"]) {
    
    searchUsersVC = segue.destinationViewController;
  }
  else if ([segue.identifier isEqualToString:@"LCSearchInterestsSegue"]) {
    
    searchInterestsVC = segue.destinationViewController;
  }
  else if ([segue.identifier isEqualToString:@"LCSearchCausesSegue"]) {
    
    searchCausesVC = segue.destinationViewController;
  }
}
@end
