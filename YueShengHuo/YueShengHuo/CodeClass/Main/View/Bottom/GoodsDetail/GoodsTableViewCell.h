//
//  GoodsTableViewCell.h
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@interface GoodsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *content;

@property (nonatomic,strong)GoodsModel *model;

@end
