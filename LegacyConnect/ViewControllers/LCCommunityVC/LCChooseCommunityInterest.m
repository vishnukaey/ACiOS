//
//  LCChooseCommunityInterest.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseCommunityInterest.h"
#import "LCCreateCommunity.h"


@implementation LCChooseCommunityInterest

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIButton *anInterest = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
  [anInterest setTitle:@"An interest" forState:UIControlStateNormal];
  [self.view addSubview:anInterest];
  anInterest.backgroundColor = [UIColor orangeColor];
  anInterest.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
  [anInterest addTarget:self action:@selector(interestSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = false;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}


#pragma mark - button actions
- (void)interestSelected :(UIButton *)sender
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCCreateCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCCreateCommunity"];
  [self.navigationController pushViewController:vc animated:YES];
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
