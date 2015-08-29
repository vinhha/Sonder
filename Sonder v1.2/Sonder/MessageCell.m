//
//  MessageCell.m
//  Sonder
//
//  Created by vinh ha on 3/2/14.
//  Copyright (c) 2014 Vinh Ha. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
}



@end
