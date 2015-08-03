//
//  leftMenuController.m
//  LegacyConnect
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCLeftMenuController.h"


@implementation LCLeftMenuController

@synthesize P_menuwidth, delegate_;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setFrame:[[UIScreen mainScreen] bounds]];
  [self.view setBackgroundColor:[UIColor lightTextColor]];
  
  
  NSArray *titles_ = [[NSArray alloc] initWithObjects:@"Home", @"Profile", @"Interests", @"Notifications", @"Logout", nil];

  float y_margin = 2;
  float but_height = 50;
  _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 70, 70)];
  [self.view addSubview:_userImageView];
  [_userImageView sd_setImageWithURL:[NSURL URLWithString:[LCDataManager sharedDataManager].avatarUrl]placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  for (int i = 0; i<titles_.count; i++) {
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 150+y_margin*(i+1) + i * but_height, P_menuwidth, but_height)];
    but.backgroundColor = [UIColor whiteColor];
    [but setTitle:[titles_ objectAtIndex:i] forState:UIControlStateNormal];
    [self.view addSubview:but];
    but.tag = i;
    [but addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  }
}

-(void)buttonActions :(UIButton *)sender
{
  [delegate_ leftMenuButtonActions:sender];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
