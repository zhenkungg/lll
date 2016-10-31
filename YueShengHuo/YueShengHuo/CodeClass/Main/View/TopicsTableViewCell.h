//
//  TopicsTableViewCell.h
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TOMORETOPICS)();

@interface TopicsTableViewCell : UITableViewCell

@property (nonatomic,copy)TOMORETOPICS block;

@end
