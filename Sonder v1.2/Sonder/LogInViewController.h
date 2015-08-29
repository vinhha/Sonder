//
//  LogInViewController.h
//  Sonder
//
//  Created by vinh ha on 1/3/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)login:(id)sender;

@end
