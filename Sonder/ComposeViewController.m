//
//  ComposeViewController.m
//  Sonder
//
//  Created by vinh ha on 2/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

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
//    [self performSegueWithIdentifier:@"Compose" sender:self];
    
    self.composeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.composeButton.layer.cornerRadius = 5;
    self.composeButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.composeButton.layer.borderWidth = 1;
    
    
    //NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.composeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-75.0f];
    
    [self.view addSubview:self.composeButton];
    //[self.view addConstraint:constraint];

	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"post"];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        if (object[@"post"] != nil){
            self.post = object[@"post"];
            self.postLabel.text = self.post;
            self.complimentsLabel.text = @"Compliments:";
            self.postTotal.text = [[object objectForKey:@"postValue"] stringValue];
//            self.timePost.text = [[NSArray arrayWithObjects:@"Created:", object[@"time"], nil] componentsJoinedByString:@" "];
            
            
            NSString *nowDate =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            
            
            NSString *pastDate = [object objectForKey:@"time"];
            int nowDatenum = [nowDate intValue];
            int pastDateNum = [pastDate intValue];
            
            int interval = nowDatenum - pastDateNum;
            
            
            
            float minutes = interval/60;
            float hours = minutes/60;
            float days = hours/24;
            float weeks = days/7;
            
            
            NSString *time;
            int count = 0;
            
            if (minutes < 1){
                time = @"<1m";
                
            }
            else if (hours < 1) {
                while (minutes >= 1){
                    minutes --;
                    count ++;
                    time = [NSString stringWithFormat:@"%dm", count];
                    
                }}
            else if (days < 1) {
                while (hours >= 1){
                    hours --;
                    count ++;
                    time = [NSString stringWithFormat:@"%dh", count];
                    
                }}
            else if (weeks < 1) {
                while (days >= 1){
                    days --;
                    count ++;
                    time = [NSString stringWithFormat:@"%dd", count];
                    
                }}
            else  {
                weeks --;
                count ++;
                time = [NSString stringWithFormat:@"%dw", count];
                
            }
            
            
            self.timePost.text = [[NSArray arrayWithObjects:@"Created:",time, @"ago", nil] componentsJoinedByString:@" "];
            
            
            }
    
        
            if ([self.post length] > 0 && [self.post length] < 50) {
                self.postLabel.font = [UIFont fontWithName:@"Avenir" size:26];
            }
        
        if ([self.post length] >= 50 && [self.post length] < 100) {
            self.postLabel.font = [UIFont fontWithName:@"Avenir" size:24];
        }
        
        if ([self.post length] >= 100 && [self.post length] < 150) {
            self.postLabel.font = [UIFont fontWithName:@"Avenir" size:22];
        }
        
        if ([self.post length] >= 150 && [self.post length] < 200) {
            self.postLabel.font = [UIFont fontWithName:@"Avenir" size:20];
        }
        if ([self.post length] >= 200 && [self.post length] < 250) {
            self.postLabel.font = [UIFont fontWithName:@"Avenir" size:19];
        }
        if ([self.post length] >= 250 && [self.post length] < 300) {
            self.postLabel.font = [UIFont fontWithName:@"Avenir" size:17];
        }
        if ([self.post length] >= 300 && [self.post length] <= 350) {
            self.postLabel.font = [UIFont fontWithName:@"Avenir" size:16];
        }
      
    }];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearPost:(id)sender {
    
    NSArray *empty = [[NSArray alloc] init];
    
    [[PFUser currentUser] removeObjectForKey:@"post"];
    [[PFUser currentUser] setValue:empty forKey:@"thoughtCompliments"];
    [[PFUser currentUser] saveInBackground];
    
    self.postLabel.text = @"What's on your mind?";
    self.postLabel.font = [UIFont fontWithName:@"Avenir" size:26];
    self.timePost.text = @"";
}
@end
