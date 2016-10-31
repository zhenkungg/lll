//
//  SearchResultModel.h
//  YueShengHuo
//
//  Created by lanou on 16/10/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "BaseModel.h"

@interface SearchResultModel : BaseModel

@property (nonatomic,strong)NSString *_id;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSMutableDictionary *cover;

@end
