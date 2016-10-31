//
//  DetailViewController.h
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property(nonatomic,strong)NSString *ID;
//标签Id
@property(nonatomic,strong)NSString *topID;
@property(nonatomic,strong)NSString *hotURL;
@property(nonatomic,strong)NSString *neWithUrl;

@property(nonatomic,assign)CGFloat frameY;
@end
