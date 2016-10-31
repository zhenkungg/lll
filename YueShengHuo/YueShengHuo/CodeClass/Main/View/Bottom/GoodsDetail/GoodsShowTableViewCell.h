//
//  GoodsShowTableViewCell.h
//  Life
//
//  Created by lanou on 16/5/27.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

@interface GoodsShowTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleNum;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *showImage;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *browseNum;
@property (strong, nonatomic) IBOutlet UILabel *price;

@property (nonatomic,strong)GoodsDetailModel *model;

@end
