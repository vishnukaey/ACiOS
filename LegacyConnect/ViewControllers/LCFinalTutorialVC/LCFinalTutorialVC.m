//
//  LCFinalTutorialVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFinalTutorialVC.h"
#import "LCMenuButton.h"

#define TUTORIAL_FONT [UIFont fontWithName:@"Gotham-Medium" size:14]

@implementation LCFinalTutorialVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRed:40.0/255 green:40.0/255 blue:40.0/255 alpha:0.9];
  startButton.layer.cornerRadius = 5;
  // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self addMenuView];
  [self addGIBView];
}

- (void)addMenuView
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  LCMenuButton *menuButt = (LCMenuButton *)appdel.menuButton;
  float bw_menu = 3;//border width
  UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(menuButt.frame.origin.x + menuButt.iconImage.frame.origin.x - bw_menu  ,   menuButt.frame.origin.y + menuButt.iconImage.frame.origin.y - bw_menu  ,  menuButt.iconImage.frame.size.width + bw_menu*2   , menuButt.iconImage.frame.size.height + bw_menu*2)];
  [self.view addSubview:menuView];
  menuView.layer.cornerRadius = menuView.frame.size.width/2;
  [menuView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.15]];
  
  UIImageView * menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, menuButt.iconImage.frame.size.width, menuButt.iconImage.frame.size.height)];
  menuImage.image = [menuButt.iconImage.image copy];
  [menuView addSubview:menuImage];
  menuImage.center = CGPointMake(menuView.frame.size.width/2, menuView.frame.size.height/2);
  
  
  UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, menuView.frame.origin.y, menuView.frame.origin.x - 16 , menuView.frame.size.height)];
  menuLabel.textColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1];
  menuLabel.text = NSLocalizedString(@"menu_tutorial", nil);
  menuLabel.font = TUTORIAL_FONT;
  menuLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:menuLabel];
  menuLabel.numberOfLines = 0;
}

- (void)addGIBView
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  UIView *GIButt = (UIView *)appdel.GIButton;
  float bw_GIB = 3;//border width
  UIView *GIBView = [[UIView alloc] initWithFrame:CGRectMake(GIButt.frame.origin.x - bw_GIB  ,   GIButt.frame.origin.y - bw_GIB  ,  GIButt.frame.size.width + bw_GIB*2   , GIButt.frame.size.height + bw_GIB*2)];
  [self.view addSubview:GIBView];
  GIBView.layer.cornerRadius = GIBView.frame.size.width/2;
  [GIBView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
  
  UIImageView * GIBImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,GIButt.frame.size.width, GIButt.frame.size.height)];
  GIBImage.image = [UIImage imageNamed:@"GI_button_inactive"];
  [GIBView addSubview:GIBImage];
  GIBImage.center = CGPointMake(GIBView.frame.size.width/2, GIBView.frame.size.height/2);
  
  UILabel *GIBLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, GIBView.frame.origin.y, GIBView.frame.origin.x - 16 , GIBView.frame.size.height)];
  GIBLabel.textColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1];
  GIBLabel.text = NSLocalizedString(@"gibutton_tutorial", nil);
  GIBLabel.font = TUTORIAL_FONT;
  GIBLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:GIBLabel];
  GIBLabel.numberOfLines = 0;
}

- (IBAction)getStartedAction
{
  [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
