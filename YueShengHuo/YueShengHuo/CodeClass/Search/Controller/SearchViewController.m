//
//  SearchViewController.m
//  YueShengHuo
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "SearchViewController.h"
#import "HotSearchTableViewCell.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultModel.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@property (nonatomic,strong)UITableView *tableView;
//热门搜索词的数组
@property (nonatomic,strong)NSMutableArray *hotArr;
//搜索结果的数组
@property (nonatomic,strong)NSMutableArray *searchResultArr;
@property (nonatomic,assign)BOOL isSearchNewWord;

@property (nonatomic,strong)NSURLSessionDataTask *task;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation SearchViewController

- (NSMutableArray *)searchResultArr{
    if (!_searchResultArr) {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HotSearchTableViewCell class] forCellReuseIdentifier:@"hotCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchResultCell"];
    
    //得到热词数据
    [self getHotData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSearchData:) name:@"searchSomeWord" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeData) name:@"removeSearchView" object:nil];
    
    
    
}
//移除搜索结果
- (void)removeData{
    [self.task cancel];
    
    [self.searchResultArr removeAllObjects];
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = YES;
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.hud hideAnimated:YES];
    
}
//得到搜索结果
- (void)getSearchData:(NSNotification *)not{
    [self removeData];
    self.hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    self.hud.delegate = self;
    NSString *word = not.object;
    word = [word stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"UTF-8"]];
    
    //搜索新的关键字
    self.isSearchNewWord = YES;
    //搜索关键字
    [self searchWord:word];
    
}

#pragma mark 网络请求
//得到热词
- (void)getHotData{
    [self.tableView.mj_footer removeFromSuperview];
    [URLRequestManager RequestType:@"GET" url:hotSearchURL body:nil data:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.hotArr = [NSMutableArray arrayWithArray:dic[@"data"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        [self getHotData];
        NSLog(@"%@",error);
    }];
}
//搜索网络请求
- (void)searchWord:(NSString *)word{
    static int start = 0;
    static int end = 20;
    
    if (self.isSearchNewWord) {
        start = 0;
        end = 20;
    }
    
    NSString *url = searchWordURL;
    if (start == end) {
        end = end + 20;
        url = [NSString stringWithFormat:@"http://course2.jaxus.cn/api/v2/search?start=%d&searchType=both&end=%d&key=%@",start,end,word];
    }else{
        url = [url stringByAppendingString:word];
        
    }
    //    NSLog(@"%@",url);
    start = start + 20;
    
    URLRequestManager *manager = [[URLRequestManager alloc]init];
    self.task = [manager RequestType1:@"GET" url:url body:nil data:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = dic[@"courses"];
        if (self.isSearchNewWord) {
            [self.searchResultArr removeAllObjects];
        }
        for (NSDictionary *result in arr) {
            SearchResultModel *model = [[SearchResultModel alloc]init];
            [model setValuesForKeysWithDictionary:result];
            [self.searchResultArr addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.hud hideAnimated:YES];
            [self.tableView reloadData];
            
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                self.isSearchNewWord = NO;
                [self searchWord:word];
            }];
            
            if (arr.count == 0 || arr.count <= 4) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            }
            
            [self.tableView.mj_footer endRefreshing];
        });
        
    } error:^(NSError *error) {
        [self searchWord:word];
        NSLog(@"%@",error);
    }];
}

#pragma mark tableView代理协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.searchResultArr.count != 0) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.searchResultArr.count;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"log"];
    if (indexPath.section == 1) {
        HotSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
        cell.dataArr = [NSMutableArray arrayWithArray:self.hotArr];
        
        return cell;
    }else if (indexPath.section == 0){
        SearchResultTableViewCell *searchResultCell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
        searchResultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        SearchResultModel *model = self.searchResultArr[indexPath.row];
        [searchResultCell.resultImage sd_setImageWithURL:[NSURL URLWithString:model.cover[@"imgUrl"]]];
        searchResultCell.resultTitle.text = model.title;
        return searchResultCell;
    }else{
        return tableCell;
    }
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
//分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [UIView new];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-30, 20)];
    lab.font = [UIFont systemFontOfSize:18];
    lab.text = @"大家都在搜";
    [head addSubview:lab];
    return head;
}
//cell出现时的动画效果
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        CATransform3D ca1 = CATransform3DMakeTranslation(0, 100, 0);
        cell.layer.transform = ca1;
        
        [UIView animateWithDuration:0.3 animations:^{
            cell.layer.transform = CATransform3DIdentity;
        }];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showFindDetail" object:[self.searchResultArr[indexPath.row] _id]];
}


#pragma mark MBProgress隐藏时执行
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[self removeData];
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
