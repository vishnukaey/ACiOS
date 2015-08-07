//
//  LCAllInterestVC.h
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAllInterestVC : UIViewController
{
  IBOutlet UICollectionView *H_interestsCollection;
  NSArray *H_interestsMine, *H_interestsAll, *H_selectedDataArray;
}

- (IBAction)toggleMineORAll:(UIButton *)sender;

@end
