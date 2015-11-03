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

@interface LCSearchViewController ()
{
  LCSearchResult *searchResultObject;
  NSArray *tableData;
}
@end

@implementation LCSearchViewController



- (void)startFetchingResults
{
  [super startFetchingResults];
  
//  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
//  [LCAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:nil withSuccess:^(id response) {
//    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
//    [self stopRefreshingViews];
//    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
//    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
//    [self didFetchResults:response haveMoreData:hasMoreData];
//    [self setNoResultViewHidden:[(NSArray*)response count] != 0];
//  } andfailure:^(NSString *error) {
//    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
//    [self stopRefreshingViews];
//    [self didFailedToFetchResults];
//    [self setNoResultViewHidden:[self.results count] != 0];
//  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCAPIManager searchUserUsingsearchKey:_searchBar.text lastUserId:[(LCUserDetail*)[self.results lastObject] userID] withSuccess:^(id response) {
    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFailedToFetchResults];
  }];
  
//  [LCAPIManager getFriendsForUser:self.userId searchKey:nil lastUserId:[(LCFriend*)[self.results lastObject] friendId] withSuccess:^(id response) {
//    [self stopRefreshingViews];
//    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
//    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
//    [self didFetchNextResults:response haveMoreData:hasMoreData];
//  } andfailure:^(NSString *error) {
//    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
//    [self stopRefreshingViews];
//    [self didFailedToFetchResults];
//  }];
  
  
}






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
  self.tabMenu.views = @[_topTableView, self.tableView, _interestsCollectionView, _causesCollectionView];
  self.tabMenu.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
  self.tabMenu.highlightColor = [UIColor colorWithRed:240.0/255.0 green:100/255.0 blue:77/255.0 alpha:1.0];
  self.tabMenu.normalColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
  
  self.topTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  // For fixing unnecessary border above search bar
  [_searchBar setBackgroundImage:[UIImage new]];
  
  _searchBar.layer.cornerRadius = 6.0;
  _searchBar.clipsToBounds = YES;
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


- (UIView *)getNOResultLabel
{
  UILabel * noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:@"No Results Found"];
  return noResultLabel;
}


