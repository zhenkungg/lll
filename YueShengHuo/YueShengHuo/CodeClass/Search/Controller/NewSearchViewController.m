//
//  NewSearchViewController.m
//  YueShengHuo
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "NewSearchViewController.h"
#import "SearchViewController.h"

@interface NewSearchViewController ()<UISearchBarDelegate>

//搜索框
@property (nonatomic,strong)UISearchBar *searchBar;
//搜索页面
@property (nonatomic,strong)SearchViewController *searchVC;

@end

@implementation NewSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"搜索";
    
    //添加搜索框
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    _searchBar.showsCancelButton = NO;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.view addSubview:_searchBar];
    
}

#pragma mark searchBar代理协议方法 - 搜索框
//显示搜索框
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        
        _searchBar.frame = CGRectMake(0, 20, ScreenWidth, 44);
        
        _searchBar.showsCancelButton = YES;
        
        UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        
        CGRect searchVCRect = self.searchVC.view.frame;
        searchVCRect.size.height = ScreenHeight;
        self.searchVC.view.frame = searchVCRect;
        
        
        [self.view addSubview:self.searchVC.view];
        
    }];
}
//取消显示搜索框
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden = NO;
        
        _searchBar.frame = CGRectMake(0, 0, ScreenWidth, 44);
        
        _searchBar.showsCancelButton = NO;
        [_searchBar resignFirstResponder];
        _searchBar.text = @"";
        
        [self.searchVC.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeSearchView" object:nil];
    }];
}
//按下键盘的搜索按钮时执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"searchSomeWord" object:self.searchBar.text];
    [searchBar resignFirstResponder];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setEnabled:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeSearchView" object:nil];
    }
}


#pragma mark scrollView代理方法 - 搜索框随滚动隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat h = scrollView.contentOffset.y;
    CGRect searbar = self.searchBar.frame;
    if (!self.navigationController.navigationBar.hidden) {
        if (h <= 300) {
            searbar.origin.y = 0;
        }
        if (h <= 344 && h > 300) {
            searbar.origin.y = 300-h;
        }
        if (h > 344) {
            searbar.origin.y = -44;
        }
        self.searchBar.frame = searbar;
    }
}

- (void)setUpNav
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}


- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
