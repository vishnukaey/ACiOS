//
//  LCInterestsVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCInterestsVC.h"
#import "LCInterestsCellView.h"

@interface LCInterestsVC ()

@end

@implementation LCInterestsVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  interestsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  isSelfProfile = [self.userID isEqualToString:[LCDataManager sharedDataManager].userID];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)loadInterests
{
  [MBProgressHUD showHUDAddedTo:interestsTable animated:YES];
  [LCAPIManager getInterestsForUser:self.userID withSuccess:^(NSArray *responses) {
    
    interestsArray = responses;
    [interestsTable reloadData];
    [MBProgressHUD hideAllHUDsForView:interestsTable animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:interestsTable animated:YES];
    NSLog(@"%@",error);
  }];
}


#pragma mark - TableView delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 135.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (interestsArray.count == 0) {
    return 1;
  }
  return interestsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (interestsArray.count == 0) {
    
    NSString *message;
    if (isSelfProfile) {
      message = NSLocalizedString(@"no_interests_available_self", nil);
      
    }
    else {
      message = NSLocalizedString(@"no_interests_available_others", nil);
    }
    UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    return cell;
  }
  
  static NSString *MyIdentifier = @"LCInterestsCell";
  LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
    
  }
  
  LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
  [cell setData:interstObj];
  
  tableView.backgroundColor = [UIColor clearColor];
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.allowsSelection = YES;
  
  return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
