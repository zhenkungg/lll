//
//  HotSearchCollectionViewCell.m
//  YueShengHuo
//
//  Created by lanou on 16/10/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "HotSearchCollectionViewCell.h"

@implementation HotSearchCollectionViewCell

- (void)awakeFromNib {
    self.wordsL.layer.cornerRadius = 3;
    self.wordsL.layer.masksToBounds = YES;

}

@end
