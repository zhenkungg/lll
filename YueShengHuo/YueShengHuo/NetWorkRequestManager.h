//
//  NetWorkRequestManager.h
//  leisure-01
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 Li. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义枚举 用来识别请求的类型
typedef NS_ENUM(NSInteger,RequestType){
    GET,
    POST
};

//网络请求完成的block
typedef void (^RequestFinish)(NSData *data);

//网络请求失败的block
typedef void (^RequestError)(NSError *error);

@interface NetWorkRequestManager : NSObject


//对象方法
-(void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)errorMessage;



//类方法
+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)errorMessage;

@end
