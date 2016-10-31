//
//  HeadViewCollectionReusableView.m
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "HeadViewCollectionReusableView.h"

@implementation HeadViewCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7.5, ScreenWidth, 25)];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 5, 30)];
        lab.backgroundColor = [UIColor orangeColor];
        [self addSubview:lab];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
