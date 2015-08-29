//
//  EditSMViewController.m
//  Sonder
//
//  Created by vinh ha on 5/30/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "EditSMViewController.h"
#import <Parse/Parse.h>

@interface EditSMViewController ()

@end

@implementation EditSMViewController

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
    //[self.genderControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    self.twitter.delegate = self;
    self.instagram.delegate = self;

    self.facebookLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.facebookLabel.layer.cornerRadius = 5;
    self.facebookLabel.layer.borderColor = [[UIColor blackColor]CGColor];
    self.facebookLabel.layer.borderWidth = 1;

    
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        NSString *facebook = object[@"facebook"];
        self.twitter.text = object[@"twitter"];
        self.instagram.text = object[@"instagram"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)facebook:(id)sender {
    
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        NSDictionary *userData = (NSDictionary *)result;
                        PFUser *userProfile = [PFUser currentUser];
                        self.facebookId = userData[@"id"];
                        userProfile[@"facebook"] = self.facebookId;
                        [userProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (error) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alertView show];
                            }
                        }];
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

- (IBAction)finish:(id)sender {
    
    NSString *twitter  = self.twitter.text;
    NSString *instagram = self.instagram.text;
    
    PFUser *userProfile = [PFUser currentUser];
    
    if (![twitter isEqualToString:@""] && twitter != nil) {
    userProfile[@"twitter"] = twitter;
    }
    
    if (![instagram isEqualToString:@""] && instagram != nil) {
    userProfile[@"instagram"] = instagram;
    }
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.instagram resignFirstResponder];
    [self.twitter resignFirstResponder];
}
@end
