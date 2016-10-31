//
//  GoodsModel.h
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsModel : BaseModel

//物品id
@property (nonatomic,strong)NSString *_id;
//物品图片地址
@property (nonatomic,strong)NSString *coverUrl;
//物品标题
@property (nonatomic,strong)NSString *title;
//物品描述
@property (nonatomic,strong)NSString *desc;
//物品id
@property (nonatomic,strong)NSMutableDictionary *sourceData;

@end
