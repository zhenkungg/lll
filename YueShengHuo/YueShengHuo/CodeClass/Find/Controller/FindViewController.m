//
//  FindViewController.m
//  Life
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "FindViewController.h"
#import "FindView.h"
#import "CategoryModel.h"

@interface FindViewController ()

@property (nonatomic,strong)NSMutableArray *categoryArr;
@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation FindViewController

- (NSMutableArray *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMBProgressHUD) name:@"showmbhud" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenMBProgressHUD) name:@"hiddenmbhud" object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getDataArray];
}
- (void)showMBProgressHUD{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)hiddenMBProgressHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
//网络请求到图片
- (void)getDataArray{
    
    CategoryModel *model = [[CategoryModel alloc]init];
    model.title = @"推荐教程";
    [self.categoryArr addObject:model];
    
    NSString *url = [NSString stringWithFormat:@"http://course2.jaxus.cn/api/v2/discover"];
    [URLRequestManager RequestType:@"GET" url:url body:nil data:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArr = dataDic[@"categories"];
        for (NSDictionary *dic in dataArr) {
            CategoryModel *model = [[CategoryModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            if ([model.title isEqualToString:@"两性"]) {
                
            }else{
                [self.categoryArr addObject:model];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            FindView *findView = [[FindView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            findView.viewControl = self;
            findView.arr = [self.categoryArr mutableCopy];
            [self.view addSubview:findView];
        });
        
        
    } error:^(NSError *error) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.hud hideAnimated:YES];
            [self.hud removeFromSuperview];
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无网络" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }];
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
