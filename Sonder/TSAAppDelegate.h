//
//  TSAAppDelegate.h
//  Sonder
//
//  Created by vinh ha on 1/3/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface TSAAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>{
    UIApplication *app;
}


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) PFGeoPoint *myLocation;
@property (strong, nonatomic) NSNumber *locationTag;


@property (strong, nonatomic) UIWindow *window;

- (void) startLocationManager;
- (void) stopLocationManager;

@end
