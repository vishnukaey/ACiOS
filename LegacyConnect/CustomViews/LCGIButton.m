//
//  GIButton.m
//  AutoLayout
//
//  Created by User on 7/13/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "LCGIButton.h"


@implementation LCGIButton
@synthesize P_community, P_status, P_video;

-  (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor = [UIColor redColor];
    self.layer.cornerRadius = frame.size.width/2;
    [self addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

-(void)setHidden:(BOOL)hidden
{
  [super setHidden:hidden];
  [P_community setHidden:hidden];
  [P_status setHidden:hidden];
  [P_video setHidden:hidden];
}

-(void)setUpMenu
{
  P_community = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  P_community.center = self.center;
  [[self superview] addSubview:P_community];
  //    P_community.alpha = 0;
  P_community.backgroundColor = [UIColor yellowColor];
  P_community.layer.cornerRadius = P_community.frame.size.width/2;

  P_status = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  P_status.center = self.center;
  [[self superview] addSubview:P_status];
  //    P_status.alpha = 0;
  P_status.backgroundColor = [UIColor greenColor];
  P_status.layer.cornerRadius = P_status.frame.size.width/2;

  P_video = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  P_video.center = self.center;
  [[self superview] addSubview:P_video];
  //    P_video.alpha = 0;
  P_video.backgroundColor = [UIColor blueColor];
  P_video.layer.cornerRadius = P_video.frame.size.width/2;

  [[self superview] bringSubviewToFront:self];
}

-(void)showMenu
{
  CGPoint comm_p, video_p, status_p;
  float sep_ = 30;

  comm_p = CGPointMake(self.center.x - self.frame.size.width/2 - P_community.frame.size.width/2 - sep_, self.center.y);
  video_p = CGPointMake(self.center.x, self.center.y - self.frame.size.width/2 - P_community.frame.size.width/2 - sep_);
  sep_ = sep_ - 15;//adjust 10 to show the middle button on the round
  status_p = CGPointMake(self.center.x - self.frame.size.width/2 - P_community.frame.size.width/2 - sep_, self.center.y - self.frame.size.width/2 - P_community.frame.size.width/2 - sep_);

  [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:25.0
  options: UIViewAnimationOptionCurveEaseInOut animations:^
        {
        //P_community.alpha = 1.0;
        P_community.center = comm_p;
        //P_video.alpha = 1.0;
        P_video.center = video_p;
        //P_status.alpha = 1.0;
        P_status.center = status_p;
        }
  completion:^(BOOL finished) {
  //Completion Block
  }];
}

-(void)hideMenu
{
  [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.5 initialSpringVelocity:5.0
  options: UIViewAnimationOptionCurveEaseInOut animations:^
        {
        //P_community.alpha = 0.0;
        P_community.center = self.center;
        //P_video.alpha = 0.0;
        P_video.center = self.center;
        //P_status.alpha = 0.0;
        P_status.center = self.center;
        }
  completion:^(BOOL finished) {
  //Completion Block
  }];
}

-(void)toggle
{
  if (self.tag ==0)
  {
    self.tag = 1;
    [self showMenu];
  }
  else
  {
    self.tag = 0 ;
    [self hideMenu];
  }
}

@end
