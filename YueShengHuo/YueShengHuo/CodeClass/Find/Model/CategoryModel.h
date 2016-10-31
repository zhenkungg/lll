//
//  CategoryModel.h
//  Life
//
//  Created by lanou on 16/5/25.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "BaseModel.h"

@interface CategoryModel : BaseModel

//详情id
@property (nonatomic,strong)NSString *_id;
//图片地址
@property (nonatomic,strong)NSMutableDictionary *cover;
//标题
@property (nonatomic,strong)NSString *title;
//更新时间
@property (nonatomic,strong)NSString *updateTime;
//收藏数
@property (nonatomic,strong)NSNumber *likeNum;

@end
