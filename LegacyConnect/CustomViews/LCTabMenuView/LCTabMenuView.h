//
//  LCTabMenuView.h
//  LegacyConnect
//
//  Created by User on 8/11/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, constraintType) {
  constraintForMiddle,
  constraintForLeft,
  constraintForRight
};

@interface LCTabMenuView : UIView

@property(nonatomic, strong)NSArray *menuButtons;
@property(nonatomic, strong)NSArray *views;
@property(nonatomic, strong)UIColor *highlightColor, *normalColor;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)animateToIndex :(NSInteger)index;
@end
