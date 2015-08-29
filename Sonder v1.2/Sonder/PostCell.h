//
//  PostCell.h
//  Sonder
//
//  Created by vinh ha on 2/18/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *complimentButton;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UILabel *timePost;
@property (strong, nonatomic) IBOutlet UILabel *postValue;
@property (strong, nonatomic) IBOutlet UIButton *flagButton;
@property (strong, nonatomic) IBOutlet UIButton *flagHolderButton;

@end
