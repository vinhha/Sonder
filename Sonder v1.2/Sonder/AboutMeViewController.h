//
//  AboutMeViewController.h
//  Sonder
//
//  Created by vinh ha on 7/6/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AboutMeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *aboutMeText;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;

- (void)textInputChanged:(NSNotification *)note;

- (void)updateCharacterCount:(UITextView *)aTextView;

- (IBAction)continue:(id)sender;

@end
