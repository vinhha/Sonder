//
//  ChatViewController.m
//  Sonder
//
//  Created by vinh ha on 3/1/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize messageTable;
@synthesize inputField;

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
    
    self.inputField.delegate = self;
    inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self registerForKeyboardNotifications];

	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{

    [self.messageTable reloadData];
    int lastRowNumber = [self.messageTable numberOfRowsInSection:0] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [self.messageTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.navigationController.navigationBar.hidden = NO;
    
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



- (IBAction)send:(id)sender {
    
    if ( self.sendButton.frame.origin.y  > 300)
    {
        [sender setTitle:@"Send" forState:UIControlStateNormal];
        [sender setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];

        [sender setEnabled:NO];
        
        NSString *input = self.inputField.text;
        NSMutableArray *convo = [[NSMutableArray alloc] initWithArray:[self.messageObject objectForKey:@"messages"]];
        NSMutableArray *people = [[NSMutableArray alloc] initWithArray:[self.messageObject objectForKey:@"conversation"]];
        [convo addObject:input];
        [people addObject:[[PFUser currentUser] objectId]];
        
        
        PFQuery *update = [PFQuery queryWithClassName:@"Messages"];
        
        [update getObjectInBackgroundWithId:[self.messageObject objectId] block:^(PFObject *object, NSError *error) {
            
            object[@"messages"] = convo;
            object[@"conversation"] = people;
            object[@"status"] = @"new";
            object[@"sender"] = [[PFUser currentUser] objectId];
            object[@"recipient"] = [self.messageObject objectForKey:@"sender"];
            NSString *timeString =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            object[@"convoTime"] = timeString;
            [object saveInBackground];
            
            [self.view endEditing:YES];
            self.inputField.text=@"";
            [self.view setNeedsDisplay];
            [self viewDidLoad];
            [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
            [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }];
        
        [PFCloud callFunctionInBackground:@"Message" withParameters:@{ @"message": input, @"userId": [self.messageObject objectForKey:@"sender"]} block:^(id object, NSError *error) {
            if (!error) {
                NSLog(@"Message sent");
            }
            
        }];
        

    }
    else{
    
    [sender setTitle:@"Send" forState:UIControlStateNormal];
    [sender setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [sender setEnabled:NO];
    
    [NSThread sleepForTimeInterval:0.4];
    
    [sender setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitle:@"Send" forState:UIControlStateNormal];
        
        NSString *input = self.inputField.text;
        NSMutableArray *convo = [[NSMutableArray alloc] initWithArray:[self.messageObject objectForKey:@"messages"]];
        NSMutableArray *people = [[NSMutableArray alloc] initWithArray:[self.messageObject objectForKey:@"conversation"]];
        [convo addObject:input];
        [people addObject:[[PFUser currentUser] objectId]];
        
        
        PFQuery *update = [PFQuery queryWithClassName:@"Messages"];
        
        [update getObjectInBackgroundWithId:[self.messageObject objectId] block:^(PFObject *object, NSError *error) {
            
            object[@"messages"] = convo;
            object[@"conversation"] = people;
            object[@"status"] = @"new";
            object[@"sender"] = [[PFUser currentUser] objectId];
            object[@"recipient"] = [self.messageObject objectForKey:@"sender"];
            NSString *timeString =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            object[@"convoTime"] = timeString;
            [object saveInBackground];
            
            [self.view endEditing:YES];
            self.inputField.text=@"";
            [self.view setNeedsDisplay];
            [self viewDidLoad];
            
        }];
        
        [PFCloud callFunctionInBackground:@"Message" withParameters:@{ @"message": input, @"userId": [self.messageObject objectForKey:@"sender"]} block:^(id object, NSError *error) {
            if (!error) {
                NSLog(@"Message sent");
            }
            
        }];

    }

}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *messages = [self.messageObject objectForKey:@"messages"];

    return [messages count];

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 200, 50)];
    UILabel *messageFrame = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 200, 50)];
    //MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MessageCell *cell = [[MessageCell alloc] init];
    
    NSArray *senders = [self.messageObject objectForKey:@"conversation"];
    NSArray *messages = [self.messageObject objectForKey:@"messages"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSLog(@"cell is nil");
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    CGSize labelSize = CGSizeMake(200.0, 28.0);
    
   // labelSize = [[messages objectAtIndex:indexPath.row] sizeWithFont: [UIFont systemFontOfSize: 17.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont systemFontOfSize:17.0] ;
    gettingSizeLabel.text = [messages objectAtIndex:indexPath.row];
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(200, 9999);
    
    labelSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    if ([[senders objectAtIndex:indexPath.row] isEqualToString:[[PFUser currentUser] objectId]]) {
        messageFrame.frame = CGRectMake(103, 12, 210, labelSize.height + 5);
        message.frame = CGRectMake(108, 12, 200, labelSize.height);
        messageFrame.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.0];
        message.textColor=[UIColor darkGrayColor];
        message.text = [messages objectAtIndex:indexPath.row];
        message.textAlignment = NSTextAlignmentLeft;
        messageFrame.text = @" ";
        message.numberOfLines=0;
        NSUInteger characterCount = [[messages objectAtIndex:indexPath.row] length];
        if (characterCount <= 28) {
            message.frame = CGRectMake(12, 12, 320,labelSize.height);
            float widthIs =[message.text boundingRectWithSize:message.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:17.0] } context:nil].size.width;
            message.frame = CGRectMake(300 - widthIs,12 , widthIs + 5, 30);
            messageFrame.frame = CGRectMake(295 - widthIs, 12, widthIs + 10, 30);
        }
        message.lineBreakMode = NSLineBreakByWordWrapping;
        messageFrame.layer.cornerRadius = 5;
        messageFrame.layer.borderColor = [[UIColor darkGrayColor]CGColor];
        messageFrame.layer.borderWidth = 1;
        [cell addSubview:message];
        [cell addSubview:messageFrame];
    }
    else {
        messageFrame.frame = CGRectMake(8, 12, 210, labelSize.height +5);
        messageFrame.text = @" ";
        message.frame = CGRectMake(12, 12, 200,labelSize.height);
        messageFrame.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.1];
        message.textColor=[UIColor blackColor];
        message.text = [messages objectAtIndex:indexPath.row];
        message.textAlignment = NSTextAlignmentLeft;
        message.numberOfLines=0;
        message.lineBreakMode= NSLineBreakByWordWrapping;
        messageFrame.layer.cornerRadius = 5;
        messageFrame.layer.borderColor = [[UIColor blackColor]CGColor];
        messageFrame.layer.borderWidth = 1;
        NSUInteger characterCount = [[messages objectAtIndex:indexPath.row] length];
        if (characterCount <= 28) {
            message.frame = CGRectMake(12, 12, 320,labelSize.height);
            float widthIs =[message.text boundingRectWithSize:message.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:17.0] } context:nil].size.width;
            message.frame = CGRectMake(12, 12, widthIs + 5, 30);
            messageFrame.frame = CGRectMake(8, 12, widthIs + 10, 30);
        }
        [cell addSubview:message];
        [cell addSubview:messageFrame];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *messages = [self.messageObject objectForKey:@"messages"];
    
    CGSize labelSize = CGSizeMake(200.0, 28.0);
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont systemFontOfSize:17.0] ;
    gettingSizeLabel.text = [messages objectAtIndex:indexPath.row];
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(200, 9999);
    
    labelSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    //labelSize = [[messages objectAtIndex:indexPath.row] sizeWithFont: [UIFont systemFontOfSize: 17.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
    NSUInteger characterCount = [[messages objectAtIndex:indexPath.row] length];
    if (characterCount <= 28) {
        labelSize = [gettingSizeLabel sizeThatFits:CGSizeMake(320.0, 30.0)];
        return labelSize.height + 25;
    }
    
    return 17 + labelSize.height;
    
}


