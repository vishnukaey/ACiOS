//
//  LCFullScreenImageVC.h
//  LegacyConnect
//
//  Created by User on 7/31/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCFullScreenImageVC : UIViewController


@property(nonatomic, retain) NSString *imageUrlString;

#warning remove this field and replace with 'imageUrl'
@property(nonatomic, retain)UIImageView *imageView;

@end
