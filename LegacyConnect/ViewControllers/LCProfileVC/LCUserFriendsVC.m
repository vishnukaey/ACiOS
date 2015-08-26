//
//  LCUserFriendsVC.m
//  LegacyConnect
//
//  Created by Jijo on 8/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUserFriendsVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

#pragma mark - LCFriendCell class
@interface LCFriendCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *friendNameLabel;
@property(nonatomic, strong)IBOutlet UILabel *friendLocationLabel;
@property(nonatomic, strong)IBOutlet UIImageView *friendPhotoView;
@end

@implementation LCFriendCell
@end

#pragma mark - LCUserFriendsVC class
@implementation LCUserFriendsVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  friendsTableView.estimatedRowHeight = 44.0;
  friendsTableView.rowHeight = UITableViewAutomaticDimension;
  
  [self loadFriendsList];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - setup functions
- (void)loadFriendsList
{
  [LCAPIManager getFriendsWithSuccess:^(id response) {
    NSLog(@"%@",response);
    friendsArray = response;
    [friendsTableView reloadData];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
}

#pragma mark - button actions
- (IBAction)backButtonAction
{
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"LCFriendCell";
  LCFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCFriendCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
  }
  LCFriend *friend = friendsArray[indexPath.row];
  cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
  cell.friendLocationLabel.text = @"Location";
  cell.friendPhotoView.layer.cornerRadius = cell.friendPhotoView.frame.size.width/2;
  [cell.friendPhotoView  sd_setImageWithURL:[NSURL URLWithString:friend.avatarURL] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
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
