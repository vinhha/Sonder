//
//  SocialMediaViewController.m
//  Sonder
//
//  Created by vinh ha on 1/6/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "SocialMediaViewController.h"
#import "TSAAppDelegate.h"

@interface SocialMediaViewController ()

@end

@implementation SocialMediaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.hidesBackButton = YES;
    [self startLocationManager];
    
    self.facebookLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.facebookLabel.layer.cornerRadius = 5;
    self.facebookLabel.layer.borderColor = [[UIColor blackColor]CGColor];
    self.facebookLabel.layer.borderWidth = 1;

    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        NSString *facebook = object[@"facebook"];
        NSLog(@"%@", facebook);
        if (facebook != nil) {
            [self.facebookLabel setEnabled:NO];
            [self.facebookLabel setTitle:@"Connected Facebook" forState:UIControlStateDisabled];
            [self.facebookLabel setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
            self.facebookLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        }
    }];

    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)facebook:(id)sender {
    
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        NSDictionary *userData = (NSDictionary *)result;
                        self.facebookId = userData[@"id"];
                    }}];
                
                NSLog(@"Woohoo, user logged in with Facebook!");
            }
            else{
                NSLog(@"%@", error);
            }
        }];
    }
    
    [NSThread sleepForTimeInterval:0.4];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.facebookLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.facebookLabel setEnabled:NO];
        [self.facebookLabel setTitle:@"Connected Facebook" forState:UIControlStateDisabled];
        [self.facebookLabel setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        self.facebookLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    }];
}

- (IBAction)finishSignUp:(id)sender {
    
    NSString *twitter  = self.twitterField.text;
    NSString *instagram = self.instagramField.text;
    
    [sender setEnabled:NO];
    
    PFUser *userProfile = [PFUser currentUser];
    
    userProfile[@"twitter"] = twitter;
    userProfile[@"instagram"] = instagram;
    
    if (self.facebookId != nil) {
    userProfile[@"facebook"] = self.facebookId;
    }
    
    [userProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
    }
        else {
            
            //Sign up the user.
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.navigationController.navigationBar.hidden = NO;
        }
        
    }];

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.instagramField resignFirstResponder];
    [self.twitterField resignFirstResponder];
}


#pragma marks - Location Manger

- (void) startLocationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 20;
        _locationManager.delegate = self;
    }
    
    [_locationManager startUpdatingLocation];
    
    PFGeoPoint *currentLocation =  [PFGeoPoint geoPointWithLocation:self.currentLocation];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:currentLocation forKey:@"location"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Got Location");
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
        }
    }];
    
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




