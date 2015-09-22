//
//  LCLoadMoreCell.h
//  LegacyConnect
//
//  Created by qbuser on 22/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoadMoreCellTapAction)(UITableViewCell *loadMoreCell);

@interface LCLoadMoreCell : UITableViewCell

@property (nonatomic, weak) LoadMoreCellTapAction loadMoreCellTapAction;

@end
