//
//  LCPaginationHelper.m
//  LegacyConnect
//
//  Created by qbuser on 02/02/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCPaginationHelper.h"

@implementation LCPaginationHelper

#pragma mark - Pagination helper
+ (UIView*)getNoResultViewWithText:(NSString*)text
{
  UIView * noResultView = [[UIView alloc] init];
  UILabel * noResultLabel = [[UILabel alloc] init];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:text];
  [noResultView addSubview:noResultLabel];
  
  //add constraints
  noResultLabel.translatesAutoresizingMaskIntoConstraints = NO;
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [noResultView addConstraint:top];
  
  NSLayoutConstraint *height =[NSLayoutConstraint constraintWithItem:noResultLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0];
  [noResultView addConstraint:height];
  
  NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
  [noResultView addConstraint:left];
  
  NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
  [noResultView addConstraint:right];
  
  return noResultView;
}

+ (UIView*)getSearchNoResultViewWithText:(NSString*)text
{
  UIView * noResultView = [[UIView alloc] init];
  UILabel * noResultLabel = [[UILabel alloc] init];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:text];
  [noResultView addSubview:noResultLabel];
  
  //add constraints
  noResultLabel.translatesAutoresizingMaskIntoConstraints = NO;
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [noResultView addConstraint:top];
  
  NSLayoutConstraint *height =[NSLayoutConstraint constraintWithItem:noResultLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0];
  [noResultView addConstraint:height];
  
  NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
  [noResultView addConstraint:left];
  
  NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
  [noResultView addConstraint:right];
  
  return noResultView;
}


+ (UITableViewCell*)getNextPageLoaderCell
{
  UITableViewCell * loaderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  UIActivityIndicatorView * loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [loaderCell addSubview:loader];
  [loader startAnimating];
  loader.center = loaderCell.center;
  return loaderCell;
}

+ (UITableViewCell*)getEmptyIndicationCellWithText:(NSString*)text
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
  cell.textLabel.text = text;
  [cell.textLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [cell.textLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  cell.textLabel.textAlignment =NSTextAlignmentCenter;
  cell.textLabel.numberOfLines = 2;
  return cell;
}


@end
