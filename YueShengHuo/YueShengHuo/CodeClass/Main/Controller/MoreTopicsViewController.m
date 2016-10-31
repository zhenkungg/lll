//
//  MoreTopicsViewController.m
//  Life
//
//  Created by lanou on 16/6/1.
//  Copyright © 2016年 Chen. All rights reserved.
//
#import "EntryViewController.h"
#import "MoreTopicsViewController.h"
#import "TopicsModel.h"
#import "MoreTopicsTableViewCell.h"
#import "MoreTopicCollectionViewCell.h"
#import "ZWCollectionViewFlowLayout.h"

@interface MoreTopicsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZWwaterFlowDelegate>

@property (nonatomic,strong)UICollectionView *collectionview;
@property (nonatomic,strong)NSMutableArray *moreTopicsArr;
//请求结束的行数
@property (nonatomic,assign)NSInteger endNum;
//标签分类ID
@property (nonatomic,assign)NSInteger sequenceID;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation MoreTopicsViewController
- (NSMutableArray *)moreTopicsArr{
    if (!_moreTopicsArr) {
        _moreTopicsArr = [NSMutableArray array];
    }
    return _moreTopicsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多话题";
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 25  )];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popback) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    ZWCollectionViewFlowLayout *layout = [[ZWCollectionViewFlowLayout alloc]init];
    layout.degelate = self;
    
    self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionview];
    
    [self.collectionview registerNib:[UINib nibWithNibName:@"MoreTopicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"moreTopicsCollectionCell"];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getMoreTopicsData];
    
    self.collectionview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreTopicsData)];
}
- (void)popback{
    [self.navigationController popViewControllerAnimated:YES];
}
//得到所有标签
- (void)getMoreTopicsData{
    NSInteger startNum = _endNum;
    
    NSString *url = [moreTopicsURL stringByAppendingString:@"&end=20&start=0"];
    
    if (self.endNum != 0 && self.sequenceID != 0) {
        _endNum = startNum+20;
        url = [NSString stringWithFormat:@"%@&end=%ld&start=%ld&sequenceId=%ld",moreTopicsURL,_endNum,startNum,_sequenceID];
//        NSLog(@"%ld",_sequenceID);
    }
    
    //网络请求
    [URLRequestManager RequestType:@"GET" url:url body:nil data:^(NSData *data) {
        NSDictionary *moreTopicsDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (self.sequenceID == 0) {
            self.sequenceID = [moreTopicsDic[@"sequenceId"] integerValue];
        }
        self.endNum = [moreTopicsDic[@"end"] integerValue];
        
        NSArray *arr = moreTopicsDic[@"topics"];
        for (NSDictionary *dic in arr) {
            TopicsModel *model = [[TopicsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.moreTopicsArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionview reloadData];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.hud hideAnimated:YES];
            [self.collectionview.mj_footer endRefreshing];
        });
    } error:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.hud hideAnimated:YES];
            [self.hud removeFromSuperview];
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无网络" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark collectionview代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.moreTopicsArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoreTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreTopicsCollectionCell" forIndexPath:indexPath];
    
    TopicsModel *model = self.moreTopicsArr[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    cell.digest.text = model.digest;
    cell.title.text = [NSString stringWithFormat:@"#%@#",model.title];
    cell.heat.text = [NSString stringWithFormat:@"%ld",model.decayHeat];
    return cell;
}
- (CGFloat)ZWwaterFlow:(ZWCollectionViewFlowLayout *)waterFlow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach{
    TopicsModel *model = self.moreTopicsArr[indexPach.row];
    CGFloat h = [AdjustHeight heightForString:model.digest size:CGSizeMake(80, 10000) font:10];
    return h+150;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EntryViewController *vc = [[EntryViewController alloc]init];
    vc.topId = [self.moreTopicsArr[indexPath.row] valueForKey:@"_id"];
    vc.titl = [self.moreTopicsArr[indexPath.row] valueForKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didReceiveMemoryWarning {
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
