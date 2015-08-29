//
//  BuildProfileViewController.h
//  Sonder
//
//  Created by vinh ha on 1/5/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface BuildProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *schoolField;
@property (strong, nonatomic) IBOutlet UITextField *bioField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *relationshipSegmenter;
@property (strong, nonatomic) IBOutlet UIButton *choosePhotoBtn;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSNumber *tag;

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;

- (IBAction)addPhoto:(id)sender;
- (IBAction)addCover:(id)sender;

- (void)uploadMessage;
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;


@end
