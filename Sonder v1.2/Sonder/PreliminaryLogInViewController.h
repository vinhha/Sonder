//
//  PreliminaryLoginViewController.h
//  Sonder
//
//  Created by vinh ha on 7/27/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreliminaryLogInViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *logIn;
@property (strong, nonatomic) IBOutlet UIButton *signUp;
@property (strong, nonatomic) NSNumber *prelimTag;

@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *hometown;

@property (strong, nonatomic) NSNumber *signUpTag;


@end
