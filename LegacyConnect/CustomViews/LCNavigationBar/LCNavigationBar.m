//
//  LCNavigationBar.m
//  LegacyConnect
//
//  Created by Jijo on 12/3/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCNavigationBar.h"


#define TITLE_FONT [UIFont fontWithName:@"Gotham-Book" size:13]
#define BUTTON_FONT [UIFont fontWithName:@"Gotham-Book" size:13]
#define TITLE_COLOR [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1]
#define BUTTON_ACTIVECOLOR [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1]
#define BUTTON_INACTIVECOLOR [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1]

@implementation LCNavigationBar

- (void)layoutSubviews{
  [super layoutSubviews];
  [self layoutComponents];
}

- (void)layoutComponents
{
  //removing all constraints
  [self.leftButton removeFromSuperview];
  [self.title removeFromSuperview];
  [self.rightButton removeFromSuperview];
  
  
  [self.title removeConstraints:self.title.constraints];
  [self.leftButton removeConstraints:self.leftButton.constraints];
  [self.rightButton removeConstraints:self.rightButton.constraints];
  
  
  [self addSubview:self.title];
  [self addSubview:self.leftButton];
  [self addSubview:self.rightButton];
  

  //adding all constraints back
  [self setLeftButtonProperties];
  [self setRightButtonProperties];
  [self setTitleProperties];
}

- (void)setLeftButtonProperties
{
  if (self.leftButton) {
    float width , height;
    height = 44;
    width = 44;
    if ([self.leftButton imageForState:UIControlStateNormal]) {
      width = height = 44;
    }
    else
    {
      if (self.leftButton.enabled) {
        [self.leftButton setTitleColor:BUTTON_ACTIVECOLOR forState:UIControlStateNormal];
      }
      else
      {
        [self.leftButton setTitleColor:BUTTON_INACTIVECOLOR forState:UIControlStateNormal];
      }
    }
    
    NSLayoutConstraint *lead =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.leftButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self addConstraint:lead];

    NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.leftButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottom];
    
    NSLayoutConstraint *buttonHeight =[NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    [self.leftButton addConstraint:buttonHeight];
    
    NSLayoutConstraint *buttonWidht = [NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.leftButton addConstraint:buttonWidht];
  }
}

- (void)setRightButtonProperties
{
  if (self.rightButton) {
    
    float width , height;
    height = 44;
    width = 44;
    if ([self.rightButton imageForState:UIControlStateNormal]) {
      width = height = 44;
    }
    else
    {
      if (self.rightButton.enabled) {
        [self.rightButton setTitleColor:BUTTON_ACTIVECOLOR forState:UIControlStateNormal];
      }
      else
      {
        [self.rightButton setTitleColor:BUTTON_INACTIVECOLOR forState:UIControlStateNormal];
      }
    }
    
    NSLayoutConstraint *lead =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.rightButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self addConstraint:lead];
    
    NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.rightButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:bottom];
    
    NSLayoutConstraint *buttonHeight =[NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    [self.rightButton addConstraint:buttonHeight];
    
    NSLayoutConstraint *buttonWidht = [NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self.rightButton addConstraint:buttonWidht];
  }
}

- (void)setTitleProperties
{
  if (self.title) {
    float bottomSpace = 0;
    float title_hight = 20;
    
    NSLayoutConstraint *lead =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.title attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self addConstraint:lead];
    
    NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.title attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottomSpace];
    [self addConstraint:bottom];
    
    NSLayoutConstraint *trail =[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.title attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self addConstraint:trail];
    
    NSLayoutConstraint *titleHeight = [NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:title_hight];
    [self.title addConstraint:titleHeight];
  }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
