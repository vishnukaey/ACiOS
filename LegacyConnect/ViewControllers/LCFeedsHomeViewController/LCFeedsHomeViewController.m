  //
//  LCFeedsHomeViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsHomeViewController.h"
#import "LCLoginHomeViewController.h"


@implementation LCFeedsHomeViewController


#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [H_feedsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
  self.navigationController.navigationBarHidden = false;
  
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [appdel.menuButton setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self prepareFeedViews];
  [H_feedsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - initial setup functions
- (void)prepareFeedViews
{
  NSArray *feedsArray = [LCDummyValues dummyFeedArray];

  H_feedsViewArray = [[NSMutableArray alloc]init];
  for (int i=0; i<feedsArray.count; i++)
  {
    LCFeedCellView *celViewFinal = [[LCFeedCellView alloc]init];
    [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:H_feedsTable.frame.size.width forPage:kHomefeedCellID];
    celViewFinal.delegate = self;
    [H_feedsViewArray addObject:celViewFinal];
  }
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  return H_feedsViewArray.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  [[cell viewWithTag:10] removeFromSuperview];

  UIView *cellView = (UIView *)[H_feedsViewArray objectAtIndex:indexPath.row];
  [cell addSubview:cellView];
  cellView.tag = 10;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIView *cellView = (UIView *)[H_feedsViewArray objectAtIndex:indexPath.row];
  
  return cellView.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(int)type andID:(NSString *)postID
{
  NSLog(@"actionType--->>>%d", type);
  
  if (type==2)//comments
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];

    [self.navigationController pushViewController:next animated:YES];
  }
  
  if (type==1)
  {
  }
}


@end
