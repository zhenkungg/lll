//
//  UIImage+MultiFormat.h
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MultiFormat)

+ (UIImage *)sd_imageWithData:(NSData *)data;

//修改内存泄露
+(UIImage *)compressImageWith:(UIImage *)image;
@end
