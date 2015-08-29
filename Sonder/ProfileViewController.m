//
//  ProfileViewController.m
//  Sonder
//
//  Created by vinh ha on 1/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

//@synthesize profileImage;
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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:21.0]};
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.canCancelContentTouches = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(320, 569);
    [self.view addSubview:self.scrollView];
    
    self.contentView.frame = CGRectMake(-160, -225, 320, 568);
    //self.refreshButton.frame = CGRectMake(0, 500, 280, 30);
//    self.igButton.frame = CGRectMake(250, 505, 60, 60);
//    self.twitterButton.frame = CGRectMake(143, 505, 60, 60);
//    self.fbButton.frame = CGRectMake(35, 505, 60, 60);
//    self.pictureButton.frame = CGRectMake(0, 50, 120, 120);
//    self.refreshButton.layer.cornerRadius = 5;
//    self.refreshButton.layer.borderColor = [[UIColor blackColor]CGColor];
//    self.refreshButton.layer.borderWidth = 1;
    
    
    self.profileImage.layer.cornerRadius = 60;
    self.profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileImage.layer.borderWidth = 2;
    self.profileImage.layer.masksToBounds = YES;
    
    self.aboutMeLabel.layer.borderColor = [[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.7]CGColor];
    self.aboutMeLabel.layer.borderWidth =1;
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeSystem];//[[UIButton alloc] initWithFrame:CGRectMake(15, 300, 280, 30)];
    [testButton setTitle:@"REFRESH" forState:UIControlStateNormal];
    testButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    testButton.layer.cornerRadius = 5;
    testButton.layer.borderColor = [[UIColor blackColor]CGColor];
    testButton.layer.borderWidth = 1;
    [testButton setEnabled:YES];
    testButton.frame = CGRectMake(30, 320, 260, 30);
    [testButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *twitterImage = [UIImage imageNamed:@"01_twitter.png"];
    [twitterButton setImage:twitterImage forState:UIControlStateNormal];
    [twitterButton setEnabled:YES];
    twitterButton.frame = CGRectMake(140, 455, 45, 45);
    [twitterButton addTarget:self action:@selector(twitterProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *facebookButtonImage = [UIImage imageNamed:@"02_facebook.png"];
    [facebookButton setImage:facebookButtonImage forState:UIControlStateNormal];
    [facebookButton setEnabled:YES];
    facebookButton.frame = CGRectMake(45, 455, 45, 45);
    [facebookButton addTarget:self action:@selector(fbProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *instaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *instagramButtonImage = [UIImage imageNamed:@"10_instagram.png"];
    [instaButton setImage:instagramButtonImage forState:UIControlStateNormal];
    [instaButton setEnabled:YES];
    instaButton.frame = CGRectMake(235, 455, 45, 45);
    [instaButton addTarget:self action:@selector(instagramProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [photoButton setEnabled:YES];
    photoButton.frame = CGRectMake(23, 90, 120, 120);
    [photoButton setBackgroundColor:[UIColor clearColor]];
    [photoButton addTarget:self action:@selector(profileEnlarge:) forControlEvents:UIControlEventTouchUpInside];

    
    
    [self.scrollView addSubview:self.contentView];
    [self.scrollView addSubview:testButton];
    [self.scrollView addSubview:twitterButton];
    [self.scrollView addSubview:facebookButton];
    [self.scrollView addSubview:instaButton];
    [self.scrollView addSubview:photoButton];
//    [self.scrollView addSubview:self.refreshButton];
//    [self.scrollView addSubview:self.igButton];
//    [self.scrollView addSubview:self.twitterButton];
//    [self.scrollView addSubview:self.fbButton];
//    [self.scrollView addSubview:self.pictureButton];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    
    self.navigationController.navigationBar.topItem.title = self.name;

    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    
        PFQuery *query = [PFUser query];
        [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
            
            self.navigationController.navigationBar.topItem.title = object[@"name"];
            self.school = object[@"school"];
            //self.age = object[@"age"];
            self.birthdate = object[@"birthday"];
            self.bio = object[@"bio"];
            self.compliments = object[@"complimentsValue"];
            self.relationshipStatus = object[@"relationship"];
            self.aboutMe = object[@"AboutMe"];
            self.thoughts = object[@"thoughtTotal"];
            self.profile = object[@"profileTotal"];
            self.name = object[@"name"];
            
            
            if (self.birthdate != nil && self.birthdate.length != 0) {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; [dateFormat setDateFormat:@"MM/dd/yyyy"];
                NSDate *birthday = [dateFormat dateFromString:self.birthdate];
                NSDate* now = [NSDate date];
                NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                               components:NSYearCalendarUnit
                                               fromDate:birthday
                                               toDate:now
                                               options:0];
                NSInteger number = [ageComponents year];
                NSNumber *age = [NSNumber numberWithInteger: number];
            
                self.age = [age stringValue];
            }
            else {
                self.age = nil;
            }
            
            
            if (self.school != nil && self.age != nil){
                self.schoolAndName.text = [[NSArray arrayWithObjects:self.school, self.age, nil] componentsJoinedByString:@", "];
            }
            else {
                if (self.school == nil && self.age != nil){
                    self.schoolAndName.text = self.age;
                }
                else {
                    if (self.school != nil && self.age == nil){
                        self.schoolAndName.text = self.school;
                    }
                    else {
                        if (self.school == nil && self.age == nil) {
                            self.schoolAndName.text = @"Sonder";
                        }
                    }
                }
            }
            
            
            self.aboutMeLabel.text = self.aboutMe;
            self.bioLabel.text = [[NSArray arrayWithObjects:self.bio, nil] componentsJoinedByString:@" "];
            self.complimentLabel.text = [self.compliments stringValue];
            self.thoughtsTotal.text = [self.thoughts stringValue];
            self.profileTotal.text = [self.profile stringValue];
            self.statusLabel.text = self.relationshipStatus;
            
            PFFile *imageFile = [object objectForKey:@"file"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:result];
                    self.profileImage.image = image;
                    
                }
            }];
            PFFile *coverFile = [object objectForKey:@"coverfile"];
            [coverFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:result];
                    self.coverImage.image = image;
                    
                }
            }];
            
        }];
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)logOut:(id)sender {
    //[PFUser logOut];
    [self performSegueWithIdentifier:@"editProfile" sender:self];
}


