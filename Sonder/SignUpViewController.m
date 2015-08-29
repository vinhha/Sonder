//
//  SignUpViewController.m
//  Sonder
//
//  Created by vinh ha on 1/3/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.passwordCheck.delegate = self;
    self.birthday.delegate = self;
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
    self.userField.delegate = self;
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    self.signUp.translatesAutoresizingMaskIntoConstraints = NO;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.gender = @"Private";
    self.tag = [NSNumber numberWithInt:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.userField resignFirstResponder];
    [self.birthday resignFirstResponder];
    [self.passwordCheck resignFirstResponder];
}


- (BOOL) validateBirthday: (NSString *)birthdayStr {
    
    NSString *birthRegex = @"[0-9]+[0-9]+/[0-9]+[0-9]+/[0-9]+[0-9]+[0-9]+[0-9]";
    NSPredicate *birthdayTest = [NSPredicate predicateWithFormat:@"Self Matches %@", birthRegex];

    return [birthdayTest evaluateWithObject:birthdayStr];
}


- (IBAction)signUp:(id)sender {
    
    [sender setEnabled:NO];

    NSString *firstname = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastname = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *username = [self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *passwordVerify = [self.passwordCheck.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *emailArray = [email componentsSeparatedByString:@"."];
    
    NSArray *reverseArray = [[emailArray reverseObjectEnumerator] allObjects];
    
    NSString *demoRegex = [reverseArray objectAtIndex: 0];
    
    NSLog(@"%@", demoRegex);
    
    switch (self.genderSegmenter.selectedSegmentIndex) {
        case 0:
            self.gender = [self.genderSegmenter titleForSegmentAtIndex:self.genderSegmenter.selectedSegmentIndex];
            break;
        case 1:
            self.gender = [self.genderSegmenter titleForSegmentAtIndex:self.genderSegmenter.selectedSegmentIndex];
            break;
        default:
            break;
    }
    
    NSString *birthdate = @"";
    
    if (self.birthday.text.length > 0) {
       birthdate = [self.birthday.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    
    if ([firstname length] == 0 || [lastname length] == 0 || [username length] == 0 || [password length] == 0 || [email length] == 0 || [birthdate length] >= 11) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you fill out all of the information correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [sender setEnabled:YES];
        [alertView show];
        
    }
    
    else {

        
        self.name = [[NSArray arrayWithObjects:firstname, lastname, nil] componentsJoinedByString:@" "];
        
        if (![email isEqualToString:username]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure your emails match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [sender setEnabled:YES];

            [alertView show];
        }
        
        else {
                if(![password isEqualToString:passwordVerify]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure your passwords match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [sender setEnabled:YES];

                    [alertView show];
                }
                
                else {
                
                        if ([birthdate length] != 0 && ![self validateBirthday:birthdate]) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you format your birthday properly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [sender setEnabled:YES];
                            [alertView show];
                        }
                
                        else {
                            
                            if ((self.birthday.text.length == 0 || [self.gender isEqualToString:@"Private"]) && self.tag == [NSNumber numberWithInt:0]) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Note" message:@"It is recommended you provide your Gender and Birthday to fully experience Sonder." delegate:self cancelButtonTitle:@"Provide" otherButtonTitles:nil];
                                [sender setEnabled:YES];
                                [alertView addButtonWithTitle:@"Continue Anyways"];
                                [alertView show];
                            }
                            else {
                                self.tag = [NSNumber numberWithInt:1];
                            }
                            
                            if(self.tag == [NSNumber numberWithInt:1]) {
                                PFUser *newUser = [PFUser user];
                                newUser.username = username;
                                newUser.password = password;
                                newUser.email = email;
                                newUser[@"name"] = self.name;
                                newUser[@"gender"] = self.gender;
                                newUser[@"birthday"] = birthdate;
                                newUser[@"complimentsValue"] = [NSNumber numberWithInteger: 00];
                                newUser[@"postValue"] = [NSNumber numberWithInteger: 00];
                                newUser[@"thoughtTotal"] = [NSNumber numberWithInt: 00];
                                newUser[@"profileTotal"] = [NSNumber numberWithInt: 00];
                                [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                                    if (error) {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK"   otherButtonTitles:nil];
                                        [sender setEnabled:YES];
                                        self.tag = [NSNumber numberWithInt:0];
                                        [alertView show];
                                        _success = YES;
                                    } else {
                            //Sign up the user.
                                        [self performSegueWithIdentifier:@"showBuildProfile" sender:self];
                                    }
                                }];
                            }
                        }
                    }
                }
        }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.tag = [NSNumber numberWithInt:1];
        [self.signUp sendActionsForControlEvents:UIControlEventTouchUpInside];
        NSLog(@"here");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
        if ((int)[[UIScreen mainScreen] bounds].size.height == 568){
            if (textField == self.birthday) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationBeginsFromCurrentState:YES];
                self.birthday.frame = CGRectMake(self.birthday.frame.origin.x, (self.birthday.frame.origin.y - 25.0), self.birthday.frame.size.width, self.birthday.frame.size.height);
                [UIView commitAnimations];
            }
        }
        else{
    if (textField == self.passwordCheck) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.passwordCheck.frame = CGRectMake(self.passwordCheck.frame.origin.x, (self.passwordCheck.frame.origin.y - 38.0), self.passwordCheck.frame.size.width, self.passwordCheck.frame.size.height);
        [UIView commitAnimations];}
    if (textField == self.birthday) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.birthday.frame = CGRectMake(20, (self.birthday.frame.origin.y - 118.0), self.birthday.frame.size.width +79, self.birthday.frame.size.height);
        [UIView commitAnimations];
    }}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((int)[[UIScreen mainScreen] bounds].size.height == 568){ //iPhone 5
        
        if (textField == self.birthday) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.birthday.frame = CGRectMake(self.birthday.frame.origin.x, (self.birthday.frame.origin.y + 25.0), self.birthday.frame.size.width, self.birthday.frame.size.height);
            [UIView commitAnimations];
        }
        
    }
    else{
    
    if (textField == self.passwordCheck) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.passwordCheck.frame = CGRectMake(self.passwordCheck.frame.origin.x, (self.passwordCheck.frame.origin.y + 38.0), self.passwordCheck.frame.size.width, self.passwordCheck.frame.size.height);
        [UIView commitAnimations];}
    if (textField == self.birthday) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.birthday.frame = CGRectMake(93, (self.birthday.frame.origin.y + 118.0), self.birthday.frame.size.width -79, self.birthday.frame.size.height);
        [UIView commitAnimations];
    }
}
}





@end
