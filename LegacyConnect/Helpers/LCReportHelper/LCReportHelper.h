//
//  LCReportHelper.h
//  LegacyConnect
//
//  Created by Akhil K C on 1/30/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCReportHelper : NSObject

+ (void)showPostReportActionSheetFromView:(UIViewController*)presentingView withPost:(LCFeed*)feed;
+ (void)showCommentReportActionSheetFromView:(UIViewController*)presentingView forPost:(LCFeed *)post withComment:(LCComment*)comment isMyPost:(BOOL)isMyPost;
+ (void)showCommentReportActionSheetFromView:(UIViewController*)presentingView forAction:(LCEvent *)action withComment:(LCComment*)comment isMyAction:(BOOL)isMyAction;
+ (void)showActionReportActionSheetFromView:(UIViewController*)presentingView withAction:(LCEvent*)action;

@end
