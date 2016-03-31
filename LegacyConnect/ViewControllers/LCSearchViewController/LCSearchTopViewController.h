//
//  LCSearchTopViewController.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchTopBC.h"

@interface LCSearchTopViewController : LCSearchTopBC
@property (weak, nonatomic) IBOutlet UIView *noResultsView;
@property (nonatomic,retain) NSString *searchKey;
@end
