//
//  LCInviteToCommunity.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInviteToCommunity.h"
#import "LCViewCommunity.h"


@implementation LCInviteToCommunity

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonAction)];
  self.navigationItem.rightBarButtonItem = anotherButton;
  
  float topSpace = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
  //searchbar
  UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  searchField.layer.borderWidth = 1;
  searchField.placeholder = @"Search among your friends";
  [self.view addSubview:searchField];
  topSpace += searchField.frame.size.height;
  
  //friends list table
  H_friendsArray = [LCDummyValues dummyFriendsArray];
  UITableView *friendsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, self.view.frame.size.height -topSpace)];
  friendsTable.delegate = self;
  friendsTable.dataSource = self;
  [self.view addSubview:friendsTable];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
-(void)doneButtonAction
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCViewCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCViewCommunity"];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return H_friendsArray.count;    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
  }
  
  cell.textLabel.text = [H_friendsArray objectAtIndex:indexPath.row];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40;
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
