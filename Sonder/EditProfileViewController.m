//
//  EditProfileViewController.m
//  Sonder
//
//  Created by vinh ha on 4/18/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "EditProfileViewController.h"


@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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
    
//    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height)];
//    scrollView.scrollEnabled = YES;
//    scrollView.pagingEnabled = NO;
//    scrollView.delaysContentTouches = NO;
//    scrollView.canCancelContentTouches = NO;
//    scrollView.showsVerticalScrollIndicator = YES;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.contentSize = CGSizeMake(320, 568);
//    [self.view addSubview:scrollView];
//    
//    self.logOutButton.frame = CGRectMake(-20, 502, 320, 340);
//    self.EditProfileButton.frame = CGRectMake(0, 117, 320, 74);
//    self.termsAndConditionsButton.frame = CGRectMake(0, 329, 320, 74);
//    self.editSocialMediaButton.frame = CGRectMake(0, 257, 320, 74);
//    self.updateBio.frame = CGRectMake(0, 50, 320, 74);
//    self.editInfo.frame = CGRectMake(0, 185, 320, 74);
//    
//    [scrollView addSubview:self.logOutButton];
//    [scrollView addSubview:self.EditProfileButton];
//    [scrollView addSubview:self.termsAndConditionsButton];
//    [scrollView addSubview:self.editSocialMediaButton];
//    [scrollView addSubview:self.updateBio];
//    [scrollView addSubview:self.editInfo];

    

    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationItem.title = @"";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logOut:(id)sender {
    
    [sender setEnabled:NO];
    self.myLocation = [PFGeoPoint geoPointWithLatitude:0.0 longitude:0.0];
    self.currentUser = [PFUser currentUser];
    [self.currentUser setObject:self.myLocation forKey:@"location"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Got Location");
            [PFUser logOut];
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }
        else{
            [sender setEnabled:YES];
        }
    }];
    
}





@end
