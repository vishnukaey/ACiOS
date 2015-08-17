//
//  LCSingleCauseVC.m
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSingleCauseVC.h"


@implementation LCSingleCauseVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self prepareCells];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = false;
}

#pragma mark - setup functions
-(void)prepareCells
{
  NSArray *feedsArray = [LCDummyValues dummyFeedArray];
  
  cellsViewArray = [[NSMutableArray alloc]init];
  for (int i=0; i<feedsArray.count; i++)
  {
    LCFeedCellView *celViewFinal = [[LCFeedCellView alloc]init];
//    [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:feedsTable.frame.size.width forPage:kHomefeedCellID];
    celViewFinal.delegate = self;
    [cellsViewArray addObject:celViewFinal];
  }
}

#pragma mark - button actions
- (IBAction)supportClicked:(id)sender
{
  NSLog(@"support clicked");
}

- (IBAction)supportersListClicked:(id)sender
{
    NSLog(@"supportersList clicked");
}

- (IBAction)websiteLinkClicked:(id)sender
{
  NSLog(@"support clicked");
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return cellsViewArray.count;
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
  
  UIView *cellView = (UIView *)[cellsViewArray objectAtIndex:indexPath.row];
  [cell addSubview:cellView];
  cellView.tag = 10;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIView *cellView = (UIView *)[cellsViewArray objectAtIndex:indexPath.row];
  
  return cellView.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(NSString *)type andFeed:(LCFeed *)feed
{
  NSLog(@"actionType--->>>%@", type);
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
