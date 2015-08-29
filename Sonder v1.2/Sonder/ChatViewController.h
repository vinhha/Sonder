//
//  ChatViewController.h
//  Sonder
//
//  Created by vinh ha on 3/1/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MessageCell.h"

@interface ChatViewController : UIViewController < UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITextField *inputField;
    UITableView *messageTable;
}

@property (strong, nonatomic) IBOutlet UILabel *backWhite;

@property(nonatomic) NSInteger numberOfLines;
@property(nonatomic) UILineBreakMode lineBreakMode;

@property (strong, nonatomic) IBOutlet UITableView *messageTable;
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) PFObject *messageObject;
@property (strong, nonatomic) NSString *cellText;

- (IBAction)send:(id)sender;
- (IBAction)delete:(id)sender;


-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;


@end
