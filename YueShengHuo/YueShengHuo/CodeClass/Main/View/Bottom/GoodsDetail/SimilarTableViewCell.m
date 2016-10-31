//
//  SimilarTableViewCell.m
//  Life
//
//  Created by lanou on 16/5/27.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "SimilarTableViewCell.h"
#import "SimilarCollectionViewCell.h"
#import "GoodsModel.h"
#import "GoodsDetailViewController.h"

@interface SimilarTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation SimilarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(150, 120);
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 5);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerNib:[UINib nibWithNibName:@"SimilarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"similarCell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    return self;
}
#pragma mark collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SimilarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"similarCell" forIndexPath:indexPath];
    GoodsModel *model = self.dataArray[indexPath.row];
    [cell.similarImage sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.similarTitle.text = model.title;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate pushSimilarDetailControllerWithID:[self.dataArray[indexPath.row] _id]];
}

//给数组赋值
- (void)setDataArray:(NSArray *)dataArray{
    if (self.dataArray != dataArray) {
        _dataArray = [dataArray copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
