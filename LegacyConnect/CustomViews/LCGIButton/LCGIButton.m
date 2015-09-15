//
//  GIButton.m
//  AutoLayout
//
//  Created by User on 7/13/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "LCGIButton.h"


@implementation LCGIButton
@synthesize communityButton, postStatusButton, postPhotoButton;

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
  [communityButton setHidden:hidden];
  [postStatusButton setHidden:hidden];
  [postPhotoButton setHidden:hidden];
}

-(void)setUpMenu
{
  communityButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  communityButton.center = self.center;
  [[self superview] addSubview:communityButton];
  //    P_community.alpha = 0;
  communityButton.backgroundColor = [UIColor yellowColor];
  communityButton.layer.cornerRadius = communityButton.frame.size.width/2;

  postStatusButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  postStatusButton.center = self.center;
  [[self superview] addSubview:postStatusButton];
  //    P_status.alpha = 0;
  postStatusButton.backgroundColor = [UIColor greenColor];
  postStatusButton.layer.cornerRadius = postStatusButton.frame.size.width/2;

  postPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  postPhotoButton.center = self.center;
  [[self superview] addSubview:postPhotoButton];
  //    P_video.alpha = 0;
  postPhotoButton.backgroundColor = [UIColor blueColor];
  postPhotoButton.layer.cornerRadius = postPhotoButton.frame.size.width/2;

  [[self superview] bringSubviewToFront:self];
}

-(void)showMenu
{
  CGPoint comm_p, video_p, status_p;
  float sep_ = 30;

  comm_p = CGPointMake(self.center.x - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_, self.center.y);
  video_p = CGPointMake(self.center.x, self.center.y - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_);
  sep_ = sep_ - 15;//adjust 10 to show the middle button on the round
  status_p = CGPointMake(self.center.x - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_, self.center.y - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_);

  [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:25.0
  options: UIViewAnimationOptionCurveEaseInOut animations:^
        {
        //P_community.alpha = 1.0;
        communityButton.center = comm_p;
        //P_video.alpha = 1.0;
        postPhotoButton.center = video_p;
        //P_status.alpha = 1.0;
        postStatusButton.center = status_p;
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
        communityButton.center = self.center;
        //P_video.alpha = 0.0;
        postPhotoButton.center = self.center;
        //P_status.alpha = 0.0;
        postStatusButton.center = self.center;
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
