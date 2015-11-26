//
//  LCEventMembersViewController.h
//  LegacyConnect
//
//  Created by Kaey on 09/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCEventMembersListBC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>

@interface LCEventMembersViewController : LCEventMembersListBC
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteViewHeight;
@property (weak,nonatomic) LCEvent *event;
@end
