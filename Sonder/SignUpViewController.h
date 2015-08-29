//
//  SignUpViewController.h
//  Sonder
//
//  Created by vinh ha on 1/3/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *signUp;
@property (strong, nonatomic) NSString *gender; 
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *passwordCheck;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegmenter;
@property (strong, nonatomic) IBOutlet UITextField *birthday;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSNumber *tag;
@property BOOL success;

- (IBAction)signUp:(id)sender;

@end
