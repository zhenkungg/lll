//
//  KindTableViewCell.h
//  Life
//
//  Created by lanou on 16/5/31.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KindDelegate <NSObject>

-(void)passKindID:(NSString *)kindID;

@end


@interface KindTableViewCell : UITableViewCell

@property(nonatomic,strong)NSString *urlID;
@property(nonatomic,weak)id<KindDelegate>delegate;

@end
