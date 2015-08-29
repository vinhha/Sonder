//
//  ReplyViewController.h
//  Sonder
//
//  Created by vinh ha on 2/27/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ReplyViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSMutableString *user;
@property (strong, nonatomic) PFObject *userInfo;

@property (strong, nonatomic) IBOutlet UITextView *replyField;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;


- (IBAction)cancelReply:(id)sender;
- (IBAction)send:(id)sender;

- (void)updateCharacterCount:(UITextView *)aTextView;
- (void)textInputChanged:(NSNotification *)note;


@end
