//
//  URLRequestManager.h
//  Leisure-01
//
//  Created by lanou on 16/5/10.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestData)(NSData *data);

typedef void (^RequestError)(NSError *error);

@interface URLRequestManager : NSObject

+ (void)RequestType:(NSString *)type url:(NSString *)url body:(NSDictionary *)body data:(RequestData)rdata error:(RequestError)rerror;

- (void)RequestType:(NSString *)type url:(NSString *)url body:(NSDictionary *)body data:(RequestData)rdata error:(RequestError)rerror;

- (NSURLSessionDataTask *)RequestType1:(NSString *)type url:(NSString *)url body:(NSDictionary *)body data:(RequestData)rdata error:(RequestError)rerror;

@end
