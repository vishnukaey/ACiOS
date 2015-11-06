//
//  LCSearchTopViewController.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSearchTopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (nonatomic,retain) LCSearchResult *searchResultObject;

@end
