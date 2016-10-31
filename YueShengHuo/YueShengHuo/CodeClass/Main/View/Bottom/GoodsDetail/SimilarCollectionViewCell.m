//
//  SimilarCollectionViewCell.m
//  Life
//
//  Created by lanou on 16/5/27.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "SimilarCollectionViewCell.h"

@implementation SimilarCollectionViewCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.similarImage.layer.cornerRadius = 5;
    self.similarImage.layer.masksToBounds = YES;
}

@end
