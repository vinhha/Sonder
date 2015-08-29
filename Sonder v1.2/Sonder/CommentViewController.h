//
//  CommentViewController.h
//  Sonder
//
//  Created by vinh ha on 9/15/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "commentTableViewCell.h"

@interface CommentViewController : UIViewController < UITextViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    UITextView *commentTextView;
    UITableView *commentTable;
}


@property (strong, nonatomic) IBOutlet UIView *createView;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) commentTableViewCell *cell;

@property (strong, nonatomic) NSNumber* x;


@property (strong, nonatomic) PFObject *thoughtObject;
@property (strong, nonatomic) PFObject *commentsObject;

@property (strong, nonatomic) IBOutlet UITableView *commentTable;

@property (strong, nonatomic) IBOutlet UIButton *send;
- (IBAction)send:(id)sender;

-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;

@end
