//
//  LCLoadPreviousCell.h
//  LegacyConnect
//
//  Created by qbuser on 16/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoadPreviousDataAction)(UIButton * sender);

@interface LCLoadPreviousCell : UITableViewCell
{
  IBOutlet UIButton * loadMorebtn;
}

@property (readwrite, copy) LoadPreviousDataAction loadPrevousAction;

@end
