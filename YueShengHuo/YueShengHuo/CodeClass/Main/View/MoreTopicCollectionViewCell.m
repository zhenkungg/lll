//
//  MoreTopicCollectionViewCell.m
//  Life
//
//  Created by lanou on 16/6/2.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "MoreTopicCollectionViewCell.h"

@implementation MoreTopicCollectionViewCell

- (void)awakeFromNib {
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = 0.5;
    
    self.imageV.layer.cornerRadius = 10;
    self.imageV.layer.masksToBounds = YES;

}

@end
