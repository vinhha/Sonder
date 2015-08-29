//
//  EditGeneralInformationViewController.m
//  Sonder
//
//  Created by vinh ha on 9/6/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "EditGeneralInformationViewController.h"
#include <Parse/Parse.h>

@interface EditGeneralInformationViewController ()

@end

@implementation EditGeneralInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.birthday.delegate = self;
    
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        self.userGender = object[@"gender"];
        self.birthDate = object[@"birthday"];
        
        if(self.birthDate != nil){
            [self.birthday setText:self.birthDate];
        }
        
        if (![self.userGender isEqualToString:@"Private"] && self.userGender != nil) {
            if ([self.userGender isEqualToString:@"Female"]) {
                [self.gender setSelectedSegmentIndex:0];

            }
            else {
            [self.gender setSelectedSegmentIndex:1];
             }
        }
        else{
            self.gender.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        
    }];


    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) validateBirthday: (NSString *)birthdayStr {
    
    NSString *birthRegex = @"[0-9]+[0-9]+/[0-9]+[0-9]+/[0-9]+[0-9]+[0-9]+[0-9]";
    NSPredicate *birthdayTest = [NSPredicate predicateWithFormat:@"Self Matches %@", birthRegex];
    
    return [birthdayTest evaluateWithObject:birthdayStr];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.birthday resignFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (IBAction)finish:(id)sender {
    
    [sender setEnabled:NO];
    
    NSString *newGender = [[NSString alloc] init];

    switch (self.gender.selectedSegmentIndex) {
        case 0:
            newGender = [self.gender titleForSegmentAtIndex:self.gender.selectedSegmentIndex];
            break;
        case 1:
            newGender = [self.gender titleForSegmentAtIndex:self.gender.selectedSegmentIndex];
            break;
        default:
            break;
    }
    
    NSString *dayOfBirth = self.birthday.text;
    
    
    if(![self.userGender isEqualToString:@"Private"] || self.birthday.text.length != 0){
        if ((![dayOfBirth isEqualToString:self.birthDate] && dayOfBirth.length != 0) || (self.gender.selectedSegmentIndex != UISegmentedControlNoSegment && ![self.userGender isEqualToString:newGender])){
            
            if (![self validateBirthday:dayOfBirth] && self.birthday.text.length != 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you format your birthday    properly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [sender setEnabled:YES];
                [alertView show];
            }
            else{
                PFUser *userProfile = [PFUser currentUser];
                
                userProfile[@"gender"] = newGender;
                if (![dayOfBirth isEqualToString:self.birthDate]) {
                    userProfile[@"birthday"] = dayOfBirth;
                }
                
                [userProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [sender setEnabled:YES];
                        [alertView show];
                    }
                    else {
                        
                        //Sign up the user.
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                }];

            }
        }
        else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    
    }
    else {
        [sender setEnabled:YES];
    }

}




@end
