//
//  ShowFindTableViewCell.h
//  Life
//
//  Created by lanou on 16/5/25.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowFindTableViewCell : UITableViewCell

/**图片*/
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
//标题
@property (strong, nonatomic) IBOutlet UILabel *title;
//收藏数
@property (strong, nonatomic) IBOutlet UILabel *collectNum;
@property (strong, nonatomic) IBOutlet UIView *collectView;

@end
