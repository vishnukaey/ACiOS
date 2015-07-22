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
{
    
}

-(void)showMenu;
-(void)hideMenu;
-(void)setUpMenu;

@property(nonatomic, retain)UIButton *P_community, *P_status, *P_video;
@end
