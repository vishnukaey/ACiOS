//
//  LCLocationSearchField.h
//  MapKit
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol locationsSearchFieldDelegate

- (void)recievedLocations: (NSArray *)locations;

@end

@interface LCLocationSearchField : UISearchBar<CLLocationManagerDelegate>

@property(nonatomic, weak)id locdelegate;

- (void)searchForLocations :(NSString *)string;

@end
