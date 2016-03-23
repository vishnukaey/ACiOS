//
//  LCOnboardFinalSelectionVC.h
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCOnboardFinalSelectionVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *interestArray;
@property (weak, nonatomic) IBOutlet UIButton *doneBUtton;

@end
