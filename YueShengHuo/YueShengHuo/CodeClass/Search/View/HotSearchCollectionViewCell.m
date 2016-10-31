//
//  HotSearchCollectionViewCell.m
//  Life
//
//  Created by lanou on 16/5/28.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "HotSearchCollectionViewCell.h"

@implementation HotSearchCollectionViewCell

- (void)awakeFromNib {
    self.wordsL.layer.cornerRadius = 3;
    self.wordsL.layer.masksToBounds = YES;
}

@end
