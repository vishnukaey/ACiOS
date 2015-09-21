//
//  GIButton.m
//  AutoLayout
//
//  Created by User on 7/13/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import "LCGIButton.h"

@interface LCGIButton ()
{
  UIButton *activeLayer;
  BOOL menuOpen;
}
@end

@implementation LCGIButton
@synthesize communityButton, postStatusButton, postPhotoButton;

-  (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    [self addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self setBackgroundImage:[UIImage imageNamed:@"GI_button_active"] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"GI_button_inactive"] forState:UIControlStateNormal];
  
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
  CGSize screenSize = [self superview].frame.size;
  activeLayer = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
  [activeLayer setBackgroundImage:[UIImage imageNamed:@"GI_active_layer"] forState:UIControlStateNormal];
  [self.superview addSubview:activeLayer];
  activeLayer.hidden = true;
  [activeLayer addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
  
  communityButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  communityButton.center = self.center;
  [[self superview] addSubview:communityButton];
  [communityButton setBackgroundImage:[UIImage imageNamed:@"gi_create_event_button"] forState:UIControlStateNormal];

  postStatusButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  postStatusButton.center = self.center;
  [[self superview] addSubview:postStatusButton];
  [postStatusButton setBackgroundImage:[UIImage imageNamed:@"gi_text_post_button"] forState:UIControlStateNormal];

  postPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
  postPhotoButton.center = self.center;
  [[self superview] addSubview:postPhotoButton];
  [postPhotoButton setBackgroundImage:[UIImage imageNamed:@"gi_photo_post_button"] forState:UIControlStateNormal];

  
  
  [[self superview] bringSubviewToFront:self];
}

-(void)showMenu
{
  CGPoint comm_p, photo_p, status_p;
  float sep_ = 30;

  status_p  = CGPointMake(self.center.x - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_, self.center.y);
  comm_p = CGPointMake(self.center.x, self.center.y - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_);
  sep_ = sep_ - 20;//adjust 10 to show the middle button on the round
  photo_p = CGPointMake(self.center.x - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_, self.center.y - self.frame.size.width/2 - communityButton.frame.size.width/2 - sep_);

  [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:25.0
  options: UIViewAnimationOptionCurveEaseInOut animations:^
        {
        [self setSelected:YES];
        activeLayer.hidden = false;
        communityButton.center = comm_p;
        postPhotoButton.center = photo_p;
        postStatusButton.center = status_p;
        menuOpen = true;
        }
  completion:^(BOOL finished) {
  //Completion Block
  }];
}

-(void)hideMenu
{
  [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.5 initialSpringVelocity:5.0
  options: UIViewAnimationOptionCurveEaseInOut animations:^
        {
        [self setSelected:NO];
        activeLayer.hidden = true;
        communityButton.center = self.center;
        postPhotoButton.center = self.center;
        postStatusButton.center = self.center;
        menuOpen = false;
        }
  completion:^(BOOL finished) {
  //Completion Block
  }];
}

-(void)toggle
{
  if (!menuOpen)
  {
    [self showMenu];
  }
  else
  {
    [self hideMenu];
  }
}

@end
