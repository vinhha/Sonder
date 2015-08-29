//
//  ProfileViewController.h
//  Sonder
//
//  Created by vinh ha on 1/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *school;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) UIImage *imageData;
@property (strong, nonatomic) UIImage *coverData;
@property (strong, nonatomic) NSString *fbProfileID;
@property (strong, nonatomic) NSString *twitterProfile;
@property (strong, nonatomic) NSString *igProfile;
@property (strong, nonatomic) NSString *snapchatProfile;
@property (strong, nonatomic) NSNumber *compliments;
@property (strong, nonatomic) NSNumber *thoughts;
@property (strong, nonatomic) NSNumber *profile;

@property (strong, nonatomic) NSString *relationshipStatus;
@property (strong, nonatomic) NSString *birthdate;
@property (strong, nonatomic) NSString *aboutMe;


@property (strong, nonatomic) IBOutlet UILabel *schoolAndName;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UILabel *complimentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileTotal;
@property (strong, nonatomic) IBOutlet UILabel *thoughtsTotal;



//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (IBAction)logOut:(id)sender;
- (IBAction)fbProfile:(id)sender;
- (IBAction)twitterProfile:(id)sender;
- (IBAction)instagramProfile:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)profileEnlarge:(id)sender;



@end