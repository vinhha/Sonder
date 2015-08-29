//
//  FeedbackViewController.m
//  Sonder
//
//  Created by vinh ha on 8/21/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "FeedbackViewController.h"
#import <Parse/Parse.h>

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.feebackText becomeFirstResponder];
    
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

- (IBAction)sendFeedback:(id)sender {
    
    NSString *feedback = [self.feebackText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([feedback length] != 0) {
        
        PFObject *criticism = [PFObject objectWithClassName:@"Feedback"];
        [criticism setObject:self.feebackText.text forKey:@"feedback"];
        [criticism setObject:[[PFUser currentUser] objectId] forKey:@"sender"];
        
        
        [criticism saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Dismiss the NewPostViewController and show the BlogTableViewController
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter feedback." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
    }
    
}



@end
