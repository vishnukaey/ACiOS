//
//  LCSearchTopViewController.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchTopViewController.h"
#import "LCUserTableViewCell.h"
#import "LCInterestsTableViewCell.h"
#import "LCCausesTableViewCell.h"
#import "LCUserDetail.h"
#import "LCInterest.h"
#import "LCCause.h"
#import "LCProfileViewVC.h"

@interface LCSearchTopViewController ()

@end

@implementation LCSearchTopViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.topTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
  if([tableView isEqual:self.topTableView])
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
  UIView *prev = [tableView viewWithTag:122];
  if (prev) {
    [prev removeFromSuperview];
  }
  if (!self.searchResultObject.usersArray.count && !self.searchResultObject.interestsArray.count && !self.searchResultObject.causesArray.count) {
    UIView *noResultView = [self getNOResultLabel];
    noResultView.tag = 122;
    noResultView.center = CGPointMake(tableView.frame.size.width/2, noResultView.center.y);
    [tableView addSubview:noResultView];
  }
  
  if(section == 0)
  {
    return self.searchResultObject.usersArray.count>3 ? 3 : self.searchResultObject.usersArray.count;
  }
  else if(section == 1)
  {
    return self.searchResultObject.interestsArray.count>3 ? 3 : self.searchResultObject.interestsArray.count;
  }
  else
  {
    return self.searchResultObject.causesArray.count>3 ? 3 : self.searchResultObject.causesArray.count;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if(indexPath.section == 0)
  {
    return 44.0;
  }
  
  return 80.0;
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if(indexPath.section == 0)
  {
    LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCUserDetail *user = self.searchResultObject.usersArray[indexPath.row];
    cell.user = user;
    return cell;
  }
  else if(indexPath.section == 1)
  {
    LCInterestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCInterestsTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCInterest *interest = self.searchResultObject.interestsArray[indexPath.row];
    cell.interest = interest;
    return cell;
  }
  else
  {
    LCCausesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCCausesTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCCause *cause = self.searchResultObject.causesArray[indexPath.row];
    cell.cause= cause;
    return cell;
  }
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  switch (indexPath.section) {
    case 0:
    {
      UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
      LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
      vc.userDetail = self.searchResultObject.usersArray[indexPath.row];
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

@end
