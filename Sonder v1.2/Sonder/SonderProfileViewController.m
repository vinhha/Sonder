//
//  SonderProfileViewController.m
//  Sonder
//
//  Created by vinh ha on 1/31/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "SonderProfileViewController.h"

@interface SonderProfileViewController ()

@end

@implementation SonderProfileViewController


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
    NSLog(@"%@", self.userInfo);
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:21.0]};
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = NO;
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(320, 569);
    [self.view addSubview:scrollView];
    
    self.navigationController.navigationBar.hidden = NO;

    self.profileImage.layer.cornerRadius = 60;
    self.profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileImage.layer.borderWidth = 2;
    self.profileImage.layer.masksToBounds = YES;
    
    self.aboutMeLabel.layer.borderColor = [[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.7]CGColor];
    self.aboutMeLabel.layer.borderWidth =1;
    
    self.contentView.frame = CGRectMake(-180, -255, 320, 568);
    self.compButton.frame = CGRectMake(20, 280, 280, 30);
    self.compButton.layer.cornerRadius = 5;
    self.compButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.compButton.layer.borderWidth =1;
    self.igButton.frame = CGRectMake(250, 485, 60, 60);
    self.twitterButton.frame = CGRectMake(143, 485, 60, 60);
    self.fbButton.frame = CGRectMake(35, 485, 60, 60);
    self.pictureButton.frame = CGRectMake(15, 60, 120, 120);
    
    [self.contentView addSubview:self.compliments];
    [self.contentView addSubview:self.bioLabel];
    
    [scrollView addSubview:self.contentView];
    [scrollView addSubview:self.compButton];
    [scrollView addSubview:self.igButton];
    [scrollView addSubview:self.twitterButton];
    [scrollView addSubview:self.fbButton];
    [scrollView addSubview:self.pictureButton];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	// Do any additional setup after loading the view.
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    self.title = [self.userInfo objectForKey:@"name"];
    
    self.birthdate = [self.userInfo objectForKey:@"birthday"];
    
    
    
    if ([[self.userInfo objectForKey:@"twitter"] isEqualToString:@""] || [self.userInfo objectForKey:@"twitter"] == nil) {
        self.twitterButton.alpha = 0.7;
        [self.twitterButton setEnabled:NO];
    }
    if ([self.userInfo objectForKey:@"facebook"] == nil) {
        self.fbButton.alpha = 0.7;
        [self.fbButton setEnabled:NO];
    }
    if ([[self.userInfo objectForKey:@"instagram"] isEqualToString:@""] || [self.userInfo objectForKey:@"instagram"] == nil) {
        self.igButton.alpha = 0.7;
        [self.igButton setEnabled:NO];
    }
    
    self.allCompliments = [NSMutableArray arrayWithArray:[self.userInfo objectForKey:@"profileCompliments"]];
    
    if ([[self.userInfo objectForKey:@"profileCompliments"] containsObject:[[PFUser currentUser] objectId]]) {
        [self.compButton setEnabled:NO];
        [self.compButton setTitle:@"             COMPLIMENTED             " forState:UIControlStateNormal];

    }
    
    self.aboutMeLabel.text = [self.userInfo objectForKey:@"AboutMe"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthday = [dateFormat dateFromString:self.birthdate];
    NSLog(@"%@", birthday);
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger number = [ageComponents year];
    NSNumber *age = [NSNumber numberWithInteger: number];
    
    self.age = [age stringValue];
    
    if ([self.userInfo objectForKey:@"school"] != nil && [self.userInfo objectForKey:@"birthday"] != nil){
    self.schoolAndAge.text = [[NSArray arrayWithObjects:[self.userInfo objectForKey:@"school"], self.age, nil] componentsJoinedByString:@", "];
    }
    else {
        if ([self.userInfo objectForKey:@"school"] == nil && [self.userInfo objectForKey:@"birthday"] != nil) {
            self.schoolAndAge.text = self.age;
        }
        else {
            if ([self.userInfo objectForKey:@"school"] != nil && [self.userInfo objectForKey:@"birthday"] == nil) {
                self.schoolAndAge.text = [self.userInfo objectForKey:@"school"];
            }
            else {
                if ([self.userInfo objectForKey:@"school"] == nil && [self.userInfo objectForKey:@"birthday"] == nil) {
                    self.schoolAndAge.text = @"Sonder";
                }
            }
        }
    }
    self.compliments.text = [[self.userInfo objectForKey:@"complimentsValue"] stringValue];
    self.thoughtsTotal.text = [[self.userInfo objectForKey:@"thoughtTotal"] stringValue];
    self.profileTotal.text = [[self.userInfo objectForKey:@"profileTotal"] stringValue];
    self.statusLabel.text = [self.userInfo objectForKey: @"relationship"];
    
    self.bioLabel.text = [self.userInfo objectForKey:@"bio"];
    PFFile *imageFile = [self.userInfo objectForKey:@"file"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImage.image = image;
        }
    }];
    PFFile *coverFile = [self.userInfo objectForKey:@"coverfile"];
    [coverFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            self.coverImage.image = image;
        }
    }];
    
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma social media outlets


