//
//  MainViewController.m
//  YueShengHuo
//
//  Created by lanou on 16/10/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "MainViewController.h"
#import "CarouselVIew.h"
#import "CarouselTableViewCell.h"
#import "TopicsTableViewCell.h"
#import "GoodsTableViewCell.h"
#import "GoodsModel.h"
#import "SectionView.h"


@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *goodsArr;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation MainViewController

//懒加载
- (NSMutableArray *)goodsArr{
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加首页视图
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[CarouselTableViewCell class] forCellReuseIdentifier:@"carouseCell"];
    [self.tableView registerClass:[TopicsTableViewCell class] forCellReuseIdentifier:@"topicsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodsCell"];
 
    //添加下拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getDataArray];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    //加载数据
    [self getDataArray];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}


//网络请求到图片
- (void)getDataArray{
    static int startNum = 0;
    static int endNum = 20;
    
    if (startNum == endNum) {
        endNum += 20;
    }
    NSString *url = [NSString stringWithFormat:@"http://course2.jaxus.cn/api/v2/mall/subject?start=%d&end=%d",startNum,endNum];
    startNum += 20;
    
    [URLRequestManager RequestType:@"GET" url:url body:nil data:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = dataDic[@"data"];
        for (NSDictionary *dic in dataArr) {
            GoodsModel *model = [[GoodsModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.desc = dic[@"description"];
            [self.goodsArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.tableView.mj_footer.hidden = NO;
            if (dataArr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.hud hideAnimated:YES];
        });
    } error:^(NSError *error) {
        
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

#pragma mark tableView代理协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return self.goodsArr.count;
        default:
            return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CarouselTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carouseCell" forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 1){
        TopicsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicsCell" forIndexPath:indexPath];
        cell.block = ^{
//            self.hidesBottomBarWhenPushed = YES;
//            MoreTopicsViewController *more = [[MoreTopicsViewController alloc]init];
//            [self.navigationController pushViewController:more animated:YES];
//            self.hidesBottomBarWhenPushed = NO;
        };
        return cell;
     }
       else if (indexPath.section == 2){
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
        GoodsModel *model = self.goodsArr[indexPath.row];
        
        cell.model = model;
    
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sell"];
    }
    return cell;
}
//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }
    else if (indexPath.section == 1) {
        return 100;
    }
    else if (indexPath.section == 2){
        return 210;
    }
    return 100;
}
//返回分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 40;
    }
    return 0;
    
}
//返回分区尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
//分区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        SectionView *section = [[SectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        return section;
    }
    return nil;
}
//选中对应的cell跳转到详情页
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    self.hidesBottomBarWhenPushed = YES;
//    GoodsDetailViewController *detail = [[GoodsDetailViewController alloc]init];
//    GoodsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    detail.topImage = cell.imageV.image;
//    detail.topModel = self.goodsArr[indexPath.row];
//    
//    [self.navigationController pushViewController:detail animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
    
    CGRect tab = self.tableView.frame;
    if (tab.origin.y == 64) {
        self.navigationController.navigationBarHidden = YES;
        self.tabBarController.tabBar.hidden = YES;
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