#pragma Delete Button

- (IBAction)delete:(id)sender {
    
    [self.messageObject deleteInBackground];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
    
    
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
        if (textField == self.inputField) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.inputField.frame = CGRectMake(self.inputField.frame.origin.x, (self.inputField.frame.origin.y - 211.0), self.inputField.frame.size.width, self.inputField.frame.size.height);
            self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, (self.sendButton.frame.origin.y - 211.0), self.sendButton.frame.size.width, self.sendButton.frame.size.height);
            self.backWhite.frame = CGRectMake(self.backWhite.frame.origin.x,(self.backWhite.frame.origin.y - 231), self.backWhite.frame.size.width, self.backWhite.frame.size.height + 221.0);

            [UIView commitAnimations];
        }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
        
        if (textField == self.inputField) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.inputField.frame = CGRectMake(self.inputField.frame.origin.x, (self.inputField.frame.origin.y + 211.0), self.inputField.frame.size.width, self.inputField.frame.size.height);
            self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, (self.sendButton.frame.origin.y + 211.0), self.sendButton.frame.size.width, self.sendButton.frame.size.height);
            self.backWhite.frame = CGRectMake(self.backWhite.frame.origin.x,(self.backWhite.frame.origin.y + 231), self.backWhite.frame.size.width, self.backWhite.frame.size.height - 221);
            [UIView commitAnimations];
        }
    
}


@end
