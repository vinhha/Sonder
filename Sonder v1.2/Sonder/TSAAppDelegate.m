//
//  TSAAppDelegate.m
//  Sonder
//
//  Created by vinh ha on 1/3/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "TSAAppDelegate.h"
#import <Parse/Parse.h>
#import "PostsViewController.h"
#import "SonderViewController.h"


@implementation TSAAppDelegate

BOOL locationStarted = FALSE;
@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Parse setApplicationId:@"VW3bZhirX7USTbnhf6YFHOuBF0kvaTOURXrxnIao"
                  clientKey:@"9WQfvvB4Z9hZk6kVUFbIngnn7iLSfCuEALJW7Xc9"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    [self startLocationManager];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [NSThread sleepForTimeInterval:3.0];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    
    app = [UIApplication sharedApplication];
    
    
//    int i = 2;
//    
//    while (i < 102) {
//        
//        PFUser *newUser = [PFUser user];
//        newUser.username = [NSString stringWithFormat:@"%d", i];
//        newUser.password = @"tester";
//        newUser[@"name"] = [NSString stringWithFormat:@"%d", i];
//        newUser[@"gender"] = @"Male";
//        newUser[@"birthday"] = @"11/03/1993";
//        newUser[@"post"] = @"Test-icle";
//        newUser[@"location"] = [PFGeoPoint geoPointWithLatitude:0.0 longitude:0.0];
//        newUser[@"complimentsValue"] = [NSNumber numberWithInteger: 00];
//        newUser[@"postValue"] = [NSNumber numberWithInteger: 00];
//        newUser[@"thoughtTotal"] = [NSNumber numberWithInt: 00];
//        newUser[@"profileTotal"] = [NSNumber numberWithInt: 00];
//        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        }];
//
//        
//        i++;
//    }
//    
    
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];//[UIColor colorWithRed:180.0/255.0f green:235.0/255.0f blue:250.0/255.0f alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.locationTag = [NSNumber numberWithInt:0];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication: sourceApplication withSession:[PFFacebookUtils session]];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self startLocationManager];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.locationTag = [NSNumber numberWithInt:0];
    [self startLocationManager];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    self.locationTag = [NSNumber numberWithInt:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma marks - Push notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [PFPush handlePush:userInfo];
    

}


#pragma marks - Location Manager

- (void) startLocationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.pausesLocationUpdatesAutomatically = YES;
        _locationManager.distanceFilter = 100;
        _locationManager.delegate = self;
    }
    
    [self runBackgroundTask:20];
    
    [_locationManager startUpdatingLocation];
    
    PFGeoPoint *currentLocation =  [PFGeoPoint geoPointWithLocation:self.currentLocation];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:currentLocation forKey:@"location"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Got Location");
            [self reloadInputViews];
        }
    }];
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%@", [locations lastObject]);
    
    self.currentLocation  = [locations lastObject];
    
    PFGeoPoint *myLocation =  [PFGeoPoint geoPointWithLocation:self.currentLocation];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:myLocation forKey:@"location"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Got Location");
            if ([self.locationTag intValue] == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotLocation" object:nil];
                self.locationTag = [NSNumber numberWithInt:1];
            }
        }
    }];
    
}

-(void)runBackgroundTask: (int) time{
    //check if application is in background mode
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
        //create UIBackgroundTaskIdentifier and create background task, which starts after time
        __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(startTrackingBg) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(startTrackingBg) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
        
    }
}


-(void)startTrackingBg{
    //write background time remaining
    int time;
    //set default time
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        time = 900;
    } else {
        time = 300;
    }
    //if locationManager is ON
    if (locationStarted == TRUE ) {
        //stop update location
        [self.locationManager stopUpdatingLocation];
        locationStarted = FALSE;
    }else{
        //start updating location
        [self.locationManager startUpdatingLocation];
        locationStarted = TRUE;
        //ime how long the application will update your location
        time = 5;
    }
    
    [self runBackgroundTask:time];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
    if ([error code] !=kCLErrorLocationUnknown) {
        [self stopLocationManager];
    }
    
}

- (void) stopLocationManager {
    
    [self.locationManager stopUpdatingLocation];
    
}

@end
