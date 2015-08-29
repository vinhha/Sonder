//
//  SonderViewController.h
//  Sonder
//
//  Created by vinh ha on 1/21/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <Parse/Parse.h>
#import "TSAAppDelegate.h"

@interface SonderViewController : PFQueryTableViewController

@property (strong, nonatomic) PFGeoPoint *myLocation;
@property (strong, nonatomic) NSIndexPath *selectedCell;
//@property (strong, nonatomic) NSMutableString *objectId;
@property (strong, nonatomic) CLLocation *currentPosition;
@property (nonatomic, assign) CGPoint lastContentOffset_;
@property (strong, nonatomic) NSNumber *tag;
@property (strong, nonatomic) NSNumber *tag1;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *countTag;




- (IBAction)filter:(id)sender;

@end
