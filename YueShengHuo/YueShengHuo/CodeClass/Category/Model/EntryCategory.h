//
//  EntryCategory.h
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntryCategory : NSObject
@property(nonatomic,strong)NSString *_id;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSMutableArray *cover;
@end
