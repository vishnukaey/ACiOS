//
//  LCFullScreenImageVC.m
//  LegacyConnect
//
//  Created by User on 7/31/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFullScreenImageVC.h"

@interface LCFullScreenImageVC ()

@end

@implementation LCFullScreenImageVC
@synthesize P_image;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y)];
  
  [self.view addSubview:imageView];
  imageView.image = P_image;
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
  [imageView setBackgroundColor:[UIColor clearColor]];
  
  UIButton *doneBut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 0, 100, 40)];
  [doneBut setTitle:@"Done" forState:UIControlStateNormal];
  [self.view addSubview:doneBut];
  [doneBut addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (void)doneAction
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [appdel.menuButton setHidden:NO];
  [self dismissViewControllerAnimated:YES completion:nil];
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
