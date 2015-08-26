//
//  LCTabMenuView.m
//  LegacyConnect
//
//  Created by User on 8/11/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCTabMenuView.h"
#define BAR_LENGTH_MULTIPLIER 13

@interface LCTabMenuView ()
{
  NSInteger currentIndex;
  UIView *bottomBar;
}
@end

@implementation LCTabMenuView
@synthesize menuButtons, views, highlightColor, normalColor;

- (void)setMenuButtons:(NSArray *)menuButtons_
{
  menuButtons = menuButtons_;
  if (highlightColor)
  {
    [[menuButtons objectAtIndex:0] setTitleColor:highlightColor forState:UIControlStateNormal];
  }
  [self addButtons];
  self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
  for (int i = 0; i<menuButtons_.count; i++)
  {
    if (normalColor)
    {
      if (i!=0) {
        [[menuButtons_ objectAtIndex:i] setTitleColor:normalColor forState:UIControlStateNormal];
      }
    }
    UIButton *button = [menuButtons_ objectAtIndex:i];
    if (i==0)
    {
      NSLayoutConstraint *lead =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
      [self addConstraint:lead];
      
      UIButton *button_ = [menuButtons_ objectAtIndex:i+1];
       NSLayoutConstraint *trail =[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button_ attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
      [self addConstraint:trail];
      
      NSLayoutConstraint *width =[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button_ attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
      [self addConstraint:width];
      
      NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
      [self addConstraint:top];
      
      NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
      [self addConstraint:bottom];
      //add the bottom bar under first button
      bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
      bottomBar.backgroundColor = highlightColor;
      bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
      [self addSubview:bottomBar];
      NSLayoutConstraint *botbar_bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
      [self addConstraint:botbar_bottom];
      
      NSLayoutConstraint *botbar_width =[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:button.titleLabel.text.length*BAR_LENGTH_MULTIPLIER];
      [bottomBar addConstraint:botbar_width];
      
      NSLayoutConstraint *botbar_height =[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:3];
      [bottomBar addConstraint:botbar_height];
      
      NSLayoutConstraint *botbar_Xcenter =[NSLayoutConstraint constraintWithItem:bottomBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
      [self addConstraint:botbar_Xcenter];
    }
    else if (i==menuButtons.count-1)
    {
      NSLayoutConstraint *trail =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
      [self addConstraint:trail];
      
      UIButton *button_ = [menuButtons_ objectAtIndex:i-1];
      NSLayoutConstraint *lead =[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:button_ attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
      [self addConstraint:lead];
      
      NSLayoutConstraint *width =[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button_ attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
      [self addConstraint:width];
      
      NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
      [self addConstraint:top];
      
      NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
      [self addConstraint:bottom];
      break;
    }
    else
    {
      UIButton *button_ = [menuButtons_ objectAtIndex:i-1];
      UIButton *_button = [menuButtons_ objectAtIndex:i+1];
      NSLayoutConstraint *_width =[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_button attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
      [self addConstraint:_width];
      
      NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
      [self addConstraint:top];
      
      NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
      [self addConstraint:bottom];
      NSLayoutConstraint *lead =[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:button_ attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
      [self addConstraint:lead];
      
      NSLayoutConstraint *trail =[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_button attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
      [self addConstraint:trail];
    }
  }
}

- (void)setHighlightColor:(UIColor *)highlightColor_
{
  highlightColor = highlightColor_;
  if (menuButtons)
  {
    [[menuButtons objectAtIndex:0] setTitleColor:highlightColor_ forState:UIControlStateNormal];
  }
  bottomBar.backgroundColor = highlightColor_;
}

- (void)setNormalColor:(UIColor *)normalColor_
{
  normalColor = normalColor_;
  if (menuButtons)
  {
    for (int i = 1; i<menuButtons.count; i++) {
      [[menuButtons objectAtIndex:i] setTitleColor:normalColor_ forState:UIControlStateNormal];
    }
  }
}

- (void)setViews:(NSArray *)views_
{
  views = views_;
  if(views_.count)
  {
    UIView *v__ = [views_ objectAtIndex:0];
    [v__ superview].clipsToBounds = YES;
  }
}

- (void)addButtons
{
  for (int i = 0 ; i<menuButtons.count ; i++) {
    UIButton *button = [menuButtons objectAtIndex:i];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    button.tag = i;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
  }
}

- (void)buttonAction :(UIButton *)sender
{
  [self animateToIndex:sender.tag];
}

- (void)animateToIndex :(NSInteger)index
{
  UIView *currentView = [views objectAtIndex:currentIndex];
  UIView *nextView = [views objectAtIndex:index];
  CGPoint currentViewPointTo;
  if (index>currentIndex)
  {
    nextView.center = CGPointMake(nextView.superview.frame.size.width*3/2, nextView.center.y);
    currentViewPointTo = CGPointMake(-nextView.superview.frame.size.width/2, nextView.center.y);
  }
  else if (index<currentIndex)
  {
    nextView.center = CGPointMake(-nextView.superview.frame.size.width/2, nextView.center.y);
    currentViewPointTo = CGPointMake(nextView.superview.frame.size.width*3/2, nextView.center.y);
  }
  else
  {
    return;
  }
  
  [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut animations:^
   {
     currentView.center = currentViewPointTo;
     nextView.center = CGPointMake(nextView.superview.frame.size.width/2, nextView.center.y);
     [[menuButtons objectAtIndex:currentIndex] setTitleColor:normalColor forState:UIControlStateNormal];
     [[menuButtons objectAtIndex:index] setTitleColor:highlightColor forState:UIControlStateNormal];
     UIButton *nextBut = [menuButtons objectAtIndex:index];
     [bottomBar setFrame:CGRectMake(nextBut.center.x - nextBut.titleLabel.text.length*BAR_LENGTH_MULTIPLIER/2, bottomBar.frame.origin.y, nextBut.titleLabel.text.length*BAR_LENGTH_MULTIPLIER, bottomBar.frame.size.height)];
   }
   completion:^(BOOL finished)
   {
      //Completion Block
   }];
  currentIndex = index;
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
