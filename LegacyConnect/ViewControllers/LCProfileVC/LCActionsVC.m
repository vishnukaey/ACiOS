//
//  LCActionsVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCActionsVC.h"
#import "LCActionsCellView.h"

@interface LCActionsVC ()

@end

@implementation LCActionsVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  actionsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  isSelfProfile = [self.userID isEqualToString:[LCDataManager sharedDataManager].userID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadActions {
  
  [MBProgressHUD showHUDAddedTo:actionsTable animated:YES];
  [LCAPIManager getUserEventsForUserId:self.userID andLastEventId:nil withSuccess:^(NSArray *response) {
    
    actionsArray = response;
    [actionsTable reloadData];
    [MBProgressHUD hideAllHUDsForView:actionsTable animated:YES];
  } andFailure:^(NSString *error) {
    
    [MBProgressHUD hideAllHUDsForView:actionsTable animated:YES];
  }];
}



#pragma mark - TableView delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 106.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (actionsArray.count == 0) {
      return 1;
    }
    return actionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ACTIONS
    if (actionsArray.count == 0) {
  
      NSString *message;
      if (isSelfProfile) {
        message = NSLocalizedString(@"no_actions_available_self", nil);
        
      }
      else {
        message = NSLocalizedString(@"no_actions_available_others", nil);
      }
      UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
      
      tableView.backgroundColor = [UIColor whiteColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      tableView.allowsSelection = NO;
      return cell;
    }
  
      static NSString *MyIdentifier = @"LCActionsCell";
      LCActionsCellView *cell = (LCActionsCellView*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
      if (cell == nil)
      {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCActionsCellView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
      }
      [cell setEvent:[actionsArray objectAtIndex:indexPath.row]];
      
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
