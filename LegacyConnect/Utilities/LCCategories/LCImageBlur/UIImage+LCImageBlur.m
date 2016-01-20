//
//  UIImage+LCImageBlur.m
//  LegacyConnect
//
//  Created by Akhil K C on 1/13/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "UIImage+LCImageBlur.h"

@implementation UIImage (LCImageBlur)

- (UIImage *) bluredImage
{
  CIContext *context = [CIContext contextWithOptions:nil];
  CIImage *inputImage = [[CIImage alloc] initWithImage:self];
  CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
  [filter setValue:inputImage forKey:kCIInputImageKey];
  [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
  CIImage *result = [filter valueForKey:kCIOutputImageKey];
  CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
  UIImage* blurredImage = [[UIImage alloc] initWithCGImage:cgImage];
  return blurredImage;
}

@end
