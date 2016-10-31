//
//  CategoryViewController.m
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "Categorys.h"
#import "CateModel.h"

#import "CategoryCollectionViewCell.h"
#import "HeadViewCollectionReusableView.h"

#import "EntryViewController.h"
#import "UIImageView+WebCache.h"
#import "CategoryViewController.h"
#import "RTArealocationView.h"

@interface CategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ArealocationViewDelegate>

@property(nonatomic,strong)NSMutableArray *titleArray;

@property(nonatomic,strong)NSMutableDictionary *dicDrray;

//判断是否上拉加载
@property(nonatomic,assign)BOOL isFooterRefresh;
//侧滑View
@property(nonatomic,strong)RTArealocationView *arealocationView;


@property(nonatomic,assign)NSInteger indexSection;

@end

@implementation CategoryViewController

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return  _titleArray;
}
-(NSMutableDictionary *)dicDrray{
    if (!_dicDrray) {
        _dicDrray = [[NSMutableDictionary alloc]init];
    }
    return _dicDrray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分类";
    self.navigationController.navigationBar.alpha = 1;
    
    //指示器
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.colleatView.showsVerticalScrollIndicator = NO;
    self.colleatView.backgroundColor =[UIColor whiteColor];
    self.colleatView.dataSource = self;
    self.colleatView
    .delegate = self;
    
    [self.colleatView registerNib:[UINib nibWithNibName:@"CategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"log"];
    [self.colleatView registerClass:[HeadViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"qw"];
    [self.colleatView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"as"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self getData];
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isFooterRefresh = NO;
        [self getData];
    }];
    [header setTitle:@"再往下一丢丢就好了" forState:MJRefreshStateIdle];
    [header setTitle:@"快放手,我要刷新啦" forState:MJRefreshStatePulling];
    [header setTitle:@"刷刷刷" forState:MJRefreshStateRefreshing];
    self.colleatView.mj_header = header;
    /*
     //上拉加载
     MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
     self.isFooterRefresh = YES;
     [self getData];
     }];
     [footer setTitle:@"加油，再往上一点点" forState:MJRefreshStateIdle];
     [footer setTitle:@"快放手，我要加东西啦" forState:MJRefreshStatePulling];
     [footer setTitle:@"加加加" forState:MJRefreshStateRefreshing];
     self.collectionView.mj_footer = footer;
     */
}





-(void)getData{
    [URLRequestManager RequestType:@"GET" url:categoryURL body:nil data:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [dic valueForKey:@"categories"];
        //判断是上拉还是下拉
        if (!self.isFooterRefresh) {
            [self.titleArray removeAllObjects];
            [self.dicDrray removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            Categorys *model = [[Categorys alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.titleArray addObject:model.title];
            NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:20];
            NSMutableArray *arr2 = [[NSMutableArray alloc]initWithCapacity:20];
            arr1 = model.relaCategories;
            for (NSDictionary *dit in arr1) {
                CateModel *del = [[CateModel alloc]init];
                [del setValuesForKeysWithDictionary:dit];
                [arr2 addObject:del];
            }
            [self.dicDrray setValue:arr2 forKey:model.title];
        }
        [self.dicDrray removeObjectForKey:@"两性"];
        [self.titleArray removeObjectAtIndex:6];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.colleatView
             
             reloadData];
            //        if (arr.count == 0) {
            //            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            //            self.collectionView.mj_footer.hidden = YES;
            //        }
            [self.colleatView.mj_header endRefreshing];
            //      [self.collectionView.mj_footer endRefreshing];
        });
    } error:^(NSError *error) {
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.dicDrray valueForKey:self.titleArray[section]] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCollectionViewCell *cell = [collectionView                                        dequeueReusableCellWithReuseIdentifier:@"log" forIndexPath:indexPath];
    NSArray *array = [self.dicDrray valueForKey:self.titleArray[indexPath.section]];
    NSString *s = [array[indexPath.item] valueForKey:@"iconUrl"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:s] placeholderImage:[UIImage imageNamed:@"qqPit.png"]];
    cell.categLab.text = [array[indexPath.item] valueForKey:@"title"];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 90);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 0, 20, 0);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeadViewCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"qw" forIndexPath:indexPath];
        view.textLabel.text = self.titleArray[indexPath.section];
        return view;
    }else{
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"as" forIndexPath:indexPath];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.2;
        return view;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EntryViewController *vc = [[EntryViewController alloc]init];
    NSArray *array = [self.dicDrray valueForKey:self.titleArray[indexPath.section]];
    vc.ID = [array[indexPath.item] _id];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 20);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 30);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
