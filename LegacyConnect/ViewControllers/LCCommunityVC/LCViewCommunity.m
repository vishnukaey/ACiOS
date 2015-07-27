//
//  LCViewCommunity.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCViewCommunity.h"


@implementation LCViewCommunity

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.menuButton setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
  {
    // back button was pressed.
    LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdel.GIButton setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
  [super viewWillDisappear:animated];
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
