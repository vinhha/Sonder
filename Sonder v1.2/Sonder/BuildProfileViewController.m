//
//  BuildProfileViewController.m
//  Sonder
//
//  Created by vinh ha on 1/5/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "BuildProfileViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PreliminaryLogInViewController.h"

@interface BuildProfileViewController ()

@end

@implementation BuildProfileViewController

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
    
    
    NSLog(@"Name: %@", self.name);
    
    if (self.signUpTag == [NSNumber numberWithInt:1]) {
        
        NSString *facebookID = self.facebookID;
        NSString *name = self.name;
        NSString *gender;
        if ([self.gender isEqualToString:@"male"]) {
            gender = @"Male";
        }
        else if ([self.gender isEqualToString:@"female"]) {
            gender = @"Female";
        }
        NSString *birthday = self.birthday;
        NSString *email = self.userEmail;
        PFUser *image = [PFUser currentUser];
        image[@"name"] = name;
        image[@"facebook"] = facebookID;
        image[@"gender"] = gender;
        image[@"birthday"] = birthday;
        image[@"email"] = email;
        image[@"username"] = email;
        image[@"complimentsValue"] = [NSNumber numberWithInt:0];
        image[@"thoughtTotal"] = [NSNumber numberWithInt:0];
        image[@"postTotal"] = [NSNumber numberWithInt:0];
        image[@"profileTotal"] = [NSNumber numberWithInt:0];

        [image setObject:[[PFUser currentUser] objectId] forKey:@"userId"];
        [image setObject:[[PFUser currentUser] username] forKey:@"userLogin"];
        [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                            message:@"Please try sending your message again."
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }

        }];

        
    }
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    self.userImage.layer.cornerRadius = 60;
    self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userImage.layer.borderWidth = 2;
    self.userImage.layer.masksToBounds = YES;
    
    self.schoolField.delegate = self;
    self.bioField.delegate = self;
    
    self.relationship = @"";
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)showBuildProfile sender:(id)sender {


    NSString *school = self.schoolField.text;
    
    if ([school length] == 0) {
        school = nil;
    }
    
    [sender setEnabled:NO];
    
    NSString *bio = self.bioField.text;
    
    switch (self.relationshipSegmenter.selectedSegmentIndex) {
        case 0:
            self.relationship = [self.relationshipSegmenter titleForSegmentAtIndex:self.relationshipSegmenter.selectedSegmentIndex];
            break;
        case 1:
            self.relationship = [self.relationshipSegmenter titleForSegmentAtIndex:self.relationshipSegmenter.selectedSegmentIndex];
            break;
        case 2:
            self.relationship = [self.relationshipSegmenter titleForSegmentAtIndex:self.relationshipSegmenter.selectedSegmentIndex];
            break;
        default:
            break;
    }
    

    
    if ([bio length] == 0 || [self.relationship length] == 0 || [self.relationship isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you fill out all of the information correctly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [sender setEnabled:YES];
        return NO;
    }
    else {
        PFUser *userProfile = [PFUser currentUser];
        
        if ([school length] != 0) {
            if ([school length] <= 12){
            userProfile[@"school"] = school;
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Please abbreviate your school." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [sender setEnabled:YES];
                return NO;
            }
        }
        userProfile[@"bio"] = bio;
        userProfile[@"relationship"] = self.relationship;
        
        [userProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [sender setEnabled:YES];
            }
            else {
                //Sign up the user.
            }

        }];
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:[[PFUser currentUser] objectId] forKey:@"user"];
        [currentInstallation saveInBackground];
        
        return YES; }    
}


#pragma mark - Image Picker

- (IBAction)addPhoto:(id)sender {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    self.tag = [NSNumber numberWithInt:0];

    if((UIButton *) sender == _choosePhotoBtn) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

- (IBAction)addCover:(id)sender {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    self.tag = [NSNumber numberWithInt:1];

    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [mediaType isEqualToString:(NSString *)kUTTypeImage];
        // A photo was taken/selected!
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (self.tag == [NSNumber numberWithInt:0]) {
        self.userImage.image = self.image; }
    else if (self.tag == [NSNumber numberWithInt:1]) {
        self.coverImage.image = self.image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self uploadMessage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)uploadMessage;{
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;

    if (self.tag == [NSNumber numberWithInt:0]) {
        
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:320.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
        
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                    message:@"Please try sending your message again."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                PFUser *image = [PFUser currentUser];
                [image setObject:file forKey:@"file"];
                [image setObject:fileType forKey:@"fileType"];
                [image setObject:[[PFUser currentUser] objectId] forKey:@"userId"];
                [image setObject:[[PFUser currentUser] username] forKey:@"userLogin"];
                [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                            message:@"Please try sending your message again."
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else {
                        // Everything was successful!
                    }
                }];
            }
        }];
    }
    if (self.tag == [NSNumber numberWithInt:1]) {
        
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:320.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
        
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                    message:@"Please try sending your message again."
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                PFUser *image = [PFUser currentUser];
                [image setObject:file forKey:@"coverfile"];
                [image setObject:fileType forKey:@"coverfileType"];
                [image setObject:[[PFUser currentUser] objectId] forKey:@"userId"];
                [image setObject:[[PFUser currentUser] username] forKey:@"userLogin"];
                [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                            message:@"Please try sending your message again."
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    }
                    else {
                        // Everything was successful!
                    }
                }];
            }
        }];
    }
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;{
    
        CGSize newSize = CGSizeMake(width, height);
        CGRect newRectangle = CGRectMake(0, 0, width, height);
        UIGraphicsBeginImageContext(newSize);
        [self.image drawInRect:newRectangle];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resizedImage;

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.bioField resignFirstResponder];
    [self.schoolField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
