//
//  CommentViewController.m
//  Sonder
//
//  Created by vinh ha on 9/15/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize commentTable;


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.commentTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.commentTextView layer] setBorderWidth:1.0];
    [[self.commentTextView layer] setCornerRadius:7.0];
    
    self.commentTable.delegate = self;
    self.commentTable.dataSource = self;
    self.commentTextView.delegate = self;
    
    [self registerForKeyboardNotifications];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.createView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    self.createView.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];
    self.createView.layer.borderWidth = 1;
    self.commentTextView.backgroundColor = [UIColor whiteColor];
     [self.commentTable reloadData];
    
    self.x = [NSNumber numberWithInt:self.commentTextView.frame.size.height];
    
    
}

- (void) viewDidUnload {

    [super viewDidUnload];
    [self freeKeyboardNotifications];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"Hello");
    return 2;
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0)
    {
        return 1;
    }
    else{
        return [[self.commentsObject objectForKey:@"Comments" ] count];
    }
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NSLog(@"%@", self.commentsObject);
    
    if (indexPath.section == 0) {
    
        self.cell = [[commentTableViewCell alloc] init];
        self.cell.label.text = [self.thoughtObject objectForKey:@"post"];
        NSLog(@"%@", [self.thoughtObject objectForKey:@"post"]);
        
        CGSize postSize = CGSizeMake(260.0, 28.0);
        
        UILabel *postLabel = [[UILabel alloc] init];
        postLabel.font = [UIFont fontWithName:@"Avenir" size:16];
        postLabel.text = [self.thoughtObject objectForKey:@"post"];
        postLabel.numberOfLines = 0;
        postLabel.lineBreakMode = NSLineBreakByWordWrapping;
        postLabel.textAlignment = NSTextAlignmentCenter;
        CGSize maximumLabelSize = CGSizeMake(260, 9999);
        
        postSize = [postLabel sizeThatFits:maximumLabelSize];
        postLabel.frame = CGRectMake(30, 20, 260, postSize.height);
        
        [self.cell addSubview:postLabel];
        
        return self.cell;
    }
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:14];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if ([[self.commentsObject objectForKey:@"Comments" ] count] == 0) {
        cell.textLabel.text  = @"There are no comments on this post.";
    }
    NSLog(@"%i", indexPath.row);
    
   cell.textLabel.text = [[self.commentsObject objectForKey:@"Comments"] objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    CGSize labelSize = CGSizeMake(260.0, 28.0);
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    
    if (indexPath.section == 0) {
        gettingSizeLabel.font = [UIFont fontWithName:@"Avenir" size:16];
        gettingSizeLabel.text = [self.thoughtObject objectForKey:@"post"];
        CGSize maximumLabelSize = CGSizeMake(260, 9999);
        labelSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
        
        
        return 40 + labelSize.height;
    }
    else {
        gettingSizeLabel.font = [UIFont fontWithName:@"Avenir" size:14];
        gettingSizeLabel.text = [[self.commentsObject objectForKey:@"Comments"] objectAtIndex:indexPath.row];
        CGSize maximumLabelSize = CGSizeMake(300, 9999);
        labelSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
        
        
        return 20 + labelSize.height;
    }

}




- (IBAction)send:(id)sender {
    
    if (self.commentsObject != nil) {
        
        NSMutableArray *comments = [self.commentsObject objectForKey:@"Comments"];
        NSString *commentContent = [[NSString alloc] init];
        commentContent = self.commentTextView.text;
        [comments addObject:commentContent];
        PFQuery *update = [PFQuery queryWithClassName:@"Comments"];
        [update getObjectInBackgroundWithId:[self.commentsObject objectId] block:^(PFObject *object, NSError *error) {
            object[@"Comments"] = comments;
            [object saveInBackground];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:[self.thoughtObject objectId] forKey:@"channels"];
        [currentInstallation saveInBackground];

    }
    else{
        NSMutableArray *comments;
        NSString *commentContent = [[NSString alloc] init];
        commentContent = self.commentTextView.text;
        comments = [NSMutableArray arrayWithObject:commentContent];
        PFObject *comment = [PFObject objectWithClassName:@"Comments"];
        [comment setObject:[self.thoughtObject objectForKey:@"post"] forKey:@"Original"];
        [comment setObject:[self.thoughtObject objectId] forKey:@"OP"];
        [comment setObject:comments forKey:@"Comments"];
        
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Dismiss the NewPostViewController and show the BlogTableViewController
                
//                [PFCloud callFunctionInBackground:@"Message" withParameters:@{ @"message": message, @"userId": recipient} block:^(id object, NSError *error) {
//                    if (!error) {
//                        NSLog(@"Message sent");
//                    }
//                    
//                }];
                
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation addUniqueObject:[self.thoughtObject objectId] forKey:@"channels"];
                [currentInstallation saveInBackground];
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
        }];
    }

    self.send.enabled = NO;
}

#pragma Keyboard Methods


-(void) registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) freeKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void) keyboardWasShown:(NSNotification*)aNotification {
    
    NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    //    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    //
    [UIView commitAnimations];
    
}
-(void) keyboardWillHide:(NSNotification*)aNotification {
    
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    //    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    
    return NO;
}


-(void) textViewDidBeginEditing:(UITextView *)textView {

    if (textView == self.commentTextView) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        CGRect frame = self.commentTextView.frame;
        frame.size.height = self.commentTextView.contentSize.height;
        self.commentTextView.frame = frame;
        
        self.commentTextView.frame = CGRectMake(self.commentTextView.frame.origin.x, (self.commentTextView.frame.origin.y - 215.0), self.commentTextView.frame.size.width, self.commentTextView.frame.size.height);
        self.send.frame = CGRectMake(self.send.frame.origin.x, (self.send.frame.origin.y - 215.0), self.send.frame.size.width, self.send.frame.size.height);
        self.createView.frame = CGRectMake(self.createView.frame.origin.x,(self.createView.frame.origin.y - 220), self.createView.frame.size.width, self.createView.frame.size.height + 216);
        
        [UIView commitAnimations];
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView {

    
    if (textView == self.commentTextView) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.commentTextView.frame = CGRectMake(self.commentTextView.frame.origin.x, (self.commentTextView.frame.origin.y + 215.0), self.commentTextView.frame.size.width, self.commentTextView.frame.size.height);
        self.send.frame = CGRectMake(self.send.frame.origin.x, (self.send.frame.origin.y + 215.0), self.send.frame.size.width, self.send.frame.size.height);
        self.createView.frame = CGRectMake(self.createView.frame.origin.x,[[UIScreen mainScreen] bounds].size.height - 115, self.createView.frame.size.width, 53);

        [UIView commitAnimations];
    }
    
}

-(void) textViewDidChange:(UITextView *)textView {
    
    

    
    CGRect frame = self.commentTextView.frame;
    frame.size.height = self.commentTextView.contentSize.height;
    self.commentTextView.frame = frame;
    
    if ([self.x floatValue] < self.commentTextView.frame.size.height) {
    
        float diff = (self.commentTextView.frame.size.height - [self.x floatValue]);

        CGRect r = self.createView.frame;
        r.size.height += diff;
        r.origin.y -= diff;
        self.createView.frame = r;
        
        self.x = [NSNumber numberWithFloat: self.commentTextView.frame.size.height];
    }
    
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

@end
