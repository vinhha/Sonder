//
//  InboxViewController.m
//  Sonder
//
//  Created by vinh ha on 3/1/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "InboxViewController.h"
#import "ChatViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

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
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.navigationController.view addSubview:view];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:152/255.0f alpha:0.8];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self queryForTable];
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:21.0]};
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"_Messages";
        self.textKey = @"_message";
        self.pullToRefreshEnabled = YES;
    }
    
    return self;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    
    // This method is called before a PFQuery is fired to get more objects
}

- (PFQuery *) queryForTable {
    
    PFQuery *messages = [PFQuery queryWithClassName:@"Messages"];
    
    if ([self.objects count] == 0) {
        messages.cachePolicy = kPFCachePolicyCacheThenNetwork;
        NSLog(@"checked background");
    }
    

    //[messages whereKey:@"recipient" equalTo:[[PFUser currentUser] objectId]];
    [messages whereKey:@"people" equalTo:[[PFUser currentUser] objectId]];
    [messages orderByDescending:@"convoTime"];
    [messages includeKey:@"_conversation"];
    [messages includeKey:@"_original"];
    [messages includeKey:@"_messages"];
    [messages includeKey:@"_sender"];
    [messages includeKey:@"_status"];
    [messages includeKey:@"_convoTime"];
    
    return messages;
    
}

-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    NSLog(@"checking inbox");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    

    
    
        if (self.time.tag == 5)
        {
            for (UIView *subview in [cell.contentView subviews]) {
                [subview removeFromSuperview];
            }
        }
    
    
    NSArray *messages = [object objectForKey:@"messages"];
    NSString *originalText = [object objectForKey:@"original"];
    NSArray *sender = [object objectForKey:@"conversation"];
    NSString *lastSender = [sender lastObject];
     NSString *lastMessage = [messages lastObject];
    NSLog(@"lastSender = %@",lastSender);
    if (originalText.length >= 25) {
        originalText = [originalText substringToIndex:MIN(25, [originalText length])];
        originalText = [NSString stringWithFormat:@"%@...", originalText];
    }
    if (lastMessage.length >= 35)
    {
            lastMessage = [lastMessage substringToIndex:MIN(35, [lastMessage length])];
            lastMessage = [NSString stringWithFormat:@"%@...", lastMessage];
    }
    if ([messages count] != 0){
        cell.detailTextLabel.text = lastMessage;
        cell.textLabel.text = originalText;
    }
    
    if (![[[PFUser currentUser] objectId] isEqualToString: lastSender]){
        
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    imgView.image = [UIImage imageNamed:@"circle.png"];
    cell.imageView.image = imgView.image;
    }
    if ([[[PFUser currentUser] objectId] isEqualToString: lastSender]){
        
        cell.imageView.image = nil;
    }
                            
                                                                        
    
    if ([object objectForKey:@"status"] != nil){
//        if ([[object objectForKey:@"status"] isEqualToString:@"opened"]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
            };
    
    
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(240, 25, 50, 30)];
    
    self.time.textAlignment = NSTextAlignmentRight;
    self.time.textColor = [UIColor lightGrayColor];
    [self.time setFont:[UIFont systemFontOfSize:12]];
    
    
    
    [cell.contentView addSubview:self.time] ;
    
    self.time.tag = 5;
    
    
    NSString *nowDate =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *pastDate = [object objectForKey:@"convoTime"];
    int nowDatenum = [nowDate intValue];
    int pastDateNum = [pastDate intValue];
    
    int interval = nowDatenum - pastDateNum;
    
    
    
    float minutes = interval/60;
    float hours = minutes/60;
    float days = hours/24;
    float weeks = days/7;
    
    
    NSString *timeString;
    int count = 0;
    
    if (minutes < 1){
        timeString = @"<1m";
        
    }
    else if (hours < 1) {
        while (minutes >= 1){
            minutes --;
            count ++;
            timeString = [NSString stringWithFormat:@"%dm", count];
            
        }}
    else if (days < 1) {
        while (hours >= 1){
            hours --;
            count ++;
            timeString = [NSString stringWithFormat:@"%dh", count];
            
        }}
    else if (weeks < 1) {
        while (days >= 1){
            days --;
            count ++;
            timeString = [NSString stringWithFormat:@"%dd", count];
            
        }}
    else  {
        weeks --;
        count ++;
        timeString = [NSString stringWithFormat:@"%dw", count];
        
    }
    
    self.time.text = timeString;

    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFQuery *opened = [PFQuery queryWithClassName:@"Messages"];
    
    PFObject *message = [self.objects objectAtIndex:indexPath.row];
    
    [opened getObjectInBackgroundWithId:[message objectId] block:^(PFObject *object, NSError *error) {
       
        object[@"status"] = @"opened";
        [object saveInBackground];
    }];
    
}

- (void)refresh
{
    [self.refreshControl endRefreshing];
    
    NSLog(@"refreshed..");
    
    [self loadObjects];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"convoSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [segue.destinationViewController setHidesBottomBarWhenPushed: YES];

        ChatViewController *userProfile = [segue destinationViewController];
        userProfile.messageObject = object;
    }
}


@end
