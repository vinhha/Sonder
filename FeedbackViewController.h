//
//  FeedbackViewController.h
//  Sonder
//
//  Created by vinh ha on 8/21/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *feebackText;
- (IBAction)sendFeedback:(id)sender;

@end
