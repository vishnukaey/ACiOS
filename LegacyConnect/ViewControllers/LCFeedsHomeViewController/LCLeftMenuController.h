//
//  leftMenuController.h
//  LegacyConnect
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


//---------protocols
@protocol leftMenuDelegate <NSObject>

-(void)leftMenuItemSelectedAtIndex:(NSInteger)index;//this function will be defined in the homefeed controller

@end

//------interface
@interface LCLeftMenuController : UIViewController {
  NSIndexPath *selectedIndexPath;
}

@property(nonatomic, retain)id delegate_;

@end
