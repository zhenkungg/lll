//
//  AdjustHeight.m
//  UILesson12-UITableViewCell
//
//  Created by lanou on 16/3/22.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "AdjustHeight.h"

@implementation AdjustHeight

+ (CGFloat)heightForString:(NSString *)text size:(CGSize)size font:(CGFloat)font{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGFloat h = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    return h;
}
+ (CGFloat)widthForString:(NSString *)text size:(CGSize)size font:(CGFloat)font{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGFloat w = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
    return w;
}


@end
