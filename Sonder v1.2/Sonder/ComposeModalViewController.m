//
//  ComposeModalViewController.m
//  Sonder
//
//  Created by vinh ha on 2/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "ComposeModalViewController.h"

@interface ComposeModalViewController ()

//-(BOOL) shouldEnablePostButton;

@end

@implementation ComposeModalViewController

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
    [self.postField becomeFirstResponder];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:21.0]};
    
    self.characterCount = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 154.0f, 21.0f)];
	self.characterCount.backgroundColor = [UIColor clearColor];
	self.characterCount.textColor = [UIColor lightGrayColor];
	self.characterCount.text = @"0/350";
    
	[self.postField setInputAccessoryView:self.characterCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:self.postField];
	[self updateCharacterCount:self.postField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation Bar Buttons

- (IBAction)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:YES  completion:nil];
}

- (IBAction)post:(id)sender {
    
    NSString *post = self.postField.text;
    
    NSString *timeStampString =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    if ([post length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You need to create a post." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([post length] > 350){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your post is too long." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        NSArray *empty = [[NSArray alloc] init];
        
        [[PFUser currentUser] setValue:empty forKey:@"thoughtCompliments"];
        [[PFUser currentUser] saveInBackground];
        
        [[PFUser currentUser] setValue:empty forKey:@"flaggedBy"];
        [[PFUser currentUser] saveInBackground];
        
        PFUser *userPost = [PFUser currentUser];
    
        userPost[@"post"] = post;
        userPost[@"postValue"] = [NSNumber numberWithInteger: 00];
        userPost[@"time"] = timeStampString;
        
        [userPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
            //Create post.
            }
        
         }];
        
//            NSString *timeStampString =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
//            //        NSTimeInterval _interval=[timeStampString doubleValue];
//            //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
//            //        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
//            //        [_formatter setDateFormat:@"MM-dd-yyyy' at' HH:mm"];
//            //        NSString *_date=[_formatter stringFromDate:date];
//            
//            PFUser *postTime = [PFUser currentUser];
//            //        postTime[@"time"] = _date;
//            postTime[@"time"] = timeStampString;
//           
//        [postTime saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alertView show];
//            }
//            else {
//                //Create post.
//            }
//
//        
//        
//        }];
    
        [self dismissViewControllerAnimated:YES  completion:nil];
    }
}

#pragma mark Check character count

- (void)updateCharacterCount:(UITextView *)aTextView {
	NSUInteger count = aTextView.text.length;
	self.characterCount.text = [NSString stringWithFormat:@"%lu/350", (unsigned long)count];
	if (count > 160 || count == 0) {
		self.characterCount.font = [UIFont boldSystemFontOfSize:self.characterCount.font.pointSize];
	} else {
		self.characterCount.font = [UIFont systemFontOfSize:self.characterCount.font.pointSize];
	}
}

- (void)textInputChanged:(NSNotification *)note {
    //Send notification
    UITextView *localTextView = [note object];
	[self updateCharacterCount:localTextView];
}
@end
