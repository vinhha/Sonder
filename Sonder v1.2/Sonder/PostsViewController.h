//
//  PostsViewController.h
//  Sonder
//
//  Created by vinh ha on 2/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <Parse/Parse.h>
#import "PostCell.h"
#import "TSAAppDelegate.h"

@interface PostsViewController : PFQueryTableViewController <UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIBarButtonItem *filter;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) PFGeoPoint *myLocation;
@property (strong, nonatomic) UIButton *complimentButton;
@property (strong, nonatomic) PostCell *cell;
@property (strong, nonatomic) UIButton *replyButton;
@property (strong, nonatomic) NSMutableArray *entry;
@property (strong, nonatomic) NSNumber *counter2;
@property (strong, nonatomic) NSNumber *tag;
@property (strong, nonatomic) NSNumber *tag1;
@property (strong, nonatomic) NSNumber *count;
@property (strong, nonatomic) NSNumber *countTag;
@property (strong, nonatomic) NSNumber *tagEmpty;
@property (strong, nonatomic) NSNumber *postTotal;
@property (strong, nonatomic) NSMutableArray *top;
@property (nonatomic, assign) CGPoint lastContentOffset_;
@property (strong, nonatomic) NSNumber *totalHeight;
@property (strong, nonatomic) NSMutableArray *allCompliments;
@property (strong, nonatomic) NSArray *userCompliments;
@property (strong, nonatomic) NSMutableArray *lockedCompliments;
@property (strong, nonatomic) NSMutableArray *flaggedPosts;
@property (strong, nonatomic) NSMutableArray *allFlagged;



- (IBAction)filter:(id)sender;

- (IBAction)replyButton:(id)sender;

- (IBAction)complimentButton:(UIButton *)sender;

- (IBAction)composeButton:(id)sender;

@end
