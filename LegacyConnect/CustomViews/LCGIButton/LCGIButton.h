//
//  GIButton.h
//  AutoLayout
//
//  Created by User on 7/13/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCGIButton : UIButton

@property(nonatomic, retain)UIButton *communityButton, *postStatusButton, *postPhotoButton;

-(void)toggle;
-(void)setUpMenu;

@end
