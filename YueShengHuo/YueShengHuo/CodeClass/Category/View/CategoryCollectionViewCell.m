//
//  CategoryCollectionViewCell.m
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews{
    self.imageV.layer.cornerRadius = 35;
    self.imageV.layer.masksToBounds = YES;
}

@end
