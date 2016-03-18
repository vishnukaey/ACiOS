//
//  LCInviteEmailVC.h
//  LegacyConnect
//
//  Created by Kaey on 18/03/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCInviteEmailVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;
@property(strong, nonatomic) NSMutableArray *emailsArray;
@end
