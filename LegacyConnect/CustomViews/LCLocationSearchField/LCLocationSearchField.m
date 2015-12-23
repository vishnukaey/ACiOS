//
//  LCLocationSearchField.m
//  MapKit
//
//  Created by User on 7/30/15.
//  Copyright (c) 2015 User. All rights reserved.
//usage->>set locdelegate and implement the ||- (void)recievedLocations: (NSMutableArray *)locations;|| method

#import "LCLocationSearchField.h"
#define MINIMUM_SEARCHLENGTH 2
#define SEARCH_SPAN_MILES 1000

@interface LCLocationSearchField()
{
  CLLocationManager *locManager;
  CLLocation *newLocation;
  UIActivityIndicatorView *activity;
  MKLocalSearch *previousSearch;
}

@end

@implementation LCLocationSearchField
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    locManager = [[CLLocationManager alloc] init];
    [locManager setDelegate:self];
    [locManager setDesiredAccuracy:kCLLocationAccuracyBest];
    if ([locManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
      [locManager requestWhenInUseAuthorization];
    }
    [locManager startUpdatingLocation];

    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.hidesWhenStopped = YES;
    [self addSubview:activity];
    activity.center = CGPointMake(frame.size.width - frame.size.height/2, frame.size.height/2);
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    locManager = [[CLLocationManager alloc] init];
    [locManager setDelegate:self];
    [locManager setDesiredAccuracy:kCLLocationAccuracyBest];
    if ([locManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
      [locManager requestWhenInUseAuthorization];
    }
    [locManager startUpdatingLocation];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.hidesWhenStopped = YES;
    [self addSubview:activity];
    activity.center = CGPointMake(self.frame.size.width - self.frame.size.height/2 - 100, self.frame.size.height/2);
  }
  
  return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  newLocation = [locations lastObject];
}

- (void)searchForLocations:(NSString *)string
{
  [activity stopAnimating];
  [previousSearch cancel];
  if (string.length<MINIMUM_SEARCHLENGTH)
  {
    return;
  }
  [activity startAnimating];
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(search:) object:nil];
  [self performSelectorInBackground:@selector(search:) withObject:string];
}

- (void)search :(NSString *)string
{
  MKLocalSearchRequest *request =
  [[MKLocalSearchRequest alloc] init];
  request.naturalLanguageQuery = string;
  
  MKCoordinateRegion region;
//  MKCoordinateSpan span;
//  span.latitudeDelta = 0.005;
//  span.longitudeDelta = 0.005;
//  region.span = span;
//  region.center = newLocation.coordinate;
  request.region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,
                                                      1609.34*SEARCH_SPAN_MILES, 1609.34*SEARCH_SPAN_MILES);
  request.region = region;
  
  MKLocalSearch *search =
  [[MKLocalSearch alloc]initWithRequest:request];
  previousSearch = search;
  [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
  {
    previousSearch = nil;
    NSMutableArray *locations_ = [[NSMutableArray alloc] init];
    for (MKMapItem *item in response.mapItems)
    {
      [locations_ addObject:item.name];
    }
    NSArray *returnArray = [locations_ copy];
    if (self.locdelegate && [self.locdelegate respondsToSelector:@selector(recievedLocations:)]) {
      [self.locdelegate recievedLocations:returnArray];
    }
    [activity stopAnimating];
  }];
}


//
//-(void) setDelegate:(id<locationsSearchFieldDelegate>) delegate {
//  [super setDelegate: delegate];
//}
//- (id) delegate {
//  return [super delegate];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
