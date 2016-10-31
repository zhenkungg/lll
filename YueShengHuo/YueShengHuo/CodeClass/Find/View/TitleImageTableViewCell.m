//
//  TitleImageTableViewCell.m
//  发现
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Li. All rights reserved.
//

#import "TitleImageTableViewCell.h"

@implementation TitleImageTableViewCell

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//        self.imageV = [[UIImageView alloc]init];
//        [self.contentView addSubview:self.imageV];
//    }
//    return self;
//}
//
//
//- (void)setWidth:(NSInteger)width{
//    if (_width != width) {
//        _width = width;
//        self.imageV.frame = CGRectMake(0, 0, ScreenWidth,ScreenWidth*(_height/_width));
//    }
//    
//}

//self.frame.size.width * ([self.height floatValue] / [self.width floatValue])



- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
