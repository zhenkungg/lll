//
//  MoreTopicCollectionViewCell.h
//  Life
//
//  Created by lanou on 16/6/2.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTopicCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *digest;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *heat;
@property (strong, nonatomic) IBOutlet UIView *view;

@end
