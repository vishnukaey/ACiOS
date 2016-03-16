//
//  LCTutorialView.h
//  LegacyConnect
//
//  Created by Jijo on 3/15/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCTutorialView : UIView

@property(nonatomic, retain) IBOutlet UILabel *tapToDismissLabel;

- (UIColor *)colorBackground;
- (UIColor *)colorFontGrey;
- (UIColor *)colorFontRed;
- (UIFont *)font;


@end
