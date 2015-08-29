//
//  EditInfoViewController.m
//  Sonder
//
//  Created by vinh ha on 5/30/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "EditInfoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>


@interface EditInfoViewController ()

@end

@implementation EditInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hometown.delegate = self;
    self.school.delegate = self;
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *object, NSError *error) {
        
        self.relationship = [object objectForKey:@"relationship"];
        
        PFFile *imageFile = [object objectForKey:@"file"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:result];
                self.profilePic.image = image;
                
                
            }
        }];
        PFFile *coverFile = [object objectForKey:@"coverfile"];
        [coverFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:result];
                self.coverPic.image = image;
                
                
            }
        }];
    }];
}

-(void) viewWillAppear:(BOOL)animated {
    
    self.profilePic.layer.cornerRadius = 60;
    self.profilePic.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profilePic.layer.borderWidth = 2;
    self.profilePic.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addPhoto:(id)sender {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.navigationController.navigationBar.translucent = NO;

    self.tag = [NSNumber numberWithInt:0];
    
    if((UIButton *) sender == _choosePhoto) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:self.imagePicker animated:NO completion:nil];
    
}

- (IBAction)coverPhoto:(id)sender {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.navigationController.navigationBar.translucent = NO;
    
    self.tag = [NSNumber numberWithInt:1];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

    [self presentViewController:self.imagePicker animated:NO completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [mediaType isEqualToString:(NSString *)kUTTypeImage];
    // A photo was taken/selected!
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"%@", self.tag);
    
    if (self.tag == [NSNumber numberWithInt:0]) {
        self.profilePic.image = self.image;
    }
    else if (self.tag == [NSNumber numberWithInt:1]) {
        self.coverPic.image = self.image;
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

- (IBAction)finish:(id)sender {
    
    NSString *edu = self.school.text;
    
    if ([edu length] == 0) {
        edu = nil;
    }
    
    NSString *home = self.hometown.text;
    NSString *relationship = self.relationship;
    
    if ([home length] == 0) {
        home = nil;
    }

    switch (self.relation.selectedSegmentIndex) {
        case 0:
            relationship = [self.relation titleForSegmentAtIndex:self.relation.selectedSegmentIndex];
            break;
        case 1:
            relationship = [self.relation titleForSegmentAtIndex:self.relation.selectedSegmentIndex];
            break;
        case 3:
            relationship = [self.relation titleForSegmentAtIndex:self.relation.selectedSegmentIndex];
            break;
        default:
            break;
    }
    
    
    PFUser *userProfile = [PFUser currentUser];
    
    if ([edu length] != 0) {
        userProfile[@"school"] = edu;
    }
    
    if ([home length] != 0) {
        userProfile[@"bio"] = home;
    }
    if ([relationship length] != 0 && relationship != self.relationship) {
        userProfile[@"relationship"] = relationship;
    }
    
    [userProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            //Sign up the user.
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.navigationController.navigationBar.hidden = NO;
        }
        
    }];

    
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.hometown resignFirstResponder];
    [self.school resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ((int)[[UIScreen mainScreen] bounds].size.height == 568){
        if (textField == self.hometown) {
            
        }
    }
    else{
        
        if (textField == self.hometown) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.hometown.frame = CGRectMake(20, (self.hometown.frame.origin.y - 38), self.hometown.frame.size.width, self.hometown.frame.size.height);
            [UIView commitAnimations];
        }}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ((int)[[UIScreen mainScreen] bounds].size.height == 568){
        
        
        
    }
    else{
        
        if (textField == self.hometown) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.hometown.frame = CGRectMake(self.hometown.frame.origin.x, (self.hometown.frame.origin.y + 38.0), self.hometown.frame.size.width, self.hometown.frame.size.height);
            [UIView commitAnimations];}
        
    }
}


@end
