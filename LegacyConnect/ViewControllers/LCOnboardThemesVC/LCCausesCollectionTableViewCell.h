//
//  LCCausesCollectionTableViewCell.h
//  LegacyConnect
//
//  Created by Akhil K C on 12/16/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCausesCollectionTableViewCell : UITableViewCell

  @property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
  @property (strong, nonatomic) LCInterest *interest;
  @property (strong, nonatomic) NSArray *causesArray;

  - (void)reloadCollectionView;
@end
