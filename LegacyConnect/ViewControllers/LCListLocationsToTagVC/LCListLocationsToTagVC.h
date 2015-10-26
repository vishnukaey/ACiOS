//
//  LCListLocationsToTagVC.h
//  LegacyConnect
//
//  Created by Jijo on 8/25/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLocationSearchField.h"

@protocol LCListLocationsToTagVCDelegate <NSObject>

- (void)didfinishPickingLocation :(NSString *)location;

@end

@interface LCListLocationsToTagVC : UIViewController<locationsSearchFieldDelegate>

@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) NSString *alreadyTaggedLocation;
@end
