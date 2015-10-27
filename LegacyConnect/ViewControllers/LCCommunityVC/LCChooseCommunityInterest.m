//
//  LCChooseCommunityInterest.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseCommunityInterest.h"
#import "LCCreateCommunity.h"
#import "LCCommunityInterestCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LCChooseCommunityInterest

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [LCAPIManager getInterestsWithSuccess:^(NSArray *response)
    {
      interestsArray = response;
      [interstsCollection reloadData];
    }
    andFailure:^(NSString *error)
    {
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

#pragma mark - Initial setup functions
/* use this function if need to add in a scrollview
- (void)displayInterestsFromResponse :(NSArray *)response
{
  float x_margin = 10, y_margin = 10;
  float icon_size = (interstsScroll.frame.size.width - 4*x_margin)/3;
  float labelHeight = 30;

  for (int i = 0; i<response.count; i++)
  {
    UIButton *interestView = [[UIButton alloc] initWithFrame:CGRectMake((i%3 + 1)*x_margin + icon_size*(i%3), (i/3 + 1)*y_margin + (icon_size + labelHeight) * (i/3), icon_size, (icon_size + labelHeight))];
    [interestView addTarget:self action:@selector(interestSelected:) forControlEvents:UIControlEventTouchUpInside];
    [interstsScroll addSubview:interestView];
    
    LCInterest *interstObj = [response objectAtIndex:i];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icon_size, icon_size)];
    [interestView addSubview:imageView];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:interstObj.logoURL]];
    imageView.image = [UIImage imageWithData:imageData];
    
    UILabel *interestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, icon_size, icon_size, labelHeight)];
    interestLabel.font = [UIFont systemFontOfSize:10];
    [interestView addSubview:interestLabel];
    interestLabel.text = interstObj.name;
    interestLabel.textAlignment = NSTextAlignmentCenter;
  }
}
 */

#pragma mark - button actions
- (IBAction)cancelAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - collection view delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return interestsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"LCCommunityInterestCell";
  LCCommunityInterestCell *cell = (LCCommunityInterestCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  if (cell == nil)
  {
    NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCCommunityInterestCell class]) owner:nil options:nil];
    cell=cells[0];
  }
  LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
  cell.interestNameLabel.text = interstObj.name;
  
  [cell.interestIcon sd_setImageWithURL:[NSURL URLWithString:interstObj.logoURLLarge] placeholderImage:nil];
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCCreateCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCCreateCommunity"];
  LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
  vc.interestId = interstObj.interestID;
  [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
