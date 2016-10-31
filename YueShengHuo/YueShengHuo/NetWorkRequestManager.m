//
//  NetWorkRequestManager.m
//  leisure-01
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 Li. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager

-(void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)errorMessage{
    
    NSURL *url = [NSURL URLWithString:urlString];
    //创建可变的URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (type == POST) {
        //请求方式
        [request setHTTPMethod:@"POST"];
        if (parDic.count > 0) {
            NSData *data = [self parDicToDataWithDic:parDic];
            //设置请求参数的body体
            [request setHTTPBody:data];
        }
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            finish(data);
        }else{
            errorMessage(error);
        }
   }];
    //开启任务
    [task resume];

}
+(void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)errorMessage{

    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc]init];
    [manager requestWithType:type urlString:urlString parDic:parDic finish:finish error:errorMessage];
    
    

}
//把参数字典转为POST请求所需要的参数体
-(NSData *)parDicToDataWithDic:(NSDictionary *)dic{
    NSMutableArray *array = [NSMutableArray array];
    //遍历字典得到每一个键，得到所有的Key = Value类型的字符串
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [array addObject:str];
    }
    //数组里所有的key=Value的字符串通过&符号连接
    NSString *parString = [array componentsJoinedByString:@"&"];
    return [parString dataUsingEncoding:NSUTF8StringEncoding];
}
@end
