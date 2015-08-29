//
//  AboutMeViewController.m
//  Sonder
//
//  Created by vinh ha on 7/6/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "AboutMeViewController.h"
#import <Parse/Parse.h>

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

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
    // Do any additional setup after loading the view.
    
    self.characterCount = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 154.0f, 21.0f)];
	self.characterCount.backgroundColor = [UIColor clearColor];
	self.characterCount.textColor = [UIColor lightGrayColor];
	self.characterCount.text = @"  0/140";
    
	[self.aboutMeText setInputAccessoryView:self.characterCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:self.aboutMeText];
	[self updateCharacterCount:self.aboutMeText];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self.aboutMeText becomeFirstResponder];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)updateCharacterCount:(UITextView *)aTextView {
	NSUInteger count = aTextView.text.length;
	self.characterCount.text = [NSString stringWithFormat:@"  %lu/140", (unsigned long)count];
	if (count > 140 || count == 0) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)continue:(id)sender {
    
    NSString *aboutMe = self.aboutMeText.text;
    NSUInteger count = self.aboutMeText.text.length;
    
    if ([aboutMe length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You need to create a post." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if ([aboutMe length] > 140){
        NSString *lengthAlert = [NSString stringWithFormat:@"Your post is %lu/140.", (unsigned long)count];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:lengthAlert delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
        PFUser *userPost = [PFUser currentUser];
        
        userPost[@"AboutMe"] = aboutMe;
        
        [userPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            }
            else {
                //Create post.
            }
        }];
        
        [self performSegueWithIdentifier:@"showSocialMedia" sender:self];
    }
    
}
@end
