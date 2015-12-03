//
//  LCSearchInterestsViewController.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCollectionViewController.h"

@interface LCSearchInterestsViewController : LCCollectionViewController

@property (nonatomic,retain) NSString *searchKey;
- (void)setInterestsArray:(NSArray*)interests;

@end
