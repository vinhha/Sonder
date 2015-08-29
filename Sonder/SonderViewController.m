//
//  SonderViewController.m
//  Sonder
//
//  Created by vinh ha on 1/21/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "SonderViewController.h"
#import "SonderProfileViewController.h"
#import "UIViewController+ScrollingNavbar.h"


@interface SonderViewController ()

@end

@implementation SonderViewController

//@synthesize objectId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.navigationController.view addSubview:view];
    
    NSLog(@"viewdidLoad");
    
    
    self.objectsPerPage = 50;
    [self followScrollView:self.tableView];
    
    self.tag1 = [NSNumber numberWithInt:0];
    self.countTag = [NSNumber numberWithInt:0];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:152/255.0f alpha:0.8];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    
    NSLog(@"viewWillAppear");
    
    [self loadObjects];

    self.tag = [NSNumber numberWithInt:0];
    for (UIView *subview in [self.navigationController.view subviews]) {
        if (subview.tag == 5)
        {
            
            [subview removeFromSuperview];
        }
    }
    //self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:21.0]};
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.tabBarController.tabBar.alpha = 1;
    self.tabBarController.tabBar.hidden = NO;
    
    NSLog(@"viewDidAppear");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"_User";
        self.textKey = @"_name";
        self.imageKey = @"_file";
        self.pullToRefreshEnabled = YES;
        self.tag1 = [NSNumber numberWithInt:0];

    }
    
    return self;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    NSLog(@"objectsDidLoad");
    
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
    NSLog(@"objectsWillLoad");
    // This method is called before a PFQuery is fired to get more objects
}


- (PFQuery *) queryForTable {
    
    TSAAppDelegate *tsa = (TSAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.currentPosition = tsa.currentLocation;
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:self.currentPosition.coordinate.latitude longitude:self.currentPosition.coordinate.longitude];

    if (!self.currentPosition) {
        return nil;
    }
    
    PFQuery *locals = [PFUser query];
    
    if ([self.objects count] == 0) {
        locals.cachePolicy = kPFCachePolicyCacheThenNetwork;
        NSLog(@"checked background");
    }
    if (self.tag1 == [NSNumber numberWithInt:0]) {

        NSLog(@"What user?");
        [locals whereKey:@"location" nearGeoPoint:point withinKilometers:8.0];
        [locals whereKey:@"userId" notEqualTo:[[PFUser currentUser] objectId]];
        [locals includeKey:self.textKey];
        [locals includeKey:self.imageKey];
        [locals includeKey:@"_coverfile"];
        [locals includeKey:@"_school"];
        [locals includeKey:@"_username"];
        [locals includeKey:@"_objectId"];
        [locals includeKey:@"_userId"];
        [locals includeKey:@"_age"];
        [locals includeKey:@"_bio"];
        [locals includeKey:@"_gender"];
        [locals includeKey:@"_relationship"];
        [locals includeKey:@"_instagram"];
        [locals includeKey:@"_twitter"];
        [locals includeKey:@"_compliments"];
        [locals includeKey:@"_complimentsValue"];
        [locals includeKey:@"_facebook"];
        [locals includeKey:@"_AboutMe"];
        [locals includeKey:@"_thoughtTotal"];
        [locals includeKey:@"_profileTotal"];
        [locals includeKey:@"_profileCompliments"];
    }
    else if (self.tag1 == [NSNumber numberWithInt:1]){
        
        [locals whereKey:@"location" nearGeoPoint:point withinKilometers:8.0];
        [locals whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
        [locals orderByDescending:@"complimentsValue"];
        [locals includeKey:self.textKey];
        [locals includeKey:self.imageKey];
        [locals includeKey:@"_coverfile"];
        [locals includeKey:@"_school"];
        [locals includeKey:@"_username"];
        [locals includeKey:@"_objectId"];
        [locals includeKey:@"_age"];
        [locals includeKey:@"_bio"];
        [locals includeKey:@"_gender"];
        [locals includeKey:@"_relationship"];
        [locals includeKey:@"_instagram"];
        [locals includeKey:@"_twitter"];
        [locals includeKey:@"_compliments"];
        [locals includeKey:@"_complimentsValue"];
        [locals includeKey:@"_facebook"];
        [locals includeKey:@"_AboutMe"];
        [locals includeKey:@"_thoughtTotal"];
        [locals includeKey:@"_profileTotal"];
        [locals includeKey:@"_profileCompliments"];
    }
    return locals;
}


-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    //NSLog(@"got locals");
    
    static NSString *CellIdentifier = @"Cell";
    
    //NSLog(@"%@ | %@", [object objectForKey:@"userId"], [[PFUser currentUser] objectId]);
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.imageView.image = [UIImage imageNamed:@"sonderDefault"];

    
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [object objectForKey:@"bio"];
    PFFile *imageFile = [object objectForKey:@"file"];
    if (imageFile == nil) {
        cell.imageView.image = [UIImage imageNamed:@"profile_default"];
    }
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            cell.imageView.image = [UIImage imageWithData:result];
        }
    }];
    
    if (indexPath.row == [self.objects count] - 1 && ([self.objects count]%50 == 0 || [self.objects count]%50 == 1)) {
        if (self.countTag == [NSNumber numberWithInt:0]) {
            self.countTag = [NSNumber numberWithInt:1];
            self.count = [NSNumber numberWithInt:[self.objects count]];
            [self loadNextPage];
        }
    }
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tag = [NSNumber numberWithInt:0];
    for (UIView *subview in [self.navigationController.view subviews]) {
        if (subview.tag == 5) {
            [subview removeFromSuperview];
        }
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
    if ([segue.identifier isEqualToString:@"sonderProfile"]) {
        
        for (UIView *subview in [self.navigationController.view subviews]) {
            if (subview.tag == 5) {
                [subview removeFromSuperview];
            }
        }
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        [self showNavBarAnimated:YES];
        
        SonderProfileViewController *userProfile = [segue destinationViewController];
        userProfile.userInfo = object;
        NSLog (@"yes 2");
    }
}

- (void)refresh
{
    [self.refreshControl endRefreshing];
    
    NSLog(@"refreshed..");
    
    [self loadObjects];
}

- (IBAction)filter:(id)sender {
    
    
    if (self.tag == [NSNumber numberWithInt:0]) {

        NSArray *itemArray = [NSArray arrayWithObjects: @"Near", @"Top", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        UIView *choiceView = [[UIView alloc] initWithFrame:CGRectMake(100, 18, 120, 45)];
    
        choiceView.backgroundColor = [UIColor blackColor];
        segmentedControl.backgroundColor = [UIColor clearColor];
        segmentedControl.tintColor = [UIColor whiteColor];
        [choiceView addSubview:segmentedControl];
    
    
    
        segmentedControl.frame = CGRectMake(0, 8, 120, 30);
        [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];choiceView.tag = 5;
    
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

- (void)MySegmentControlAction:(UISegmentedControl *)segment {
    
    if(segment.selectedSegmentIndex == 0){
        
        self.tag1 = [NSNumber numberWithInt:0];
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

    
}
@end
