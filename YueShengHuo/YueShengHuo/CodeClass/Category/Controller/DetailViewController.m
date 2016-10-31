//
//  DetailViewController.m
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "DetailViewController.h"
#import "CategoryView.h"
#import "FindDetailViewController.h"
#import "EntryViewController.h"
#import "EntryCategory.h"
#import "DetailCateCollectionViewCell.h"
@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (strong, nonatomic)UICollectionView *DetailCollectionView;

@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)NSString *url;

@property(nonatomic,assign)BOOL isFooterRefresh;


@end

@implementation DetailViewController
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 10 ;
    flowLayout.minimumInteritemSpacing = 8;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.DetailCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-130-28) collectionViewLayout:flowLayout];
    self.DetailCollectionView.dataSource = self;
    self.DetailCollectionView.delegate = self;
    self.DetailCollectionView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    self.DetailCollectionView.showsVerticalScrollIndicator = NO;
    [self.DetailCollectionView registerClass:[DetailCateCollectionViewCell class] forCellWithReuseIdentifier:@"log"];
    [self.view addSubview:self.DetailCollectionView];
    
    //获取数据
    [self getData];
    if (!self.url) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showDetailViewHUD" object:nil];
    }
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isFooterRefresh = NO;
        [self getData];
    }];
    [header setTitle:@"再往下一丢丢就好了" forState:MJRefreshStateIdle];
    [header setTitle:@"快放手,我要刷新啦" forState:MJRefreshStatePulling];
    [header setTitle:@"刷刷刷" forState:MJRefreshStateRefreshing];
    self.DetailCollectionView.mj_header = header;
    
    //上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.isFooterRefresh = YES;
        [self getData];
    }];
    [footer setTitle:@"加油，再往上一点点" forState:MJRefreshStateIdle];
    [footer setTitle:@"快放手，我要加东西啦" forState:MJRefreshStatePulling];
    [footer setTitle:@"加加加" forState:MJRefreshStateRefreshing];
    self.DetailCollectionView.mj_footer = footer;
}


//获取数据
-(void)getData{
    static int start = 0;
    static int end = 20;
    
    if (self.isFooterRefresh) {
        if (start == end) {
            end = end + 20;
        }
    }else{
        start = 0;
        end = 20;
    }
    self.url = [NSString string];
    NSString *hot = [NSString string];
    if (self.hotURL) {
        self.url = self.hotURL;
        if (self.isFooterRefresh) {
            if (self.topID == nil) {
                hot = @"http://course2.jaxus.cn/api/v2/course/category/hot-courses?categoryId=%@&end=%d&start=%d";
                self.url = [NSString stringWithFormat:hot,self.ID,end,start];
            }
            hot = @"http://course2.jaxus.cn/api/v2/course/topic/hot-courses?end=%d&start=%d&topicId=%@";
            self.url = [NSString stringWithFormat:hot,end,start,self.ID];
            
        }
    }else{
        self.url = self.neWithUrl;
        if (self.isFooterRefresh) {
            if (self.topID == nil) {
                self.url = [NSString stringWithFormat:@"http://course2.jaxus.cn/api/v2/course/category/new-courses?categoryId=%@&end=%d&start=%d",self.ID,end,start];
            }
            self.url = [NSString stringWithFormat:@"http://course2.jaxus.cn/api/v2/course/topic/new-courses?end=%d&start=%d&topicId=%@",end,start,self.ID];
        }
    }
    start = start+20;
    [URLRequestManager RequestType:@"GET" url:self.url body:nil data:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [dataDic valueForKey:@"courses"];
        //判断是上拉还是下拉
        if (!self.isFooterRefresh) {
            [self.dataArr removeAllObjects];
        }
        for (NSDictionary *dic in arr) {
            EntryCategory *model =[[EntryCategory alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenDetailViewHUD" object:nil];
            [self.DetailCollectionView reloadData];
            
            if (arr.count == 0) {
                [self.DetailCollectionView.mj_footer endRefreshingWithNoMoreData];
                self.DetailCollectionView.mj_footer.hidden = YES;
            }
            [self.DetailCollectionView.mj_header endRefreshing];
            [self.DetailCollectionView.mj_footer endRefreshing];
        });
    } error:^(NSError *error) {
    }];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailCateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"log" forIndexPath:indexPath ];
    cell.backgroundColor = [UIColor whiteColor];
    EntryCategory *model = self.dataArr[indexPath.item];
    cell.detailLabel.text = model.title;
    NSString *s = [model.cover valueForKey:@"imgUrl"];
    [cell.detailImageV sd_setImageWithURL:[NSURL URLWithString:s] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FindDetailViewController *vc = [[FindDetailViewController alloc]init];
    EntryCategory *model = self.dataArr[indexPath.item];
    vc.ID = model._id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 8, 10, 8);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-24)/2, (ScreenWidth-24)/2);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.frameY = scrollView.contentOffset.y;
    //
    if (self.frameY <= 150 && self.frameY > 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"jump" object:@(self.frameY)];
    }
    //
    if (self.frameY == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"jump" object:@(0)];
    }
    if (self.frameY > 150) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"jump" object:@(150.0)];
    }
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
