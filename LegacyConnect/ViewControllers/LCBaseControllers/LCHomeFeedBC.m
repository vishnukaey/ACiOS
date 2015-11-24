//
//  LCFeedTableViewController.m
//  LegacyConnect
//
//  Created by Jijo on 11/3/15.
//  Copyright © 2015 Gist. All rights reserved.
//

/* notifications to be handled
 1: liked a post
 2: unliked post
 3: commented a post
 4: Updated a post
 5: deleted a post
 6: created new post
 7: user profile updated
 8: remove milestone - if milestone icon is shown in homefeed
 */

#import "LCHomeFeedBC.h"
#import "LCProfileViewVC.h"

@interface LCHomeFeedBC ()

@end

@implementation LCHomeFeedBC

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedUpdatedNotificationReceived:) name:kfeedUpdatedotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPostCreatedNotificationReceived:) name:knewPostCreatedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)newPostCreatedNotificationReceived :(NSNotification *)notification
{
  LCFeed *newPost = notification.userInfo[@"post"];
  [self.results insertObject:newPost atIndex:0];
  [self.tableView reloadData];
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
  LCProfileViewVC *lcp = (LCProfileViewVC*)self;
  lcp.navCount = navigationArray.count;
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
