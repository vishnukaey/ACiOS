//
//  LCLocationSearchField.h
//  MapKit
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol locationsSearchFieldDelegate <NSObject>

- (void)recievedLocations: (NSMutableArray *)locations;

@end

@interface LCLocationSearchField : UITextField<CLLocationManagerDelegate>

@property(nonatomic, retain)id locDelegate;

- (void)searchForLocations :(NSString *)string;

@end
