//
//  LCSearchViewController.h
//  LegacyConnect
//
//  Created by Vishnu on 8/26/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTabMenuView.h"

@interface LCSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet LCTabMenuView *tabMenu;

@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIView *usersContainer;
@property (weak, nonatomic) IBOutlet UIView *interestsContainer;
@property (weak, nonatomic) IBOutlet UIView *causesContainer;

@end
