//
//  SimilarTableViewCell.h
//  Life
//
//  Created by lanou on 16/5/27.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimilarTableViewCellDelegate <NSObject>

- (void)pushSimilarDetailControllerWithID:(NSString *)similarID;

@end

@interface SimilarTableViewCell : UITableViewCell

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,assign)id<SimilarTableViewCellDelegate>delegate;

@end
