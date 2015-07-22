//
//  LCLoginTextField.m
//  LegacyConnect
//
//  Created by Vishnu on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCLoginTextField.h"

@implementation LCLoginTextField
{
  UIImageView *warning;
}

-(id)init
{
  self = [super init];
  if (self)
  {
    [self initStyles];
  }
  return self;
}

- (void)initStyles
{
  if(self)
  {
    warning = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-18, 5, 15, 15)];
    warning.image = [UIImage imageNamed:@"warning@2x.png"];
    warning.hidden=YES;
    [self addSubview:warning];
  }
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super initWithCoder:decoder];
  if (self)
  {
    [self initStyles];
  }
  return self;
}

-(BOOL)isIsValid
{
  if(_isValid)
  {
    warning.hidden =YES;
  }
  else
  {
    warning.hidden = NO;
  }
  return _isValid;
}

- (void)setIsValid:(bool)isValid
{
  _isValid = isValid;
  if(_isValid)
  {
    warning.hidden =YES;
  }
  else
  {
    warning.hidden = NO;
  }
}

@end
