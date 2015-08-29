//
//  EditSMViewController.h
//  Sonder
//
//  Created by vinh ha on 5/30/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSMViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *twitter;
@property (strong, nonatomic) IBOutlet UITextField *instagram;
@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) IBOutlet UIButton *facebookLabel;


- (IBAction)facebook:(id)sender;
- (IBAction)finish:(id)sender;


@end
