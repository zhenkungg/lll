//
//  KindCollectionViewCell.m
//  Life
//
//  Created by lanou on 16/5/31.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "KindCollectionViewCell.h"

@implementation KindCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.lab = [[UILabel alloc]init];
        [self addSubview:self.lab];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lab.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    self.lab.font = [UIFont systemFontOfSize:13];
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.textColor = [UIColor redColor];
    self.lab.alpha = 0.5;
}
@end
