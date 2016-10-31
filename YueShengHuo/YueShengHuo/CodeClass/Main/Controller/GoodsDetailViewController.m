//
//  GoodsDetailViewController.m
//  Life
//
//  Created by lanou on 16/5/26.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsDetailTableViewCell.h"
#import "GoodsShowTableViewCell.h"
#import "GoodsDetailModel.h"
#import "GoodsModel.h"
#import "SimilarTableViewCell.h"
#import "TaobaoViewController.h"

#define EdgeInsetsHeight 164

@interface GoodsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,SimilarTableViewCellDelegate>

@property (nonatomic,strong)UITableView *tableView;
//下拉图片
@property (nonatomic,strong)UIImageView *titleImage;
//详情数组
@property (nonatomic,strong)NSMutableArray *detailArr;
//标题和简介的字典
@property (nonatomic,strong)NSMutableDictionary *subjectDic;
//更多推荐的数组
@property (nonatomic,strong)NSMutableArray *similarArr;
//标题label
@property (nonatomic,strong)UILabel *titlelab;
//物品id
@property (nonatomic,strong)NSString *goodsID;

@end

@implementation GoodsDetailViewController
//懒加载
- (NSMutableArray *)similarArr{
    if (!_similarArr) {
        _similarArr = [NSMutableArray array];
    }
    return _similarArr;
}
- (NSMutableDictionary *)subjectDic{
    if (!_subjectDic) {
        _subjectDic = [NSMutableDictionary dictionary];
    }
    return _subjectDic;
}
- (NSMutableArray *)detailArr{
    if (!_detailArr) {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 26)];
    [backBtn setImage:[UIImage imageNamed:@"sback"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(popback) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self initTableView];
    [self initTitleImage];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    
}
- (void)popback{
    
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelay:0.375];
//    [self.navigationController popViewControllerAnimated:NO];
//    [UIView commitAnimations];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//加载首页图片
- (void)initTitleImage{
    self.titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -EdgeInsetsHeight, ScreenWidth, EdgeInsetsHeight)];
    self.titleImage.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([_topImage isEqual:[UIImage imageNamed:@"placeholder"]]) {
        [self.titleImage sd_setImageWithURL:[NSURL URLWithString:_topModel.coverUrl]];
    }else{
        self.titleImage.image = _topImage;
    }
    
    
    if ([_topImage isEqual:[UIImage imageNamed:@"find"]]) {
        [self.titleImage sd_setImageWithURL:[NSURL URLWithString:_topModel.coverUrl]];
    }
    
    
    self.titlelab = [[UILabel alloc]initWithFrame:CGRectMake(10, -30, ScreenWidth, 30)];
    self.titlelab.text = _topModel.title;
    self.titlelab.textColor = [UIColor whiteColor];
    self.titlelab.font = [UIFont systemFontOfSize:15];
    
    [self.tableView addSubview:self.titleImage];
    [self.tableView addSubview:self.titlelab];

}

//加载tableView
- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(EdgeInsetsHeight, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodsDetail"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodsShow"];
    [self.tableView registerClass:[SimilarTableViewCell class] forCellReuseIdentifier:@"similar"];
    
    [self getDataArray];
}

