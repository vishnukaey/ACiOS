//
//  LCAllInterestVC.m
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCAllInterestVC.h"
#import "LCSingleInterestVC.h"


@implementation LCAllInterestVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self addMyInterests];
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

#pragma mark - setUpFunctions
- (void)addMyInterests
{
  for (UIView *v in [H_interestsScroll subviews]) {
    [v removeFromSuperview];
  }
  UIButton *anInterest = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  [anInterest setTitle:@"water" forState:UIControlStateNormal];
  [H_interestsScroll addSubview:anInterest];
  anInterest.backgroundColor = [UIColor orangeColor];
  anInterest.center = CGPointMake(self.view.frame.size.width/4, self.view.frame.size.height/4);
  [anInterest addTarget:self action:@selector(interestSelected:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addAllInterests
{
  for (UIView *v in [H_interestsScroll subviews]) {
    [v removeFromSuperview];
  }
  UIButton *anInterest = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  [anInterest setTitle:@"forest" forState:UIControlStateNormal];
  [H_interestsScroll addSubview:anInterest];
  anInterest.backgroundColor = [UIColor orangeColor];
  anInterest.center = CGPointMake(self.view.frame.size.width/4, self.view.frame.size.height/4);
  [anInterest addTarget:self action:@selector(interestSelected:) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *anInterest1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  [anInterest1 setTitle:@"water" forState:UIControlStateNormal];
  [H_interestsScroll addSubview:anInterest1];
  anInterest1.backgroundColor = [UIColor orangeColor];
  anInterest1.center = CGPointMake(self.view.frame.size.width/4*3, self.view.frame.size.height/4);
  [anInterest1 addTarget:self action:@selector(interestSelected:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - button Actions
- (IBAction)toggleMineORAll:(UIButton *)sender
{
  if (sender.tag == 1)//mine
  {
    [self addMyInterests];
  }
  else//all--tag-2
  {
    [self addAllInterests];
  }
}

-(void)interestSelected :(UIButton *)sender
{
  NSLog(@"Interest Selected-->>");
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
  LCSingleInterestVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
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
