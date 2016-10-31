//
//  GoodsTableViewCell.m
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (void)setModel:(GoodsModel *)model{
    if (_model != model) {
        _model = model;
        
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        

        self.label.text = model.title;
        self.content.text = model.desc;
    }
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
