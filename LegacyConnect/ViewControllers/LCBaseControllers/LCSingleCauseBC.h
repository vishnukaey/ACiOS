//
//  LCSingleCauseBC.h
//  LegacyConnect
//
//  Created by Jijo on 1/15/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "JTTableViewController.h"

@interface LCSingleCauseBC : JTTableViewController

@property (strong, nonatomic) LCCause *cause;
@property (strong, nonatomic)IBOutlet UIButton *causeSupportersCountButton;
@property (strong, nonatomic)IBOutlet UIButton *causeURLButton;
@property (strong, nonatomic)IBOutlet UILabel *causeNameLabel;
@property (strong, nonatomic)IBOutlet UILabel *causeDescriptionLabel;
@property (strong, nonatomic)IBOutlet UIImageView *causeImageView;
@property (strong, nonatomic)IBOutlet UIImageView *causeOverlayImageView;
@property (strong, nonatomic)IBOutlet UIButton *supportButton;
@property (strong, nonatomic)IBOutlet LCNavigationBar *navigationBar;

- (void)setNoResultViewHidden:(BOOL)hidded;

-(void)refreshViewWithCauseDetails;
@end
