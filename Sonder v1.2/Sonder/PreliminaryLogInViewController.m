//
//  PreliminaryLoginViewController.m
//  Sonder
//
//  Created by vinh ha on 7/27/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "PreliminaryLogInViewController.h"
#import <Parse/Parse.h>
#import "TSAAppDelegate.h"
#import "BuildProfileViewController.h"

@interface PreliminaryLogInViewController ()

@end

@implementation PreliminaryLogInViewController

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
    
    
    // Do any additional setup after loading the view.
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    [sender setEnabled:NO];
    
    if ([identifier isEqualToString:@"SignUp"]) {
        
        self.prelimTag = [NSNumber numberWithInt:0];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Welcome." message:@"Would you like to register with Facebook?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
        [sender setEnabled:YES];
        [alertView addButtonWithTitle:@"Yes"];
        [alertView show];

    }
    else if ([identifier isEqualToString:@"LogIn"]) {
        
        self.prelimTag = [NSNumber numberWithInt:1];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Welcome." message:@"Would you like to log in with Facebook?" delegate:self cancelButtonTitle:@"NO." otherButtonTitles:nil];
        [sender setEnabled:YES];
        [alertView addButtonWithTitle:@"YES."];
        [alertView show];

    }
    
    
    return NO;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        if (self.prelimTag == [NSNumber numberWithInt:0]) {
            [self performSegueWithIdentifier:@"SignUp" sender:self];
        }
        if (self.prelimTag == [NSNumber numberWithInt:1]) {
            [self performSegueWithIdentifier:@"LogIn" sender:self];
        }
    }
    if (buttonIndex == 1) {
        if (self.prelimTag == [NSNumber numberWithInt:0]) {
            
            NSArray *permissions = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

            [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
                if (!user) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else if (user.isNew) {
                    if (!error) {
                        FBRequest *request = [FBRequest requestForMe];
                        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                            if (!error) {
                                // result is a dictionary with the user's Facebook data
                                NSDictionary *userData = (NSDictionary *)result;
                                
                                self.facebookID = userData[@"id"];
                                self.name = userData[@"name"];
                                self.gender = userData[@"gender"];
                                self.birthday = userData[@"birthday"];
                                self.userEmail = userData[@"email"];
                                self.hometown = userData[@"hometown"];
                                self.signUpTag = [NSNumber numberWithInt:1];
                                
                                [self performSegueWithIdentifier:@"facebookSignUp" sender:self];
                            }
                        }];
                    }
                    NSLog(@"User signed up and logged in through Facebook!");
                } else {
                    NSLog(@"User logged in through Facebook!");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
        if (self.prelimTag == [NSNumber numberWithInt:1]) {
            
            NSArray *permissions = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

            [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
                if (!user) {
                    NSString *errorMessage = nil;
                    if (!error) {
                        NSLog(@"Uh oh. The user cancelled the Facebook login.");
                        errorMessage = @"Uh oh. The user cancelled the Facebook login.";
                    } else {
                        NSLog(@"Uh oh. An error occurred: %@", error);
                        errorMessage = [error localizedDescription];
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                                    message:errorMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Dismiss", nil];
                    [alert show];
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else if (user.isNew) {
                    if (!error) {
                        FBRequest *request = [FBRequest requestForMe];
                        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                            if (!error) {
                                // result is a dictionary with the user's Facebook data
                                NSDictionary *userData = (NSDictionary *)result;
                                
                                self.facebookID = userData[@"id"];
                                self.name = userData[@"name"];
                                self.gender = userData[@"gender"];
                                self.birthday = userData[@"birthday"];
                                self.userEmail = userData[@"email"];
                                self.hometown = userData[@"hometown"];
                                self.signUpTag = [NSNumber numberWithInt:1];
                                
                                [self performSegueWithIdentifier:@"facebookSignUp" sender:self];
                            }
                        }];
                    }

                    NSLog(@"User signed up and logged in through Facebook!");
                    [self performSegueWithIdentifier:@"facebookSignUp" sender:self];
                } else {
                    NSLog(@"User logged in through Facebook!");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"facebookSignUp"]) {
        
        NSLog(@"facebookSignUp segue");
        
        BuildProfileViewController *facebookSignUp = [segue destinationViewController];
        
        facebookSignUp.facebookID = self.facebookID;
        facebookSignUp.name = self.name;
        facebookSignUp.gender = self.gender;
        facebookSignUp.birthday = self.birthday;
        facebookSignUp.userEmail = self.userEmail;
        facebookSignUp.signUpTag = self.signUpTag;

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
    


@end
