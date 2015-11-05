//
//  LCChooseActionsInterest.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCChooseActionsInterest : UIViewController
{
  IBOutlet UICollectionView * interstsCollection;
  NSArray *interestsArray;
}

- (IBAction)cancelAction;

@end
