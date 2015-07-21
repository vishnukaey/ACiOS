//
//  leftMenuController.h
//  LegacyConnect
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol leftMenuDelegate <NSObject>

-(void)leftMenuButtonActions:(UIButton *)sender;//this function will be defined in the homefeed controller

@end

@interface leftMenuController : UIViewController


@property(nonatomic, assign)float P_menuwidth;
@property(nonatomic, retain)id delegate_;
@end
