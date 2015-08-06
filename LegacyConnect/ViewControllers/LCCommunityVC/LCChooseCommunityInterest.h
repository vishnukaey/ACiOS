//
//  LCChooseCommunityInterest.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCChooseCommunityInterest : UIViewController
{
  IBOutlet UICollectionView * H_interstsCollection;
  NSArray *H_interestsArray;
}

- (IBAction)cancelAction;

@end
