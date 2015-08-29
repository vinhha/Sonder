//
//  SonderProfileViewController.h
//  Sonder
//
//  Created by vinh ha on 1/31/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SonderProfileViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (strong, nonatomic) NSMutableString *user;
@property (strong, nonatomic) PFObject *userInfo;

@property (strong, nonatomic) NSString *birthdate;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *complimentsString;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *schoolAndAge;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *compliments;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileTotal;
@property (strong, nonatomic) IBOutlet UILabel *thoughtsTotal;
@property (strong, nonatomic) NSMutableArray *allCompliments;
@property (strong, nonatomic) NSArray *userCompliments;


- (IBAction)instagramProfile:(id)sender;
- (IBAction)twitterProfile:(id)sender;
- (IBAction)complimentButton:(id)sender;
- (IBAction)facebookProfile:(id)sender;
- (IBAction)profileEnlarge:(id)sender;
- (IBAction)flagUser:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *compButton;
@property (strong, nonatomic) IBOutlet UIButton *igButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *pictureButton;


@end
