//
//  SearchResultModel.h
//  Life
//
//  Created by lanou on 16/5/30.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "BaseModel.h"

@interface SearchResultModel : BaseModel

@property (nonatomic,strong)NSString *_id;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSMutableDictionary *cover;

@end
