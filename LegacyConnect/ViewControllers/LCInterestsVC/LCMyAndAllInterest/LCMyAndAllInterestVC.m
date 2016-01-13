//
//  LCMyAndAllInterestVC.m
//  LegacyConnect
//
//  Created by qbuser on 12/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCMyAndAllInterestVC.h"

@implementation LCMyAndAllInterestVC

#pragma mark - private method implementation
- (void)addTabMenu
{
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:myInterestBtn, allInterestbtn, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:mineInterestContainer, allInterestContainer, nil];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"LCMyInterests"]) {
    myInterestVC = segue.destinationViewController;
  }
  else if ([segue.identifier isEqualToString:@"LCAllInterests"]) {
    
    allInterestVC = segue.destinationViewController;
  }
}

#pragma mark - view life cycle implementation
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self addTabMenu];
  [myInterestVC loadMyInterests];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
  [super viewWillDisappear:animated];
}

- (IBAction)myInterestBtnTapped:(id)sender {
  if (tabmenu.currentIndex != 0) {
    [myInterestVC loadMyInterests];
  }
}

- (IBAction)allInterestBtnTapped:(id)sender {
  if (tabmenu.currentIndex != 1) {
    [allInterestVC loadAllIntrests];
  }
}

@end
