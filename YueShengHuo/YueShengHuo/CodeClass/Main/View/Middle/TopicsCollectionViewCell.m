//
//  TopicsCollectionViewCell.m
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "TopicsCollectionViewCell.h"

@implementation TopicsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc]init];
        self.lab = [[UILabel alloc]init];
        [self addSubview:self.imageV];
        [self addSubview:self.lab];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageV.frame = CGRectMake(0, 7, self.frame.size.width, self.frame.size.height-30);
    self.imageV.layer.cornerRadius = 30;
    self.imageV.layer.masksToBounds = YES;
    
    self.lab.frame = CGRectMake(0, self.frame.size.width+7, self.frame.size.width, 20);
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.font = [UIFont systemFontOfSize:10];
    
}
- (void)awakeFromNib {
    // Initialization code
}

@end
