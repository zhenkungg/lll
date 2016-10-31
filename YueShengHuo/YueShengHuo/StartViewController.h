//
//  StartViewController.h
//  YueShengHuo
//
//  Created by lanou on 16/10/29.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREEMW [UIScreen mainScreen].bounds.size.width
#define PlayFinishedNotify @"PlayFinishedNotify"

@interface StartViewController : UIViewController
@property (nonatomic, copy) void (^playFinished)();
@property (nonatomic, strong) NSString *moviePath;//视频路径

@end
