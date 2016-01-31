//
//  LCFullScreenImageVC.h
//  LegacyConnect
//
//  Created by User on 7/31/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeed.h"

typedef void (^ FullScreenFinishAction)(id sender, BOOL showComments);

@interface LCFullScreenImageVC : UIViewController

@property (nonatomic, strong) LCFeed * feed;
@property (readwrite, copy) FullScreenFinishAction commentAction;


@end
