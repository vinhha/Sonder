//
//  ComposeModalViewController.h
//  Sonder
//
//  Created by vinh ha on 2/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ComposeModalViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *postField;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;

- (IBAction)cancelPost:(id)sender;
- (IBAction)post:(id)sender;
- (void)updateCharacterCount:(UITextView *)aTextView;

//- (BOOL)checkCharacterCount:(UITextView *)aTextView;

- (void)textInputChanged:(NSNotification *)note;


@end
