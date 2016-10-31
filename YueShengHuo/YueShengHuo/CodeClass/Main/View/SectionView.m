//
//  SectionView.m
//  Life
//
//  Created by  on 16/5/25.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "SectionView.h"

@interface SectionView ()
@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *lab;
@end

@implementation SectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc]init];
        [self addSubview:self.imageV];
        
        self.lab = [[UILabel alloc]init];
        [self addSubview:_lab];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageV.frame = CGRectMake(0, 0, ScreenWidth, self.frame.size.height);
    self.imageV.image = [UIImage imageNamed:@"1"];
    
    self.lab.frame = CGRectMake(20, 0, 70, 40);
    self.lab.text = @"推荐好物";
    self.lab.textColor = [UIColor whiteColor];
}

@end
