//
//  ReplyViewController.m
//  Sonder
//
//  Created by vinh ha on 2/27/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "ReplyViewController.h"

@interface ReplyViewController ()

@end

@implementation ReplyViewController

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
    
    [self.replyField becomeFirstResponder];
    
    self.characterCount = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 154.0f, 21.0f)];
	self.characterCount.backgroundColor = [UIColor clearColor];
	self.characterCount.textColor = [UIColor lightGrayColor];
	self.characterCount.text = @"0/140";
    
	[self.replyField setInputAccessoryView:self.characterCount];
    self.navigationController.navigationBar.translucent = NO;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:self.replyField];
	[self updateCharacterCount:self.replyField];

	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    NSLog(@"%@", self.userInfo);
    
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:21.0]};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelReply:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)send:(id)sender {
    
    NSString *message = self.replyField.text;
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    NSMutableArray *reciever = [[NSMutableArray alloc] init];
    NSMutableArray *people = [[NSMutableArray alloc] init];
    [reciever addObject:[[PFUser currentUser] objectId]];
    
    [people addObject:[[PFUser currentUser] objectId]];
    [people addObject:[self.userInfo objectId]];
    
    [messages addObject:message];
    NSString *recipient = [self.userInfo objectId];
    
    if (![message isEqualToString:@""]){
        NSString *timeString =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        PFObject *convo = [PFObject objectWithClassName:@"Messages"];
        [convo setObject:[self.userInfo objectForKey:@"post"] forKey:@"original"];
        [convo setObject:messages forKey:@"messages"];
        [convo setObject:reciever forKey:@"conversation"];
        [convo setObject:recipient forKey:@"recipient"];
        [convo setObject:people forKey:@"people"];
        [convo setObject:@"new" forKey:@"status"];
        [convo setObject:timeString forKey:@"convoTime"];
        [convo setObject:[[PFUser currentUser] objectId] forKey:@"sender"];
        
    
        [convo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Dismiss the NewPostViewController and show the BlogTableViewController
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        }];
    
        self.sendButton.enabled = NO;
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
    }
    
    [PFCloud callFunctionInBackground:@"Message" withParameters:@{ @"message": message, @"userId": recipient} block:^(id object, NSError *error) {
        if (!error) {
            NSLog(@"Message sent");
        }

    }];
    
    
    
}

- (void)updateCharacterCount:(UITextView *)aTextView {
	NSUInteger count = aTextView.text.length;
	self.characterCount.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)count];
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

@end
