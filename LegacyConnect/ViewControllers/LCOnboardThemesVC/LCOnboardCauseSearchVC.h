//
//  LCOnboardCauseSearchVC.h
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCOnboardCauseSearchVC : UIViewController

@property(nonatomic, weak) NSMutableArray *selectedItems;//{causesArray, InterestsArray}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *causesCollectionView;
@end
