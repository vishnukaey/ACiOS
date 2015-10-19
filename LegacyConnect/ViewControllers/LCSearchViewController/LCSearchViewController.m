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

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.searchBar becomeFirstResponder];
  
  UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [topButton setTitle:@"Top" forState:UIControlStateNormal];
  UIButton *usersButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [usersButton setTitle:@"Users" forState:UIControlStateNormal];
  UIButton *interestsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [interestsButton setTitle:@"Interests" forState:UIControlStateNormal];
  UIButton *causesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [causesButton setTitle:@"Causes" forState:UIControlStateNormal];
  
  self.tabMenu.menuButtons = @[topButton,usersButton ,interestsButton, causesButton];
  self.tabMenu.views = @[_topTableView, _usersTableView, _interestsCollectionView, _causesCollectionView];
  
  self.tabMenu.highlightColor = [UIColor orangeColor];
  self.tabMenu.normalColor = [UIColor blackColor];
  
  
  self.topTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.usersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
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
    if(section == 0)
      return searchResultObject.usersArray.count;
    else if(section == 1)
      return searchResultObject.interestsArray.count;
    else
      return searchResultObject.causesArray.count;
  }
  else
  {
    return searchResultObject.usersArray.count;
  }
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
      LCUserDetail *user = searchResultObject.usersArray[indexPath.row];
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
    LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCUserDetail *user = searchResultObject.usersArray[indexPath.row];
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
        vc.userDetail = [[LCUserDetail alloc] init];
        vc.userDetail.userID = @"6994";
        [self.navigationController pushViewController:vc animated:YES];
      }
        break;
        
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
    return searchResultObject.causesArray.count;
  }
  else
  {
    return searchResultObject.interestsArray.count;
  }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  header.textLabel.font = [UIFont boldSystemFontOfSize:14];
  CGRect headerFrame = header.frame;
  header.textLabel.frame = headerFrame;
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

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if(searchBar.text.length == 0)
  {
    searchResultObject = nil;
    [self reloadAllViews];
  }
  else
  {
    [LCAPIManager searchForItem:searchText withSuccess:^(LCSearchResult *searchResult) {
      searchResultObject = searchResult;
      [self reloadAllViews];
    } andFailure:^(NSString *error) {
      NSLog(@"");
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
  [self.usersTableView reloadData];
  [self.interestsCollectionView reloadData];
  [self.causesCollectionView reloadData];
}
@end
