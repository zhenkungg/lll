//
//  GoodsDetailModel.h
//  Life
//
//  Created by lanou on 16/5/27.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsDetailModel : BaseModel

//标题
@property (nonatomic,strong)NSString *title;
//描述
@property (nonatomic,strong)NSString *desc;
//图片地址
@property (nonatomic,strong)NSString *iconUrl;
//浏览量
@property (nonatomic,strong)NSNumber *browseVolume;
//更新时间
@property (nonatomic,strong)NSString *updateTime;
//物品价格
@property (nonatomic,strong)NSMutableDictionary *sourceData;

@end
