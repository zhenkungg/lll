//
//  DataBaseBySelf.h
//  Life
//
//  Created by lanou on 16/6/1.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBaseBySelf : NSObject

@property (nonatomic,strong)FMDatabase *db;

//单例
+ (DataBaseBySelf *)defaultManager;

//创建表格
- (BOOL)createTableWithName:(NSString *)name;

//删除表格
- (BOOL)dropTableWithName:(NSString *)name;

//增
- (BOOL)insertIntoTable:(NSString *)table values:(NSArray *)values;

//删
- (BOOL)deleteFromTable:(NSString *)table values:(NSArray *)values;

//改
- (BOOL)updateTable:(NSString *)table values:(NSArray *)values;

//查
- (NSMutableArray *)selectFromTable:(NSString *)table data:(NSDictionary *)data;

- (NSMutableArray *)selectFromTable:(NSString *)table string:(NSString *)string;










@end
