//
//  LCOnboardFinalSelectionVC.h
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCOnboardFinalSelectionVC : UIViewController

@property(nonatomic, weak)NSMutableArray *selectedItems;//{causesArray, InterestsArray}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *interestArray;

@end
