//
//  SocialMediaViewController.h
//  Sonder
//
//  Created by vinh ha on 1/6/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface SocialMediaViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

- (void) startLocationManager;
- (void) stopLocationManager;

@property (strong, nonatomic) IBOutlet UITextField *twitterField;
@property (strong, nonatomic) IBOutlet UITextField *instagramField;
@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) IBOutlet UIButton *facebookLabel;

- (IBAction)facebook:(id)sender;
- (IBAction)finishSignUp:(id)sender;

@end
