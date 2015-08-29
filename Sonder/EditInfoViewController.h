//
//  EditInfoViewController.h
//  Sonder
//
//  Created by vinh ha on 5/30/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditInfoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *choosePhoto;
@property (strong, nonatomic) IBOutlet UITextField *school;
@property (strong, nonatomic) IBOutlet UITextField *hometown;
@property (strong, nonatomic) IBOutlet UISegmentedControl *relation;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSNumber *tag;


@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UIImageView *coverPic;

- (IBAction)addPhoto:(id)sender;
- (IBAction)coverPhoto:(id)sender;

- (void)uploadMessage;
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

- (IBAction)finish:(id)sender;

@end
