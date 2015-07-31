//
//  feedCellView.h
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

//--------------protocols
@protocol feedCellDelegate <NSObject>

//action type-- <<1 for like>>   <<2 for comment>>
-(void)feedCellActionWithType :(int)type andID:(NSString *)postID;

@end

//---------------interface
@interface LCFeedCellView : UIView

@property(nonatomic, retain)id delegate;

-(void)arrangeSelfForData :(NSDictionary *)dic forWidth:(float)width_ forPage :(NSString *)pageType;

@end
