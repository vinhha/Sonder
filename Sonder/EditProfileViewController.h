//
//  EditProfileViewController.h
//  Sonder
//
//  Created by vinh ha on 4/18/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditProfileViewController : UIViewController <UIScrollViewDelegate>



@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) PFGeoPoint *myLocation;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) IBOutlet UIButton *EditProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *termsAndConditionsButton;
@property (strong, nonatomic) IBOutlet UIButton *editSocialMediaButton;
@property (strong, nonatomic) IBOutlet UIButton *updateBio;
@property (strong, nonatomic) IBOutlet UIButton *editInfo;

- (IBAction)logOut:(id)sender;

@end
