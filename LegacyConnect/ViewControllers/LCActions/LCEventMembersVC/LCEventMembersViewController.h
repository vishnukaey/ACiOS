//
//  LCEventMembersViewController.h
//  LegacyConnect
//
//  Created by Kaey on 09/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCEventMembersViewController : UIViewController
@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) LCEvent *event;
@end
