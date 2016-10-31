//
//  KindTableViewCell.m
//  Life
//
//  Created by lanou on 16/5/31.
//  Copyright © 2016年 Chen. All rights reserved.
//
//#import "EntryViewController.h"
#import "KindModel.h"
#import "KindCollectionViewCell.h"
#import "KindTableViewCell.h"
#import "URLRequestManager.h"
#import "NetWorkRequestManager.h"

@interface KindTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *arr;


@end


@implementation KindTableViewCell
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return  _arr;
}





-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(65, 20);
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 5, 2, 5);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsVerticalScrollIndicator = NO;
        
        [self.collectionView registerClass:[KindCollectionViewCell class] forCellWithReuseIdentifier:@"kindCollect"];
        [self addSubview:self.collectionView];
    }

    return self;
}

-(void)setUrlID:(NSString *)urlID{
    if (_urlID != urlID) {
        _urlID = urlID;
    }
   [self getDataArr];
}


//网络请求到数组
-(void)getDataArr{

    NSString *s = [Detail_URL stringByAppendingString:self.urlID];
    [NetWorkRequestManager requestWithType:GET urlString:s parDic:nil finish:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //cell 中title和image
            NSDictionary *fd = [dic valueForKey:@"data"];
           
            //分类标签 title
            NSArray *kindArr = [fd valueForKey:@"categories"];
            for (NSDictionary *dic in kindArr) {
                KindModel *kindDel = [[KindModel alloc]init];
                [kindDel setValuesForKeysWithDictionary:dic];
                [self.arr addObject:kindDel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });
    } error:^(NSError *error) {
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kindCollect" forIndexPath:indexPath];
    KindModel *model = self.arr[indexPath.row];
    cell.lab.text = model.title;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KindModel *model = self.arr[indexPath.row];
    [self.delegate passKindID:model._id];
    NSLog(@"%@",model._id);
}












- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





















@end
