//
//  LCChooseCausesVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChooseCausesVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *interestsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *causesCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontroller;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@end
