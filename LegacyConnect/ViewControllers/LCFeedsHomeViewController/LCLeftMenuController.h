//
//  leftMenuController.h
//  LegacyConnect
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


//---------protocols
@protocol leftMenuDelegate <NSObject>

-(void)leftMenuButtonActions:(UIButton *)sender;//this function will be defined in the homefeed controller

@end

//------interface
@interface LCLeftMenuController : UIViewController

@property(nonatomic, assign)float P_menuwidth;
@property(nonatomic, retain)id delegate_;
@property (nonatomic, strong) UIImageView *userImageView;

@end
