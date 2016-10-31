//
//  URLRequestManager.m
//  Leisure-01
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "URLRequestManager.h"

@implementation URLRequestManager

+ (void)RequestType:(NSString *)type url:(NSString *)url body:(NSDictionary *)body data:(RequestData)rdata error:(RequestError)rerror{
    
    URLRequestManager *req = [[URLRequestManager alloc]init];
    [req RequestType:type url:url body:body data:rdata error:rerror];
    
}
- (void)RequestType:(NSString *)type url:(NSString *)url body:(NSDictionary *)body data:(RequestData)rdata error:(RequestError)rerror{
    
    NSURL *urls = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urls];
    
    
    if ([type isEqualToString:@"POST"]) {
        [request setHTTPMethod:@"POST"];
        if (body.count > 0) {
            NSData *bbody = [self analysisDictionary:body];
            request.HTTPBody = bbody;
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            rdata(data);
        }else{
            rerror(error);
        }
    }];
    
    [task resume];

}

- (NSURLSessionDataTask *)RequestType1:(NSString *)type url:(NSString *)url body:(NSDictionary *)body data:(RequestData)rdata error:(RequestError)rerror{
    NSURL *urls = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urls];
    
    
    if ([type isEqualToString:@"POST"]) {
        [request setHTTPMethod:@"POST"];
        if (body.count > 0) {
            NSData *bbody = [self analysisDictionary:body];
            request.HTTPBody = bbody;
        }
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            rdata(data);
        }else{
            rerror(error);
        }
    }];
    
    [task resume];
    
    return task;
}







- (NSData *)analysisDictionary:(NSDictionary *)dic{
    NSMutableArray *array = [NSMutableArray array];
    for (id key in dic) {
        NSString *s = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [array addObject:s];
    }
    
    NSString *body = [array componentsJoinedByString:@"&"];
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
    
}

@end