#pragma social media outlets

- (IBAction)fbProfile:(id)sender {
    
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            NSMutableString *fbProfile = [NSMutableString stringWithString:@"fb://profile/"];
            [fbProfile appendString:facebookID];
            NSURL *profileURL = [[NSURL alloc] initWithString:fbProfile];
            [[UIApplication sharedApplication] openURL: profileURL];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Please connect your Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
        }
    }];
    
}

- (IBAction)twitterProfile:(id)sender {
    
    PFQuery *twitterQuery = [PFUser query];
    [twitterQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        self.twitterProfile = object[@"twitter"];
        
        if (![self.twitterProfile isEqualToString:@""]) {
            NSMutableString *twitterUsername = [NSMutableString stringWithString:@"twitter://user?screen_name="];
            [twitterUsername appendString:self.twitterProfile];
            NSURL *twitterURL = [[NSURL alloc] initWithString:twitterUsername];
            [[UIApplication sharedApplication] openURL: twitterURL];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Please connect your Twitter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
        }}];
}

- (IBAction)instagramProfile:(id)sender {
    
    PFQuery *instaQuery = [PFUser query];
    [instaQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        
        self.igProfile = object[@"instagram"];
        if (![self.igProfile isEqualToString:@""]) {
            NSMutableString *igUsername = [NSMutableString stringWithString:@"instagram://user?username="];
            [igUsername appendString:self.igProfile];
            NSURL *igURL = [[NSURL alloc] initWithString:igUsername];
            [[UIApplication sharedApplication] openURL:igURL];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Please connect your Instagram" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
        }
    }];
    
}

- (IBAction)refresh:(id)sender {
    
    [self viewWillAppear:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    if ([segue.identifier isEqualToString:@"editProfile"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed: YES];
    }
    
}

- (IBAction)profileEnlarge:(id)sender {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    view.backgroundColor = [UIColor blackColor];
    view.tag = 5;
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    UIImage *profileImage = [[UIImage alloc] init];
    [undoButton addTarget:self action:@selector(desizeImage:) forControlEvents:UIControlEventTouchUpInside];
    profileImage = self.profileImage.image;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:profileImage];
    
    if ((int)[[UIScreen mainScreen] bounds].size.height == 568){
        imageView.frame = CGRectMake(0, 128, 320, 320);
    }
    else{
        imageView.frame = CGRectMake(0, 85, 320, 320);
    }
    self.tabBarController.tabBar.hidden = YES;
    
    [view addSubview:undoButton];
    [view addSubview:imageView];
    [self.navigationController.view addSubview:view];
    self.navigationItem.hidesBackButton = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

-(IBAction)desizeImage:(id)sender{
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.hidesBackButton = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    for (UIView *subview in [self.navigationController.view subviews]) {
        if (subview.tag == 5)
        {
            
            [subview removeFromSuperview];
        }
    }
    
}


@end
