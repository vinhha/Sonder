//
//  PostCell.m
//  Sonder
//
//  Created by vinh ha on 2/18/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.complimentButton];
        [self addSubview:self.label];
        // Initialization code
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void) prepareForReuse {
    
    [self.complimentButton setEnabled:YES];
    [self.flagButton setEnabled:YES];
    [self.flagHolderButton setEnabled:YES];
    [self.replyButton setEnabled:YES];
    self.complimentButton.hidden = NO;
    self.replyButton.hidden = NO;
    self.flagButton.hidden = NO;
    self.flagHolderButton.hidden = NO;
    [self.flagHolderButton setImage:[UIImage imageNamed:@"flag-7"] forState:UIControlStateNormal];
    
}


@end
