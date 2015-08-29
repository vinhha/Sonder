//
//  EditGeneralInformationViewController.h
//  Sonder
//
//  Created by vinh ha on 9/6/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditGeneralInformationViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *userGender;
@property (strong, nonatomic) NSString *birthDate;


@property (strong, nonatomic) IBOutlet UITextField *birthday;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gender;
- (IBAction)finish:(id)sender;


@end
