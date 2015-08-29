//
//  PreliminaryLoginViewController.m
//  Sonder
//
//  Created by vinh ha on 7/27/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "PreliminaryLogInViewController.h"
#import <Parse/Parse.h>

@interface PreliminaryLogInViewController ()

@end

@implementation PreliminaryLogInViewController

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
    // Do any additional setup after loading the view.
    
   
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    

    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
    

    
    
@end
