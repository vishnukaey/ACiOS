//
//  LCSearchTopBC.h
//  LegacyConnect
//
//  Created by Jijo on 11/17/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSearchTopBC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (nonatomic,retain) LCSearchResult *searchResultObject;

@end
