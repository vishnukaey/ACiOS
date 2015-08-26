//
//  LCSearchViewController.h
//  LegacyConnect
//
//  Created by qbuser on 8/26/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTabMenuView.h"

@interface LCSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet LCTabMenuView *tabMenu;
@end
