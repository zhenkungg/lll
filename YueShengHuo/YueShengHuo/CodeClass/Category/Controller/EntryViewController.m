//
//  EntryViewController.m
//  YueShengHuo
//
//  Created by lanou on 16/10/31.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "EntryViewController.h"
#import "Model.h"
#import "CategoryView.h"
#import "EntryCategoryHead.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"


@interface EntryViewController ()
@property(nonatomic,strong)NSMutableArray *categoryArr;
@property(nonatomic,strong)NSString *headTitle;
@property(nonatomic,strong)NSString *headImgURL;

@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *headLab;

@property(nonatomic,assign)CGFloat frameY;

@property(nonatomic,strong)CategoryView *findView;
@end

@implementation EntryViewController

-(NSMutableArray *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"分类列表";
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 26)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"sback"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(popback) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    //指示器
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMBProgressHUD) name:@"showDetailViewHUD" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenMBProgressHUD) name:@"hiddenDetailViewHUD" object:nil];
    Model *model1 = [[Model alloc]init];
    Model *model2 = [[Model alloc]init];
    model1.title = @"最热";
    model2.title = @"最新";
    if (self.ID != nil) {
        model1._id = self.ID;
        model2._id = self.ID;
    }else{
        model1.topId = self.topId;
        model2.topId = self.topId;
    }
    [self.categoryArr addObject:model1];
    [self.categoryArr addObject:model2];
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [self.view addSubview:self.headImage];
    self.headLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, ScreenWidth, 30)];
    self.headLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.headLab.textColor = RGBCOLOR(250, 69, 0, 1);
    self.headLab.textAlignment = NSTextAlignmentLeft;
    
    [self.headImage addSubview:self.headLab];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getData];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tongzhi:) name:@"jump" object:nil];
}


- (void)popback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showMBProgressHUD{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hiddenMBProgressHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)tongzhi:(NSNotification *)Dictt{
    self.frameY = [Dictt.object doubleValue];
    if(self.frameY <= 150 && self.frameY >= 0 && self.headImgURL != nil) {
        self.findView.frame = CGRectMake(0, 150-self.frameY, ScreenWidth, ScreenHeight);
        self.headImage.frame = CGRectMake(0, -self.frameY, ScreenWidth, 150);
        if (self.frameY == 0) {
            self.headImage.frame = CGRectMake(0, 0, ScreenWidth, 150);
            self.findView.frame = CGRectMake(0, 150, ScreenWidth, ScreenHeight);
        }
    }else{
        self.headImage.frame = CGRectMake(0, -150, ScreenWidth, 150);
        self.findView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
}
-(void)getData{
    NSString *path = [NSString string];
    NSString *s = [NSString string];
    if (self.ID != nil) {
        //分类接口地址
        path = categorykindURL;
        s = [path stringByAppendingString:self.ID];
    }else{
        //标签地址
        path = topCategoryURL;
        s = [path stringByAppendingString:self.topId];
    }
    [URLRequestManager RequestType:@"GET" url:s body:nil data:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = [NSDictionary dictionary];
        if (self.ID != nil) {
            dataDic = [dic valueForKey:@"category"];
        }else{
            dataDic = [dic valueForKey:@"topic"];
        }
        EntryCategoryHead *headmodel = [[EntryCategoryHead alloc]init];
        [headmodel setValuesForKeysWithDictionary:dataDic];
        self.headTitle = headmodel.title;
        self.headImgURL = headmodel.detailUrl;
        NSString *title = @"#TITLE#";
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.headLab.text = [title stringByReplacingOccurrencesOfString:@"TITLE" withString:self.headTitle];
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.headImgURL] placeholderImage:[UIImage imageNamed:@"qqPit"]];
            
            self.findView = [[CategoryView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, ScreenHeight)];
            self.findView.viewControl = self;
            self.findView.array = [self.categoryArr mutableCopy];
            
            if (!self.headImgURL) {
                [self.headImage removeFromSuperview];
                self.findView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            }
            [self.view addSubview:self.findView];
        });
        
    } error:^(NSError *error) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
