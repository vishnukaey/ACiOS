//
//  LCAppDelegate.h
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"


@interface LCAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) id menuButton;
@property (nonatomic, retain) id GIButton;
@property (nonatomic, retain) MFSideMenuContainerViewController *mainContainer;
@property (nonatomic, retain) id currentPostEntity;
@property (nonatomic, assign) BOOL isCreatePostOpen;//this property is to determine if the create post popup is open and to decide wether unhide gibutton and menubutton in the viewwillappear method of the underlying screen(eg ; homefeed screen). The viewwill appear method in the create post popup controller will not be called(instead the viewwill appear method of the underlying controller will be called when coming back from say imagepicker controller) as its Presentation style set to UIModalPresentationOverCurrentContext for showing the transparent background to see the underlying screen
+ (LCAppDelegate *)appDelegate;
@end

