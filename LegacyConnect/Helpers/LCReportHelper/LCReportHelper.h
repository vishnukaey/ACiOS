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
+ (void)showCommentReportActionSheetFromView:(UIViewController*)presentingView withComment:(LCComment*)comment;

@end
