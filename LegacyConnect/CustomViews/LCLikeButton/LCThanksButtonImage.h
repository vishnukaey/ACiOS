//
//  LCLikeButton.h
//  LegacyConnect
//
//  Created by qbuser on 14/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * kUnLikedStatus = @"0";
static NSString * kLikedStatus = @"1";

#define kLikedColour [UIColor colorWithRed:239.0f/255 green:100.0f/255 blue:77.0f/255 alpha:1]
#define kUnLikedColor [UIColor colorWithRed:222.0f/255 green:223.0f/255 blue:224.0f/255 alpha:1]

@interface LCThanksButtonImage : UIImageView

- (void)setLikeUnlikeStatusImage:(NSString*)didLike;


@end