- (IBAction)instagramProfile:(id)sender {
    
    if (![[self.userInfo objectForKey:@"instagram"] isEqualToString:@""]) {
    NSMutableString *igUsername = [NSMutableString stringWithString:@"instagram://user?username="];
    [igUsername appendString:[self.userInfo objectForKey:@"instagram"]];
    NSURL *igURL = [[NSURL alloc] initWithString:igUsername];
    [[UIApplication sharedApplication] openURL:igURL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Unfortunately this user is not connected to Instagram." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (IBAction)twitterProfile:(id)sender {
    if (![[self.userInfo objectForKey:@"twitter"] isEqualToString:@""]) {
    NSMutableString *twitterUsername = [NSMutableString stringWithString:@"twitter://user?screen_name="];
    [twitterUsername appendString:[self.userInfo objectForKey:@"twitter"]];
    NSURL *twitterURL = [[NSURL alloc] initWithString:twitterUsername];
    [[UIApplication sharedApplication] openURL: twitterURL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Unfortunately this user is not connected to Twitter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)complimentButton:(id)sender {
    
    if ([self.userInfo objectId] != nil) {
        
        NSString* value = [[self.userInfo objectForKey:@"complimentsValue"] stringValue];
        NSString* value1 = [[self.userInfo objectForKey:@"profileTotal"] stringValue];
        int theIntValue = [value intValue];
        int profileIntValue = [value1 intValue];
        theIntValue = theIntValue + 1;
        profileIntValue = profileIntValue + 1;
        NSString *strFromInt = [NSString stringWithFormat:@"%d",theIntValue];
        NSString *strFromInt1 = [NSString stringWithFormat:@"%d", profileIntValue];
        self.compliments.text = strFromInt;
        self.profileTotal.text = strFromInt1;
        
        [self.allCompliments addObject:[[PFUser currentUser] objectId]];
        
    [PFCloud callFunctionInBackground:@"complimentCounter" withParameters:@{ @"userId": [self.userInfo objectId], @"increment": @1, @"tag": @0, @"compliment": self.allCompliments} block:^(id success, NSError *error) {
        
        if (!error) {
            // Incremented
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                message:@"Please try again."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
    self.compButton.enabled = NO;
    [self.compButton setTitle:@"             COMPLIMENTED             " forState:UIControlStateNormal];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                message:@"Please go back, and try again."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)facebookProfile:(id)sender {
    
    if ([self.userInfo objectForKey:@"facebook"] != nil) {
        NSMutableString *facebookProfile = [NSMutableString stringWithString:@"fb://profile/"];
        [facebookProfile appendString:[self.userInfo objectForKey:@"facebook"]];
        NSURL *facebookURL = [[NSURL alloc] initWithString:facebookProfile];
        [[UIApplication sharedApplication] openURL: facebookURL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Unfortunately this user is not connected to Facebook." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
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

- (IBAction)flagUser:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello." message:@"Would you like to report this user for misuse?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
    [alertView addButtonWithTitle:@"Yes"];
    [alertView show];

    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        PFObject *flag = [PFObject objectWithClassName:@"FlaggedUser"];
        [flag setObject:[self.userInfo objectForKey:@"name"] forKey:@"Name"];
        [flag setObject:self.userInfo.objectId forKey:@"UserID"];
        [flag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Dismiss the NewPostViewController and show the BlogTableViewController
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];

    }
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
