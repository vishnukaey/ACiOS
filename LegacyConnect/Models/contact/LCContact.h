//
//  contact.h
//  LegacyConnect
//
//  Created by User on 7/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCContact : NSObject

@property(nonatomic, retain)NSString * P_name;
@property(nonatomic, retain)NSString * P_address;
@property(nonatomic, retain)UIImage * P_image;
@property(nonatomic, retain)NSString * P_imageURL;
@property(nonatomic, retain)NSArray *P_numbers;
@property(nonatomic, retain)NSArray * P_emails;

@end
