//
//  LCListInterestsAndCausesVCViewController.h
//  LegacyConnect
//
//  Created by Jijo on 10/19/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCListInterestsAndCausesVCDelegate <NSObject>

- (void)didfinishPickingInterest :(LCInterest *)interest andCause :(LCCause *)cause;

@end

@interface LCListInterestsAndCausesVC : UIViewController

@property(nonatomic, retain) id delegate;
@end
