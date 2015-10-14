//
//  LCLikeButton.m
//  LegacyConnect
//
//  Created by qbuser on 14/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCThanksButtonImage.h"

@implementation LCThanksButtonImage

- (void)setLikeUnlikeStatusImage:(NSString*)didLike
{
  [self setTintColor:([didLike boolValue] ? kLikedColour : kUnLikedColor)];
}

@end
