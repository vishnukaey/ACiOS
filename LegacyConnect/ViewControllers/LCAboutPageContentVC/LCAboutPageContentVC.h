//
//  LCAboutPageContentVC.h
//  LegacyConnect
//
//  Created by Kaey on 14/03/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAboutPageContentVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@end
