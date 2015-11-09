//
//  LCChooseActionsInterest.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseActionsInterest.h"
#import "LCCreateActions.h"
#import "LCCommunityInterestCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCInterestsCellView.h"


static NSString *kUnCheckedImageName = @"tagFirend_unselected";
static NSString *kCheckedImageName = @"contact_tick";


@implementation LCChooseActionsInterest
{
  LCInterest *selectedInterest;
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [LCAPIManager getInterestsForUser:[LCDataManager sharedDataManager].userID withSuccess:^(NSArray *responses)
  {
      interestsArray = responses;
      [interestsTableView reloadData];
    }
    andFailure:^(NSString *error)
    {
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

#pragma mark - button actions
- (IBAction)cancelAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextAction
{
  /* 
   
   Push to create community page
   
   */

}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return interestsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"LCInterestsCell";
    LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
      cell = [topLevelObjects objectAtIndex:0];
    }
    
    LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
    [cell setData:interstObj];
    tableView.backgroundColor = [tableView.superview backgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.allowsSelection = YES;
    
    cell.checkButton.hidden = NO;
    cell.checkButton.userInteractionEnabled = NO;
    if ([interstObj.interestID isEqualToString:selectedInterest.interestID])
    {
      [cell.checkButton setImage:[UIImage imageNamed:kCheckedImageName] forState:UIControlStateNormal];
    }
    else
    {
      [cell.checkButton setImage:[UIImage imageNamed:kUnCheckedImageName] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedInterest = [interestsArray objectAtIndex:indexPath.row];
  [interestsTableView reloadData];
}


@end
