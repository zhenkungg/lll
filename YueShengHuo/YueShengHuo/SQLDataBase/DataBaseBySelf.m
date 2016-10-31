//
//  DataBaseBySelf.m
//  Life
//
//  Created by lanou on 16/6/1.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "DataBaseBySelf.h"

@implementation DataBaseBySelf

//创建单例
+ (DataBaseBySelf *)defaultManager{
    static DataBaseBySelf *fmdb = nil;
    static dispatch_once_t once;
    if (!fmdb) {
        dispatch_once(&once, ^{
            fmdb = [[DataBaseBySelf alloc]init];
        });
    }
    return fmdb;
}
- (instancetype)init{
    if (self = [super init]) {
        
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *path = [doc stringByAppendingPathComponent:@"LoveLife.sqlite"];
        NSLog(@"%@",path);
        
        self.db = [FMDatabase databaseWithPath:path];
    }
    return self;
}

//创建表格
- (BOOL)createTableWithName:(NSString *)name{
    
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key AUTOINCREMENT not null, cateID text UNIQUE, title text,imgUrl text)",name];
        BOOL result = [self.db executeUpdate:sql];
        [self.db close];
        return result;
    }
    return NO;
}

//删除表格
- (BOOL)dropTableWithName:(NSString *)name{
    
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"drop table %@",name];
        BOOL result = [self.db executeUpdate:sql];
        [self.db close];
        return result;
    }
    return NO;
}

//增
- (BOOL)insertIntoTable:(NSString *)table values:(NSArray *)values{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@(cateID,title,imgUrl) values(?,?,?);",table];
        BOOL result = [self.db executeUpdate:sql withArgumentsInArray:values];
        [self.db close];
        return result;
    }
    return NO;
}

//删
- (BOOL)deleteFromTable:(NSString *)table values:(NSArray *)values{
    if ([self.db open]) {
        NSString *sql = @"";
        if (values.count == 0) {
            sql = [NSString stringWithFormat:@"delete from %@;",table];
        }else{
            sql = [NSString stringWithFormat:@"delete from %@ where cateID = ?;",table];
        }
        BOOL result = [self.db executeUpdate:sql withArgumentsInArray:values];
        [self.db close];
        return result;
    }
    return NO;
}

//改
- (BOOL)updateTable:(NSString *)table values:(NSArray *)values{
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set title = ? where cateID = ?;",table];
        BOOL result = [self.db executeUpdate:sql withArgumentsInArray:values];
        [self.db close];
        return result;
    }
    return NO;
}

//查
- (NSMutableArray *)selectFromTable:(NSString *)table data:(NSDictionary *)data{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSArray *values = [data allValues];
    
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = ?;",table,[data allKeys][0]];
        if (values.count == 0) {
            sql = [NSString stringWithFormat:@"select * from %@;",table];
        }
        FMResultSet *set = [self.db executeQuery:sql withArgumentsInArray:values];
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i = 0; i < set.columnCount; i++) {
                [dic setObject:[set objectForColumnIndex:i] forKey:[set columnNameForIndex:i]];
            }
            [arr addObject:dic];
        }
        [self.db close];
    }
    return arr;
}

//模糊查询
- (NSMutableArray *)selectFromTable:(NSString *)table string:(NSString *)string{
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where title like '%%%@%%';",table,string];
        
        FMResultSet *set = [self.db executeQuery:sql];
        while ([set next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i = 0; i < set.columnCount; i++) {
                [dic setObject:[set objectForColumnIndex:i] forKey:[set columnNameForIndex:i]];
            }
            [arr addObject:dic];
        }
        [self.db close];
    }
    return arr;
}


@end
