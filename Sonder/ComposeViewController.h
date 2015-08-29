//
//  ComposeViewController.h
//  Sonder
//
//  Created by vinh ha on 2/7/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ComposeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *postLabel;
@property (strong, nonatomic) NSString *post;
@property (strong, nonatomic) IBOutlet UIButton *composeButton;
@property (strong, nonatomic) IBOutlet UILabel *timePost;
@property (strong, nonatomic) IBOutlet UILabel *postTotal;
@property (strong, nonatomic) IBOutlet UILabel *complimentsLabel;
- (IBAction)clearPost:(id)sender;

@end