#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if([tableView isEqual:_topTableView])
  {
    return 3;
  }
  else
  {
    return 1;
  }//count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if([tableView isEqual:_topTableView])
  {
    UIView *prev = [tableView viewWithTag:122];
    if (prev) {
      [prev removeFromSuperview];
    }
    if (!self.results.count && !searchResultObject.interestsArray.count && !searchResultObject.causesArray.count) {
      UIView *noResultView = [self getNOResultLabel];
      noResultView.tag = 122;
      noResultView.center = CGPointMake(tableView.frame.size.width/2, noResultView.center.y);
      [tableView addSubview:noResultView];
    }
    
    if(section == 0)
    {
      return self.results.count>3 ? 3 : self.results.count;
    }
    else if(section == 1)
    {
      return searchResultObject.interestsArray.count>3 ? 3 : searchResultObject.interestsArray.count;
    }
    else
    {
      return searchResultObject.causesArray.count>3 ? 3 : searchResultObject.causesArray.count;
    }
  }
  else
  {
    UIView *prev = [tableView viewWithTag:122];
    if (prev)
    {
      [prev removeFromSuperview];
    }
    if (!self.results.count) {
      UIView *noResultView = [self getNOResultLabel];
      noResultView.tag = 122;
      noResultView.center = CGPointMake(tableView.frame.size.width/2, noResultView.center.y);
      [tableView addSubview:noResultView];
    }
    return [super tableView:tableView numberOfRowsInSection:section];
  }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  header.contentView.backgroundColor = [UIColor whiteColor];
  header.textLabel.font = [UIFont boldSystemFontOfSize:14];
  header.textLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
  CGRect headerFrame = header.frame;
  header.textLabel.frame = headerFrame;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if([tableView isEqual:_topTableView])
  {
    NSString *sectionName;
    switch (section)
    
    
    {
      case 0:
        sectionName = @"Users";
        break;
      case 1:
        sectionName = @"Interests";
        break;
        // ...
      default:
        sectionName = @"Causes";
        break;
    }
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] > 0)
    {
      return sectionName;
    }
    else
    {
      return nil;
    }
    return sectionName;
  }
  return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([tableView isEqual:_topTableView])
  {
    if(indexPath.section == 0)
    {
      return 44.0;
    }
    else
    {
      return 80.0;
    }
  }
  return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([tableView isEqual:_topTableView])
  {
    if(indexPath.section == 0)
    {
      LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTableViewCell"];
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
      LCUserDetail *user = self.results[indexPath.row];
      cell.user = user;
      return cell;
    }
    else if(indexPath.section == 1)
    {
      LCInterestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCInterestsTableViewCell"];
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
      LCInterest *interest = searchResultObject.interestsArray[indexPath.row];
      cell.interest = interest;
      return cell;
    }
    else
    {
      LCCausesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCCausesTableViewCell"];
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
      LCCause *cause = searchResultObject.causesArray[indexPath.row];
      cell.cause= cause;
      return cell;
    }
  }
  else
  {
    JTTABLEVIEW_cellForRowAtIndexPath
    LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCUserDetail *user = self.results[indexPath.row];
    cell.user = user;
    return cell;
  }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([tableView isEqual:_topTableView])
  {
    switch (indexPath.section) {
      case 0:
      {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
        vc.userDetail = self.results[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
      }
        break;
        
        // Uncomment for Interests and causes
        
        /*
      case 1:
      {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
        LCSingleInterestVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
        [self.navigationController pushViewController:vc animated:YES];
      }
        break;
        
      case 2:
      {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
        LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
        [self.navigationController pushViewController:vc animated:YES];
      }
        break;
        */
        
      default:
        break;
    }
    
  }
  else
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = @"6994";
    [self.navigationController pushViewController:vc animated:YES];
  }
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  if([collectionView isEqual:_causesCollectionView])
  {
    UIView *prev = [collectionView viewWithTag:122];
    if (prev) {
      [prev removeFromSuperview];
    }
    if (!searchResultObject.causesArray.count) {
      UIView *noResultView = [self getNOResultLabel];
      noResultView.tag = 122;
      noResultView.center = CGPointMake(collectionView.frame.size.width/2, noResultView.center.y);
      [collectionView addSubview:noResultView];
    }
    return searchResultObject.causesArray.count;
  }
  else
  {
    UIView *prev = [collectionView viewWithTag:122];
    if (prev) {
      [prev removeFromSuperview];
    }
    if (!searchResultObject.interestsArray.count) {
      UIView *noResultView = [self getNOResultLabel];
      noResultView.tag = 122;
      noResultView.center = CGPointMake(collectionView.frame.size.width/2, noResultView.center.y);
      [collectionView addSubview:noResultView];
    }
    return searchResultObject.interestsArray.count;
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [_searchBar resignFirstResponder];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if([collectionView isEqual:_causesCollectionView])
  {
    static NSString *identifier = @"causesCollectionViewCell";
    LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.cause = searchResultObject.causesArray[indexPath.item];
    
    return cell;
  }
  else
  {
    static NSString *identifier = @"interestsCollectionViewCell";
    LCChooseInterestCVC *cell = (LCChooseInterestCVC*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.interest = searchResultObject.interestsArray[indexPath.item];
    return cell;
  }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  // Uncomment for Selection of interest and cause
  
  
  /*
  if([collectionView isEqual:_causesCollectionView])
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    [self.navigationController pushViewController:vc animated:YES];  }
  else
  {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
        LCSingleInterestVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
        [self.navigationController pushViewController:vc animated:YES];
  }
   */

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
 searchText = [searchText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
  if(searchBar.text.length == 0)
  {
    searchResultObject = nil;
    [self.results removeAllObjects];
    [self reloadAllViews];
  }
  else
  {
    [LCAPIManager searchForItem:searchText withSuccess:^(LCSearchResult *searchResult) {
      searchResultObject = searchResult;
      [self.results removeAllObjects];
      [super startFetchingResults];
      BOOL hasMoreData = ([(NSArray*)searchResult.usersArray count] < 10) ? NO : YES;
      [self didFetchResults:searchResult.usersArray haveMoreData:hasMoreData];
      [self reloadAllViews];
    } andFailure:^(NSString *error) {
    }];
  }
}



- (IBAction)searchCancelButtonClicked:(UIButton *)cancelButton
{
  [self.navigationController popViewControllerAnimated:NO];
}

-(void)reloadAllViews
{
  [self.topTableView reloadData];
  [self.tableView reloadData];
  [self.interestsCollectionView reloadData];
  [self.causesCollectionView reloadData];
}
@end
