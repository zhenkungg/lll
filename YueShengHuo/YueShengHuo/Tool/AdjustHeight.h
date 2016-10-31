//
//  AdjustHeight.h
//  UILesson12-UITableViewCell
//
//  Created by lanou on 16/3/22.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AdjustHeight : NSObject
//封装类方法，用于返回字符串所占的高度
+ (CGFloat)heightForString:(NSString *)text size:(CGSize)size font:(CGFloat)font;
+ (CGFloat)widthForString:(NSString *)text size:(CGSize)size font:(CGFloat)font;

@end
