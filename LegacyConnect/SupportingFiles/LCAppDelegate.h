//
//  LCAppDelegate.h
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UIButton *menuButton;
@property (nonatomic, retain) id GIButton;
+ (LCAppDelegate *)appDelegate;
@end

