//
//  LCOnboardFinalSelectionVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardFinalSelectionVC.h"

#pragma mark - LCCausesHeaderReusableView class
@interface LCCausesHeaderReusableView : UICollectionReusableView
  @property (weak, nonatomic) IBOutlet UILabel *interestName;
  @property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@end

@implementation LCCausesHeaderReusableView
@end

@interface LCOnboardFinalSelectionVC ()

@end

@implementation LCOnboardFinalSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:NO ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma CollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

  return 8;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  
  static NSString *identifier = @"causesCollectionViewCell";
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  return cell;
  
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  if (kind == UICollectionElementKindSectionHeader) {
    
    LCCausesHeaderReusableView *reusableview =(LCCausesHeaderReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell" forIndexPath:indexPath];
    reusableview.interestName.text = @"Header";
    return reusableview;
  }
  return nil;
}

@end
