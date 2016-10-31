//
//  TopicsTableViewCell.m
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "TopicsTableViewCell.h"
#import "TopicsCollectionViewCell.h"
#import "TopicsModel.h"

@interface TopicsTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
//数据源
@property (nonatomic,strong)NSMutableArray *arr;

@end

@implementation TopicsTableViewCell
- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(60, 90);
        layout.sectionInset = UIEdgeInsetsMake(15, 5, 15, 5);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 20;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.collectionView registerClass:[TopicsCollectionViewCell class] forCellWithReuseIdentifier:@"topicsCollectionCell"];
        
        [self addSubview:self.collectionView];
        
        [self getDataArray];
    }
    return self;
}

//网络请求到图片
- (void)getDataArray{
    [URLRequestManager RequestType:@"GET" url:topicsURL body:nil data:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = dataDic[@"topics"];
        for (NSDictionary *dic in dataArr) {
            TopicsModel *model = [[TopicsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.arr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopicsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topicsCollectionCell" forIndexPath:indexPath];
    if (indexPath.row == self.arr.count) {
        cell.imageV.image = [UIImage imageNamed:@"moreTopics"];
        cell.lab.text = @"更多话题";
        return cell;
    }
    TopicsModel *model = self.arr[indexPath.row];
    cell.lab.text = model.title;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.arr.count) {
        self.block();
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showTopicsDetail" object:self.arr[indexPath.row]];
    }
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
