//
//  LCNavigationBar.h
//  LegacyConnect
//
//  Created by Jijo on 12/3/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCNavigationBar : UIView

@property(nonatomic, weak)IBOutlet UILabel *title;
@property(nonatomic, weak)IBOutlet UIButton *rightButton;
@property(nonatomic, weak)IBOutlet UIButton *leftButton;

- (void)layoutComponents;
+ (UIColor *)getTitleColor;
+ (UIFont *)getTitleFont;
+ (UIColor *)getNavigationBarColor;

@end
