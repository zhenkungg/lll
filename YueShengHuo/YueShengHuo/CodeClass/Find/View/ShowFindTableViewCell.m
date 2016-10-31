//
//  ShowFindTableViewCell.m
//  Life
//
//  Created by lanou on 16/5/25.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "ShowFindTableViewCell.h"

@implementation ShowFindTableViewCell

- (void)awakeFromNib {
//    self.collectView.backgroundColor= [UIColor grayColor];
    self.collectView.layer.cornerRadius = 5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