//网络请求到图片
- (void)getDataArray{
    
    if (_topModel) {
        _goodsID = _topModel._id;
    }
    NSString *url = [goodsDetailURL stringByAppendingString:self.goodsID];
    [URLRequestManager RequestType:@"GET" url:url body:nil data:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = dataDic[@"commodities"];
        
        [self.detailArr removeAllObjects];
        [self.similarArr removeAllObjects];
        [self.subjectDic removeAllObjects];
        
        for (NSDictionary *dic in dataArr) {
            GoodsDetailModel *model = [[GoodsDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.desc = dic[@"description"];
            [self.detailArr addObject:model];
        }
        self.subjectDic = [NSMutableDictionary dictionaryWithDictionary:dataDic[@"subject"]];
        
        NSArray *relative = dataDic[@"relativeSubjects"];
        for (NSDictionary *relativeDic in relative) {
            GoodsModel *model = [[GoodsModel alloc]init];
            [model setValuesForKeysWithDictionary:relativeDic];
            [self.similarArr addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_topModel == nil) {
                [self.titleImage sd_setImageWithURL:[NSURL URLWithString:self.subjectDic[@"bannerUrl"]]];
                self.titlelab.text = self.subjectDic[@"title"];
            }
            
            [self.tableView reloadData];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tableView.contentOffset = CGPointMake(0, -180);
        });
        
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}

#pragma mark tableView代理协议实现方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.detailArr.count == 0) {
        return 0;
    }
    if (self.similarArr.count == 0) {
        return 2;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.detailArr.count;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GoodsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsDetail" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.content.text = self.subjectDic[@"description"];
        return cell;
    }else if (indexPath.section == 1){
        GoodsShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsShow" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        GoodsDetailModel *model = self.detailArr[indexPath.row];
        
        cell.model = model;
        cell.titleNum.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        
        return cell;
    }else{
        SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"similar" forIndexPath:indexPath];
        cell.dataArray = self.similarArr;
        cell.delegate = self;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //根据文字自适应高度
        CGFloat h = [AdjustHeight heightForString:self.subjectDic[@"description"] size:CGSizeMake(ScreenWidth, 10000) font:12];
        return h+50;
    }else if (indexPath.section == 1){
        //根据文字自适应高度
        GoodsDetailModel *model = self.detailArr[indexPath.row];
        CGFloat h = [AdjustHeight heightForString:model.desc size:CGSizeMake(ScreenWidth, 10000) font:13];
        return 330+h;
    }else{
        return 130;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
        lab.text = @"猜你稀罕";
        UIView *v = [UIView new];
        [v addSubview:lab];
        return v;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        //跳转到淘宝购物页面
        TaobaoViewController *taobao = [[TaobaoViewController alloc]init];
        GoodsDetailModel *model = self.detailArr[indexPath.row];
        taobao.taobaoURL = [NSString stringWithFormat:@"https://detail.tmall.com/item.htm?ali_refid=a3_430406_1007:1104604483:N:50010850_0_100:ef0b4d4d44c51a9548722d6748efc883&ali_trackid=1_ef0b4d4d44c51a9548722d6748efc883&spm=a21bo.50862.201874-sales.7.ZktmmK&skuId=85824735444&id=%@",model.sourceData[@"goodsId"]];
        
        self.hidesBottomBarWhenPushed = YES;
        
//        DDHNavigationControllerDelegate *dele = [[DDHNavigationControllerDelegate alloc]init];
//        self.navigationController.delegate = dele;
//        dele.transitionType = 0;
        [self.navigationController pushViewController:taobao animated:YES];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
}


#pragma mark similarCell代理协议实现跳转页面
- (void)pushSimilarDetailControllerWithID:(NSString *)similarID{
    
    self.goodsID = similarID;
    self.topModel = nil;
    [self getDataArray];

}

#pragma mark scrollView代理协议实现方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //下拉放大效果
    CGFloat y = scrollView.contentOffset.y;
    CGFloat h = EdgeInsetsHeight + y;
    if (h < 0) {
        CGRect rect = self.titleImage.frame;
        rect.size.height = EdgeInsetsHeight-h;
        rect.origin.y = h-EdgeInsetsHeight;
        self.titleImage.frame = rect;
    }
    
    //设置导航栏随着滚动视图改变透明度
    CGFloat alpha = (y+164)/100;
    
    if (alpha >= 1) {
        
        //导航栏标题
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        lab.text = self.subjectDic[@"title"];
        lab.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = lab;
    }else{
        [self.navigationItem.titleView removeFromSuperview];
    }
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];

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
