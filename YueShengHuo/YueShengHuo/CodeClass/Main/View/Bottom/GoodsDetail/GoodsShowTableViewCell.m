//
//  GoodsShowTableViewCell.m
//  Life
//
//  Created by lanou on 16/5/27.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "GoodsShowTableViewCell.h"

@implementation GoodsShowTableViewCell

- (void)setModel:(GoodsDetailModel *)model{
    if (_model != model) {
        _model = model;
        
        self.title.text = model.title;
        [self.showImage sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.content.text = model.desc;
        self.browseNum.text = [NSString stringWithFormat:@"%@",model.browseVolume];
        float price = [model.sourceData[@"price"]floatValue];
        self.price.text = [NSString stringWithFormat:@"推荐价格:%.2f元",price/100];
        
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
