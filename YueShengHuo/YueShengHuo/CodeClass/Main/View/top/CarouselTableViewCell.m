//
//  CarouselTableViewCell.m
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "CarouselTableViewCell.h"
#import "CarouselVIew.h"

@interface CarouselTableViewCell ()

@property (nonatomic,strong)CarouselVIew *carousel;

@end

@implementation CarouselTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.carousel = [[CarouselVIew alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        [self addSubview:self.carousel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self getImageArray];
    }
    return self;
}

//网络请求到图片
- (void)getImageArray{
    [URLRequestManager RequestType:@"GET" url:carouselURL body:nil data:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = dataDic[@"topics"];
        NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:6];
        for (NSDictionary *dic in dataArr) {
            TopicsModel *model = [[TopicsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [imageArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.carousel.array = imageArr;
        });
        
        
    } error:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
