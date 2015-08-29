//
//  OpenerViewController.m
//  Sonder
//
//  Created by vinh ha on 7/21/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "OpenerViewController.h"

@interface OpenerViewController ()

@end

@implementation OpenerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = YES;
    
}


-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];

}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self dismissViewControllerAnimated:YES  completion:nil];


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
