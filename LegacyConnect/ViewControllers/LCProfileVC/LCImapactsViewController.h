//
//  LCImapactsViewController.h
//  LegacyConnect
//
//  Created by Jijo on 8/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCImapactsViewController : UIViewController
{
  NSMutableArray *impactsArray;
}
@property(nonatomic, weak)IBOutlet  UITableView *impactsTableView;
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint *customNavigationHeight;
@property(nonatomic, retain)LCUserDetail *userDetail;

@end
