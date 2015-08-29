//
//  PostsViewController.m
//  Sonder
//
//  Created by vinh ha on 2/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "PostsViewController.h"
#import "TSAAppDelegate.h"
#import "PostCell.h"
#import "ReplyViewController.h"
#import "UIViewController+ScrollingNavbar.h"


@interface PostsViewController ()

@end

@implementation PostsViewController


- (id) initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"_User";
        self.textKey = @"_post";
        self.pullToRefreshEnabled = YES;
    }
    
    return self;
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotLocation" object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotLocation:) name:@"gotLocation" object:nil];
    
    self.navigationController.navigationBar.translucent = NO;
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        NSLog(@"view did load");
    } else {
        [self performSegueWithIdentifier:@"showLogIn" sender:self];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:152/255.0f alpha:0.8];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    
    [[self.tabBarController tabBar] setTintColor:[UIColor blackColor]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:21.0]};

    self.objectsPerPage = 50;
    
    self.tag1 = [NSNumber numberWithInt:0];
    self.countTag = [NSNumber numberWithInt:0];
    
    [self followScrollView:self.tableView];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:191.0/255.0f blue:143.0/255.0f alpha:0.25];
    
    PFUser *currentUser = [PFUser currentUser];
    
    self.tagEmpty = [NSNumber numberWithInt:0];
    
    if (currentUser) {
        NSLog(@"view will appear");
        
        [self loadObjects];
        [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
        
        
    } else {
        [self performSegueWithIdentifier:@"showLogIn" sender:self];
    }
    
    self.tag = [NSNumber numberWithInt:0];
    for (UIView *subview in [self.navigationController.view subviews]) {
        if (subview.tag == 5)
        {
            
            [subview removeFromSuperview];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    NSLog(@"view did appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    self.counter2 = [NSNumber numberWithInt:0];
    
    if (self.entry != nil) {
        [self.entry removeAllObjects];
    }
    if ( [self.objects count] == 0) {
        self.tagEmpty = [NSNumber numberWithInt:1];
        [self loadObjects];
    }
    NSLog(@"Count: %lu", (unsigned long)[self.objects count]);
    
    if (self.countTag == [NSNumber numberWithInt:1]) {
        if (self.count < [NSNumber numberWithInt:[self.objects count]]) {
            self.countTag = [NSNumber numberWithInt:0];
        }
    }
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
}

- (void)objectsWillLoad {
    
    [super objectsWillLoad];
    
    self.counter2 = [NSNumber numberWithInt:0];
    
    [self.lockedCompliments removeAllObjects];
    [self.flaggedPosts removeAllObjects];
    
    NSLog(@"objects will load");
    
    if (self.entry != nil) {
        [self.entry removeAllObjects];
    }
    
    if (!self.entry) {
        [self refreshControl];
    }
    
    
    self.totalHeight = [NSNumber numberWithInt:0];
    // This method is called before a PFQuery is fired to get more objects
}



- (PFQuery *) queryForTable {
    
    TSAAppDelegate *tsa = (TSAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"tsa Location: %@", tsa.currentLocation);
    CLLocation *myLocation = tsa.currentLocation;
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:myLocation.coordinate.latitude longitude:myLocation.coordinate.longitude];
    
    NSLog(@"queried for table");
    
    if (!myLocation) {
        NSLog(@"returned nil");
        return nil;
    }
    
    PFQuery *posts = [PFUser query];
    
    if ([self.objects count] == 0) {
        posts.cachePolicy = kPFCachePolicyCacheThenNetwork;
        NSLog(@"checked background");
    }
    
    if ([self.tagEmpty intValue] == 0) {
        if (self.tag1 == [NSNumber numberWithInt:0]) {
            [posts whereKey:@"location" nearGeoPoint:point withinKilometers:8.0];
            [posts whereKeyExists:@"post"];
            [posts whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
            [posts includeKey:@"objectId"];
            [posts includeKey:@"_postValue"];
            [posts includeKey:@"_thoughtCompliments"];
            [posts includeKey:@"_flaggedBy"];

            [posts includeKey:self.textKey];
        }
        else if (self.tag1 == [NSNumber numberWithInt:1]){
            [posts whereKey:@"location" nearGeoPoint:point withinKilometers:8.0];
            [posts whereKeyExists:@"post"];
            [posts whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
            [posts orderByDescending:@"time"];
            [posts includeKey:@"objectId"];
            [posts includeKey:@"_postValue"];
            [posts includeKey:@"_thoughtCompliments"];
            [posts includeKey:@"_flaggedBy"];

            [posts includeKey:self.textKey];
        }
        else if (self.tag1 == [NSNumber numberWithInt:2]) {
            
            [posts whereKey:@"location" nearGeoPoint:point withinKilometers:8.0];
            [posts whereKeyExists:@"post"];
            [posts whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
            [posts whereKey:@"gender" notEqualTo:@"Male"];
            [posts includeKey:@"objectId"];
            [posts includeKey:@"_postValue"];
            [posts includeKey:@"_thoughtCompliments"];
            [posts includeKey:@"_flaggedBy"];

            [posts includeKey:self.textKey];
        }
        else if (self.tag1 == [NSNumber numberWithInt:3]){
            
            [posts whereKey:@"location" nearGeoPoint:point withinKilometers:8.0];
            [posts whereKeyExists:@"post"];
            [posts whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
            [posts whereKey:@"gender" notEqualTo:@"Female"];
            [posts includeKey:@"objectId"];
            [posts includeKey:@"_postValue"];
            [posts includeKey:@"_thoughtCompliments"];
            [posts includeKey:@"_flaggedBy"];

            [posts includeKey:self.textKey];
        }
        else if (self.tag1 == [NSNumber numberWithInt:4]){
            
            [posts whereKey:@"location" nearGeoPoint:point withinKilometers:8.0];
            [posts whereKeyExists:@"post"];
            [posts whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
            [posts orderByDescending:@"postValue"];
            [posts includeKey:@"objectId"];
            [posts includeKey:@"_postValue"];
            [posts includeKey:@"_thoughtCompliments"];
            [posts includeKey:@"_flaggedBy"];

            [posts includeKey:self.textKey];
        }

    }
    else if ([self.tagEmpty intValue] == 1){
        [posts whereKey:@"username" equalTo:@"1"];
        [posts includeKey:self.textKey];
        NSLog(@"empty");
    }
    
    return posts;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.objects count];
    
}

-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    static NSString *CellIdentifier = @"Cell";
    
    NSLog(@"Filled Cell");
    
    self.cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.cell == nil) {
        self.cell  = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *flaggedPosts = [NSArray arrayWithArray:[object objectForKey:@"flaggedBy"]];
    
    if ([self.tagEmpty intValue] == 1){
        [self.cell.complimentButton setEnabled:NO];
        [self.cell.replyButton setEnabled:NO];
        [self.cell.flagButton setEnabled:NO];
        [self.cell.flagHolderButton setEnabled:NO];
        self.tagEmpty = [NSNumber numberWithInt:0];
    }
    
    NSString *nowDate =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *pastDate = [object objectForKey:@"time"];
    
    int nowDatenum = [nowDate intValue];
    int pastDateNum = [pastDate intValue];
    
    int interval = nowDatenum - pastDateNum;
    
    float minutes = interval/60;
    float hours = minutes/60;
    float days = hours/24;
    float weeks = days/7;
    
    self.allCompliments = [NSMutableArray arrayWithArray:[object objectForKey:@"thoughtCompliments"]];
    self.allFlagged = [NSMutableArray arrayWithArray:[object objectForKey: @"flaggedBy"]];
    
    //NSLog(@"%@", self.lockedCompliments);
    
    self.postTotal = [object objectForKey:@"postValue"];
    
    if ([[object objectForKey:@"thoughtCompliments"] containsObject:[[PFUser currentUser] objectId]] || [self.lockedCompliments containsObject:indexPath]) {
        [self.cell.complimentButton setEnabled:NO];
        if ([self.lockedCompliments containsObject:indexPath]) {
            int theIntValue = [self.postTotal intValue];
            theIntValue = theIntValue + 1;
            self.postTotal = [NSNumber numberWithInt:theIntValue];
        }
    }
    if ([self.flaggedPosts containsObject:indexPath]) {
        [self.cell.flagButton setEnabled:NO];
        [self.cell.flagHolderButton setEnabled:NO];
    }
    
    NSString *time;
    int count = 0;
    
    if (minutes < 1){
        time = @"<1m";
    }
    else if (hours < 1) {
        while (minutes >= 1){
            minutes --;
            count ++;
            time = [NSString stringWithFormat:@"%dm", count];
            
        }}
    else if (days < 1) {
        while (hours >= 1){
            hours --;
            count ++;
            time = [NSString stringWithFormat:@"%dh", count];
            
        }}
    else if (weeks < 1) {
        while (days >= 1){
            days --;
            count ++;
            time = [NSString stringWithFormat:@"%dd", count];
            
        }}
    else  {
        weeks --;
        count ++;
        time = [NSString stringWithFormat:@"%dw", count];
        
    }
    
    //NSLog(@"interval = %@", time);
    
    self.cell.timePost.text = time;
    
    self.cell.label.text = [object objectForKey:@"post"];
    
    self.cell.label.textAlignment = NSTextAlignmentCenter;
    
    self.cell.postValue.text = [self.postTotal stringValue];
    
    self.cell.replyButton.tag = indexPath.row;
    self.cell.complimentButton.tag = indexPath.row;
    self.cell.flagButton.tag = indexPath.row;
    
    self.cell.postValue.tag = indexPath.row;
    [self.cell.complimentButton addTarget:self action:@selector(complimentButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.complimentButton setTitle:@"Complimented" forState:UIControlStateDisabled];
    
    [self.cell.flagButton addTarget:self action:@selector(flagButton:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (indexPath.row == [self.objects count] - 1 && [self.objects count]%50 == 0) {
//        if (self.countTag == [NSNumber numberWithInt:0]) {
//            self.countTag = [NSNumber numberWithInt:1];
//            self.count = [NSNumber numberWithInt:[self.objects count]];
//            [self loadNextPage];
//        }
//    }
    
    if ([flaggedPosts containsObject:[[PFUser currentUser] objectId]]) {
        self.cell.label.text = @"";
        self.cell.complimentButton.hidden = YES;
        self.cell.replyButton.hidden = YES;
        self.cell.flagButton.hidden = YES;
        self.cell.flagHolderButton.hidden = YES;
        self.cell.postValue.text = @"";
        self.cell.timePost.text = @"";
    }
    
    return self.cell;
    
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    NSLog(@"before height self.cell= %@", self.entry);
   // NSLog(@"%@", self.counter2);

    CGFloat height = 0.0;
    
    if ([self.counter2 intValue] == 0) {
    
    NSArray *objects = self.objects;
    
    //NSLog(@"%lu", (unsigned long)objects.count);
    
    for (PFObject *post in objects) {
        
        NSArray *flaggedPosts = [post objectForKey:@"flaggedBy"];
        
        NSString *p = [post objectForKey:@"post"];
        
        CGFloat height = [self getHeightArray:p notFlagged:flaggedPosts];
    
        NSNumber *height1 = [NSNumber numberWithFloat:height];
        
        
        if (self.entry == nil) {
            self.entry = [NSMutableArray arrayWithObject:height1];
        }
        else {
            [self.entry addObject:height1];
        }
        
            //NSLog(@"The Posts: %@", p);
        }
    }
    
    if ([self.counter2 intValue] <= self.entry.count - 1) {
        height = [[self.entry objectAtIndex:[self.counter2 intValue]] floatValue];
        int c = [self.counter2 intValue];
        self.counter2 = [NSNumber numberWithInt:c + 1];
    }
    NSLog(@"height: %f", height);
    
    CGFloat i = [self.totalHeight floatValue];
    
    self.totalHeight = [NSNumber numberWithFloat:(i + height)];
    
    return height;
}

- (void)refresh
{
    [self.refreshControl endRefreshing];
    
    NSLog(@"refreshed..");
    
    [self loadObjects];
}

# pragma marks - Scroll Animations

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.tag = [NSNumber numberWithInt:0];
    for (UIView *subview in [self.navigationController.view subviews]) {
        if (subview.tag == 5) {
            [subview removeFromSuperview];
        }
    }
    
}

#pragma marks - Getting Post Height

- (CGFloat) getHeightArray: (NSString *) post notFlagged: (NSArray *) flaggers {
    
    if ([flaggers containsObject:[[PFUser currentUser] objectId]]) {
        return 0;
    }
    
    CGSize labelSize = CGSizeMake(260.0, 28.0);
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    gettingSizeLabel.text = post;
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(260, 9999);
    
    labelSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    
    //labelSize = [post sizeWithFont: [UIFont systemFontOfSize: 17.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
//    if ([post length] > 250){
//        CGSize labelSize = CGSizeMake(245.0, 28.0);
//        
//        labelSize = [post sizeWithFont: [UIFont systemFontOfSize: 17.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
//        
//        return 60 + labelSize.height;
//    }
//
    
    return 60 + labelSize.height;
}


- (IBAction)replyButton:(id)sender {
    self.tag = [NSNumber numberWithInt:0];
    [self showNavBarAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    for (UIView *subview in [self.navigationController.view subviews]) {
        if (subview.tag == 5)
        {
            [subview removeFromSuperview];
        }
    }
    
}

- (IBAction)complimentButton:(UIButton *)sender{
    
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];

    
    self.cell = (PostCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    self.postTotal = [NSNumber numberWithInt:[self.cell.postValue.text integerValue]];
    
    [self.allCompliments addObject:[[PFUser currentUser] objectId]];
    
    
    if (self.lockedCompliments == nil) {
        self.lockedCompliments = [NSMutableArray arrayWithObject:indexPath];
    }
    else {
        [self.lockedCompliments addObject:indexPath];
    }
    
    int theIntValue = [self.postTotal intValue];
    theIntValue = theIntValue + 1;
    NSString *strFromInt = [NSString stringWithFormat:@"%d",theIntValue];
    self.cell.postValue.text = strFromInt;
    
    PFObject *object = [self.objects objectAtIndex:sender.tag];
    
    [PFCloud callFunctionInBackground:@"complimentCounter" withParameters:@{ @"userId": object.objectId, @"increment": @1, @"tag": @1, @"compliment": self.allCompliments} block:^(id success, NSError *error) {
        if (!error) {
            NSLog(@"Complimented");
        }
    }];
 
    [sender setEnabled:NO];
    
}

-(IBAction) flagButton:(UIButton *)sender {
    
    [sender setEnabled:NO];
    
    //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    //NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];

    
    self.cell = (PostCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self.cell.flagHolderButton setEnabled:NO];
    [self.cell.flagHolderButton setImage:[UIImage imageNamed:@"redFlag"] forState:UIControlStateDisabled];
    NSLog(@"%@", indexPath);

    if (self.flaggedPosts == nil) {
        self.flaggedPosts = [NSMutableArray arrayWithObject:indexPath];
    }
    else {
        [self.flaggedPosts addObject:indexPath];
    }
    
    PFObject *object = [self.objects objectAtIndex:sender.tag];
    [self.allFlagged addObject:[[PFUser currentUser] objectId]];

    [PFCloud callFunctionInBackground:@"flag" withParameters:@{ @"userId": object.objectId, @"flaggers": self.allFlagged} block:^(id success, NSError *error) {
        if (!error) {
            NSLog(@"Flagged");
        }
    }];
    
    NSString *post = [object objectForKey:@"post"];
    
    PFObject *flag = [PFObject objectWithClassName:@"FlaggedPost"];
    [flag setObject:post forKey:@"post"];
    [flag setObject:object.objectId forKey:@"creator"];
        
        
    [flag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
                // Dismiss the NewPostViewController and show the BlogTableViewController
        }
    }];
    
}


-(IBAction)filter:(id)sender{
    
    if (self.tag == [NSNumber numberWithInt:0]) {
        
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"Near", @"New", @"Girls", @"Guys",@"Top", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        UIView *choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, 320, 45)];
    
        choiceView.backgroundColor = [UIColor blackColor];
        segmentedControl.backgroundColor = [UIColor clearColor];
        segmentedControl.tintColor = [UIColor whiteColor];
        [choiceView addSubview:segmentedControl];
    
 
    
        segmentedControl.frame = CGRectMake(15, 8, 290, 30);
        [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
        choiceView.tag = 5;
        
        [self.navigationController.view addSubview:choiceView];
        
        segmentedControl.selectedSegmentIndex = [self.tag1 intValue];
        
        
        self.tag = [NSNumber numberWithInt:1];
    }
    else if (self.tag == [NSNumber numberWithInt:1]) {
        
        for (UIView *subview in [self.navigationController.view subviews]) {
            if (subview.tag == 5)
            {
                
                [subview removeFromSuperview];
            }
        }
      
        
        self.tag = [NSNumber numberWithInt:0];
    }
    
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0){
        
        self.tag1 = [NSNumber numberWithInt:0];
        self.totalHeight = [NSNumber numberWithInt:0];
        [self queryForTable];
        [self loadObjects];
        [NSThread sleepForTimeInterval:0.4];
        for (UIView *subview in [self.navigationController.view subviews]) {
            if (subview.tag == 5)
            {
                
                [subview removeFromSuperview];
            }
        }
        self.tag = [NSNumber numberWithInt:0];
        //VINH AFTER THIS code for the first button
    }
    else if(segment.selectedSegmentIndex == 1){
        
        self.tag1 = [NSNumber numberWithInt:1];
        self.totalHeight = [NSNumber numberWithInt:0];
        [self queryForTable];
        [self loadObjects];
       [NSThread sleepForTimeInterval:0.4];
        for (UIView *subview in [self.navigationController.view subviews]) {
            if (subview.tag == 5)
            {
                
                [subview removeFromSuperview];
            }
        }
        self.tag = [NSNumber numberWithInt:0];
       
        //VINH AFTER THIS code for the second button
    }
    else if(segment.selectedSegmentIndex == 2){
        
        self.tag1 = [NSNumber numberWithInt:2];
        self.totalHeight = [NSNumber numberWithInt:0];
        [self queryForTable];
        [self loadObjects];
        [NSThread sleepForTimeInterval:0.4];
        for (UIView *subview in [self.navigationController.view subviews]) {
            if (subview.tag == 5)
            {
                
                [subview removeFromSuperview];
            }
        }
        self.tag = [NSNumber numberWithInt:0];
      
        //VINH AFTER THIS code for the third button
    }
    else if(segment.selectedSegmentIndex == 3){
        
        self.tag1 = [NSNumber numberWithInt:3];
        self.totalHeight = [NSNumber numberWithInt:0];
        [self queryForTable];
        [self loadObjects];
        [NSThread sleepForTimeInterval:0.4];
        for (UIView *subview in [self.navigationController.view subviews]) {
            if (subview.tag == 5)
            {
                
                [subview removeFromSuperview];
            }
        }
        self.tag = [NSNumber numberWithInt:0];
        
        // VINH AFTER THIS code for the fourth button
    }
    else if(segment.selectedSegmentIndex == 4){
        
        self.tag1 = [NSNumber numberWithInt:4];
        self.totalHeight = [NSNumber numberWithInt:0];
        [self queryForTable];
        [self loadObjects];
        [NSThread sleepForTimeInterval:0.4];
        for (UIView *subview in [self.navigationController.view subviews]) {
            if (subview.tag == 5)
            {
                
                [subview removeFromSuperview];
            }
        }
        self.tag = [NSNumber numberWithInt:0];
    }

}



- (IBAction)composeButton:(id)sender {
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    if ([segue.identifier isEqualToString:@"showLogIn"] || [segue.identifier isEqualToString:@"launch1"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed: YES];
        
    }
    if ([segue.identifier isEqualToString:@"replySegue"]) {
        
        PFObject *object = [self.objects objectAtIndex:sender.tag];
        
        ReplyViewController *userProfile = [segue destinationViewController];
        userProfile.userInfo = object;
        //NSLog (@"yes 2");
        self.tabBarController.tabBar.alpha = 1;
        self.tabBarController.tabBar.hidden = NO;

    }
}

#pragma marks - Got Location

-(void) gotLocation: (NSNotification *)note {
    [self loadObjects];
    
}

@end
