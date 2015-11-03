//
//  LCSearchViewController.h
//  LegacyConnect
//
//  Created by Vishnu on 8/26/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTabMenuView.h"
#import <JTTableViewController.h>

@interface LCSearchViewController : JTTableViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *causesCollectionView;
@property (weak, nonatomic) IBOutlet LCTabMenuView *tabMenu;
@end
