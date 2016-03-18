//
//  LCCreatePostTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/18/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCCreatePostTutorial.h"


@interface LCCreatePostTutorial ()
{
  IBOutlet UIImageView *imageView;
}
@end

@implementation LCCreatePostTutorial


- (void) awakeFromNib {
  [super awakeFromNib];
  [imageView setBackgroundColor:[self colorTransparentBlack]];
}
@end
