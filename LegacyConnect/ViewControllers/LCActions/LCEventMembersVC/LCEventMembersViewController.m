//
//  LCEventMembersViewController.m
//  LegacyConnect
//
//  Created by Kaey on 09/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCEventMembersViewController.h"
#import "LCUserTableViewCell.h"
#import "LCProfileViewVC.h"
#import "LCInviteToActions.h"

@interface LCEventMembersViewController ()
{
  NSArray *membersList;
}
@end

@implementation LCEventMembersViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [LCAPIManager getMembersForEventID:_event.eventID andLastEventID:kEmptyStringValue withSuccess:^(NSArray *responses)
   {
     membersList = responses;
     [self.tableView reloadData];
   } andFailure:^(NSString *error)
   {
   }];
  _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return membersList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCUserTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCUserDetail *user = membersList[indexPath.row];
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = membersList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - IBActions

-(IBAction)inviteFriends:(id)sender
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
  LCInviteToActions *vc = [sb instantiateViewControllerWithIdentifier:@"LCInviteToActions"];
  vc.eventToInvite = self.event;
  [self.navigationController pushViewController:vc animated:YES];
}


-(IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
@end
