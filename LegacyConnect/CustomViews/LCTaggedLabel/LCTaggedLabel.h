//
//  LCTaggedLabel.h
//  LegacyConnect
//
//  Created by User on 8/17/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tagTapped)(int index);

@interface LCTaggedLabel : UILabel<NSLayoutManagerDelegate>

@property(nonatomic, strong)NSLayoutManager *layoutManager;
@property(nonatomic, strong)NSTextContainer *textContainer;
@property(nonatomic, strong)NSTextStorage *textStorage;
@property(nonatomic, strong)NSArray *tagsArray;
@property(readwrite, copy) tagTapped nameTagTapped;
@property(nonatomic, assign)UIEdgeInsets insets;
@end
