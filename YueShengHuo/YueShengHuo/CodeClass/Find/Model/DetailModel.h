//
//  DetailModel.h
//  发现
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property(nonatomic,strong)NSMutableArray *categories;//存分类的数组
@property(nonatomic,strong)NSMutableArray *content;//title和image
@property(nonatomic,strong)NSDictionary *cover;//详情头的image
@property(nonatomic,strong)NSString *title;//详情头的标题
@end
