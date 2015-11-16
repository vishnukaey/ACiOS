//
//  LCSearchCausesViewController.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSearchCausesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *causesCollectionView;
@property (nonatomic,retain) NSArray *causesArray;

@end
