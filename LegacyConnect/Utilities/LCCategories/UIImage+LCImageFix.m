//
//  UIImage+LCImageFix.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "UIImage+LCImageFix.h"

@implementation UIImage (LCImageFix)

- (UIImage *)normalizedImage {
  if (self.imageOrientation == UIImageOrientationUp) return self;
  
  UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
  [self drawInRect:(CGRect){0, 0, self.size}];
  UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return normalizedImage;
}

@end
