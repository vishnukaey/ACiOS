//
//  LCCauseSupportersVC.h
//  LegacyConnect
//
//  Created by Kaey on 12/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUsersListBC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>


@interface LCCauseSupportersVC : LCUsersListBC
@property (weak, nonatomic) LCCause *cause;
@end
