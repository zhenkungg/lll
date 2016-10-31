//
//  ShowFindViewController.m
//  Life
//
//  Created by lanou on 16/5/25.
//  Copyright © 2016年 Chen. All rights reserved.
//
#import "FindDetailViewController.h"
#import "ShowFindViewController.h"
#import "ShowFindTableViewCell.h"
#import "CategoryModel.h"

@interface ShowFindViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

//判断是否上拉加载
@property (nonatomic,assign)BOOL isFooterRefresh;

@end

@implementation ShowFindViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-157) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"showfind"];
    
    //获取数据
    [self getDataArray];
    
    if (!self.stringURL) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showmbhud" object:nil];
    }
    
    //下拉刷新
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         self.isFooterRefresh = NO;
         [self getDataArray];
     }];
    [header setTitle:@"再往下一丢丢就好了" forState:MJRefreshStateIdle];
    [header setTitle:@"快放手,我要刷新啦" forState:MJRefreshStatePulling];
    [header setTitle:@"刷刷刷" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    //上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.isFooterRefresh = YES;
        [self getDataArray];
    }];
    [footer setTitle:@"加油,再往上一点点" forState:MJRefreshStateIdle];
    [footer setTitle:@"快放手,我要加东西啦" forState:MJRefreshStatePulling];
    [footer setTitle:@"加加加" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
}

//网络请求到图片
- (void)getDataArray{
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
    NSString *url = [NSString string];
    if (self.stringURL) {
        url = self.stringURL;
    }else{
        url = [NSString stringWithFormat:@"http://course2.jaxus.cn/api/v2/recommendation/hotCategory/%@/courses?start=%d&end=%d",self._id,start,end];
    }
    
    start = start + 20;
    
    [URLRequestManager RequestType:@"GET" url:url body:nil data:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = dataDic[@"courses"];
        
        //判断是上拉还是下拉
        if (!self.isFooterRefresh) {
            [self.dataArr removeAllObjects];
        }
        
        for (NSDictionary *dic in dataArr) {
            CategoryModel *model = [[CategoryModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenmbhud" object:nil];
            
            [self.tableView reloadData];
            
            if (dataArr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            }
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    } error:^(NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenmbhud" object:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowFindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showfind" forIndexPath:indexPath];
    CategoryModel *model = self.dataArr[indexPath.row];
    cell.title.text = model.title;
    NSString *imgURL = model.cover[@"imgUrl"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.collectNum.text = [NSString stringWithFormat:@"%@",model.likeNum];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindDetailViewController *vc = [[FindDetailViewController alloc]init];
    vc.ID = [self.dataArr[indexPath.row] _id];
    [self.navigationController pushViewController:vc animated:YES];

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
