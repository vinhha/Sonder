//
//  EditBioViewController.h
//  Sonder
//
//  Created by vinh ha on 7/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBioViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *aboutMeText;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;
@property (strong, nonatomic) NSString *aboutMe;


- (void)updateCharacterCount:(UITextView *)aTextView;
- (IBAction)updateBio:(id)sender;

@end
