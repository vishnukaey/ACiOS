//
//  LCFeedTableViewController.m
//  LegacyConnect
//
//  Created by Jijo on 11/3/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCFeedTableViewController.h"
#import "LCProfileViewVC.h"

@interface LCFeedTableViewController ()

@end

@implementation LCFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kfeedUpdatedotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)feedUpdatedNotificationReceived :(NSNotification *)notification
{
  LCFeed *newfeed = [notification.userInfo objectForKey:@"post"];
  for (int i = 0; i<self.results.count ; i++) {
    if ([self.results[i] isKindOfClass:[LCFeed class]]) {
      LCFeed *feed = self.results[i];
      if ([feed.entityID isEqualToString:newfeed.entityID])
      {
        if ([[notification.userInfo objectForKey:@"event"] isEqualToString:kfeedDeletedEventKey]) {
          [self.results removeObjectAtIndex:i];
        }
        else if ([[notification.userInfo objectForKey:@"event"] isEqualToString:kfeedUpdateEventKey])
        {
          [self.results replaceObjectAtIndex:i withObject:newfeed];
        }
        else
        {
          continue;
        }
        break;
      }
    }
   }
  //new milestone added
  if ([self isKindOfClass:[LCProfileViewVC class]])
  {
    for (int i = 0; i<self.results.count; i++)
    {
      LCFeed *feed = self.results[i];
      if (![feed.isMilestone boolValue]) {
        [self.results removeObjectAtIndex:i];
      }
    }
  }
  
  
  CGPoint offset = self.tableView.contentOffset;
  [self.tableView reloadData];
  [self.tableView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
  [self.tableView setContentOffset:offset];
}

- (void)clearNaviGationStack
{
  NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
  NSLog(@"navigationArray-->>>%@", navigationArray);
  for (int i =0; i<navigationArray.count-1; i++)
  {
      UIViewController *controller_ = (UIViewController *)[navigationArray objectAtIndex:i];
      if ([controller_ isKindOfClass:[LCProfileViewVC class]])
      {
        [navigationArray removeObjectsInRange:NSMakeRange(i, navigationArray.count-1-i)];
      }
  }
  NSLog(@"navigationArray-->>>%@", navigationArray);
  self.navigationController.viewControllers = navigationArray;
}


- (void) viewWillAppear:(BOOL)animated
{
  
  [super viewWillAppear:animated];
  if ([self isKindOfClass:[LCProfileViewVC class]])
  {
     [self clearNaviGationStack];
  }
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
