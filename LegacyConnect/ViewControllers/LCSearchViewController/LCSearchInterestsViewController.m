//
//  LCSearchInterestsViewController.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchInterestsViewController.h"
#import "LCChooseInterestCVC.h"

@interface LCSearchInterestsViewController ()

@end

@implementation LCSearchInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)getNOResultLabel
{
  UILabel * noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:@"No Results Found"];
  return noResultLabel;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    UIView *prev = [collectionView viewWithTag:122];
    if (prev) {
      [prev removeFromSuperview];
    }
    if (!_interestsArray.count) {
      UIView *noResultView = [self getNOResultLabel];
      noResultView.tag = 122;
      noResultView.center = CGPointMake(collectionView.frame.size.width/2, noResultView.center.y);
      [collectionView addSubview:noResultView];
    }
    return _interestsArray.count;
  
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *identifier = @"interestsCollectionViewCell";
    LCChooseInterestCVC *cell = (LCChooseInterestCVC*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.interest = _interestsArray[indexPath.item];
    return cell;
  
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  // Uncomment for Selection of interest and cause
  
  
  /*
   if([collectionView isEqual:_causesCollectionView])
   {
   UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
   LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
   [self.navigationController pushViewController:vc animated:YES];  }
   else
   {
   UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
   LCSingleInterestVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
   [self.navigationController pushViewController:vc animated:YES];
   }
   */
  
}

@end
