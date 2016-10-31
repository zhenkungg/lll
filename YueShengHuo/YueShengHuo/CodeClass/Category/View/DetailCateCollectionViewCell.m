
//
//  DetailCateCollectionViewCell.m
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailCateCollectionViewCell.h"

@interface DetailCateCollectionViewCell ()
@property (strong, nonatomic)UIView *shadowView;

@end
@implementation DetailCateCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (ScreenWidth-24)/2 - 3, (ScreenWidth-24)/2 - 3)];
        [self.contentView addSubview:self.shadowView];
        self.detailImageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (ScreenWidth-24)/2 - 2, (ScreenWidth-24)*3/8)];
        [self.shadowView addSubview:self.detailImageV];
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (ScreenWidth-24)*3/8, (ScreenWidth-24)/2, (ScreenWidth-24)/8)];
        [self.contentView addSubview:self.detailLabel];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:15];
    self.shadowView.layer.shadowOffset = CGSizeMake(2,2);
    self.shadowView.layer.shadowOpacity = 0.5;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
