//
//  FindDetailViewController.m
//  发现
//
//  Created by lanou on 16/5/24.
//  Copyright © 2016年 Li. All rights reserved.
//
//详情请求地址

#define EdgeInsetsHeight 280

#import "CtypeOne.h"
#import "KindModel.h"
#import "TitleImageModel.h"
#import "DetailModel.h"
#import "MoreDetailModel.h"

#import "StrTableViewCell.h"
#import "MoreTableViewCell.h"
#import "TextTableViewCell.h"
#import "KindTableViewCell.h"
#import "ImageTableViewCell.h"
#import "TitleImageTableViewCell.h"

#import "AdjustHeight.h"
//#import "EntryViewController.h"
#import "UIImageView+WebCache.h"
#import "OtherFindDetailViewController.h"
#import "FindDetailViewController.h"

#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

#import "DataBaseBySelf.h"
#import "NetWorkRequestManager.h"

@interface FindDetailViewController ()<UITableViewDataSource,UITableViewDelegate,KindDelegate,UIAlertViewDelegate>
//存储内容里 text和img 的数组
@property(nonatomic,strong)NSMutableArray *Array;
//存储分类 标签
@property(nonatomic,strong)NSMutableArray *titleArray;
//存储详情最下面的条目
@property(nonatomic,strong)NSMutableArray *moreArray;

@property (strong, nonatomic)UITableView *detailTableView;


//头图片和标题
@property(nonatomic,strong)NSString *headTitle;
@property(nonatomic,strong)NSString *imgUrl;


@property(nonatomic,strong)UIImageView *imageVforHead;

@property(nonatomic,strong)NSString *kindID;

@property(nonatomic,strong)UILabel *titleForHead;

//图片宽高
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,assign)NSInteger width;

//收藏按钮
@property (nonatomic,strong)UIBarButtonItem *collectBarButtonItem;
@property (nonatomic,strong)UIButton *collectBtn;


@end

@implementation FindDetailViewController
-(NSMutableArray *)moreArray{
    if (!_moreArray) {
        _moreArray = [NSMutableArray array];
    }
    return _moreArray;
}
-(NSString *)headTitle{
    if (!_headTitle) {
        _headTitle = [[NSString alloc]init];
    }
    return _headTitle;
}
-(NSString *)imgUrl{
    if (!_imgUrl) {
        _imgUrl = [[NSString alloc]init];
    }
    return _imgUrl;
}
-(NSMutableArray *)Array{
    if (!_Array) {
        _Array = [NSMutableArray array];
    }
    return _Array;
}
-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataBaseBySelf defaultManager]createTableWithName:@"collect"];
    self.tabBarController.tabBar.hidden = NO;
    
    
    _width = 1;
    _height = 1;
    
//   self.title = @"详情";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.ID forKey:@"cateID"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[DataBaseBySelf defaultManager]selectFromTable:@"collect" data:dic]];
    
    //导航栏返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 26)];
    [backBtn setImage:[UIImage imageNamed:@"sback"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    //收藏按钮初始化
    _collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 26)];
    [_collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _collectBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_collectBtn];
    if (arr.count != 0) {

        [_collectBtn setImage:[UIImage imageNamed:@"collect1"] forState:UIControlStateNormal];
        

    }
    self.navigationItem.rightBarButtonItems = @[_collectBarButtonItem];
    
    [self getData];
    [self initTableView];
    [self initTitleImage];
    
    
        //内容里的text
    [self.detailTableView registerNib:[UINib nibWithNibName:@"TitleImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"log"];
    //内容里的img
    [self.detailTableView registerNib:[UINib nibWithNibName:@"TextTableViewCell" bundle:nil] forCellReuseIdentifier:@"re"];
    //分类标签
    [self.detailTableView registerClass:[KindTableViewCell class] forCellReuseIdentifier:@"bb"];
    //最下面的条目
    [self.detailTableView registerNib:[UINib nibWithNibName:@"MoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"cv"];
    //更多推荐
    [self.detailTableView registerNib:[UINib nibWithNibName:@"StrTableViewCell"  bundle:nil] forCellReuseIdentifier:@"qp"];
    

    
        
}

- (void)backViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


//跳转页面
-(void)releaseInfo{
    static MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.ID forKey:@"cateID"];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[DataBaseBySelf defaultManager]selectFromTable:@"collect" data:dic]];
    if (arr.count == 0) {
        [[DataBaseBySelf defaultManager] insertIntoTable:@"collect" values:@[self.ID,_headTitle,_imgUrl]];
        hud.label.text = @"收藏成功";
        
        [_collectBtn setImage:[UIImage imageNamed:@"collect1"] forState:UIControlStateNormal];
    
    }else{
        [[DataBaseBySelf defaultManager] deleteFromTable:@"collect" values:@[self.ID]];
        hud.label.text = @"取消收藏";
        
        [_collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    }
    [hud hideAnimated:YES afterDelay:1];
    
    
    
    
}


//加载首页图片
- (void)initTitleImage{
    self.imageVforHead = [[UIImageView alloc]initWithFrame:CGRectMake(0, -264, ScreenWidth, EdgeInsetsHeight)];
    
    self.imageVforHead.contentMode = UIViewContentModeScaleAspectFill;
    
    self.titleForHead = [[UILabel alloc]initWithFrame:CGRectMake(20, -50, ScreenWidth, 30)];
    self.titleForHead.textColor = RGBCOLOR(250, 69, 0, 1);
    self.titleForHead.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.titleForHead.textAlignment = NSTextAlignmentLeft;
    self.detailTableView.showsVerticalScrollIndicator = NO;
    [self.detailTableView addSubview:self.imageVforHead];
    [self.detailTableView addSubview:self.titleForHead];}
//加载tableView
- (void)initTableView{
    
    self.detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.contentInset = UIEdgeInsetsMake(EdgeInsetsHeight, 0, 0, 0);
    self.detailTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.detailTableView];
}


-(void)kindID:(NSString *)kindID{
    self.ID = kindID;

}


-(void)getData{
    NSString *s = [Detail_URL stringByAppendingString:self.ID];
[NetWorkRequestManager requestWithType:GET urlString:s parDic:nil finish:^(NSData *data) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //cell 中title和image
        NSDictionary *fd = [dic valueForKey:@"data"];
        NSArray *arr = [fd valueForKey:@"content"];
       for (NSDictionary *dic in arr) {
           TitleImageModel *tiMod = [[TitleImageModel alloc]init];
           [tiMod setValuesForKeysWithDictionary:dic];
           [self.Array addObject:tiMod];
           
        }
        //头 image title
        DetailModel *detailModel = [[DetailModel alloc]init];
        [detailModel setValuesForKeysWithDictionary:[dic valueForKey:@"data"]];
        self.headTitle = detailModel.title;
        self.imgUrl = [detailModel.cover valueForKey:@"imgUrl"];
        //分类标签 title
        NSArray *kindArr = [fd valueForKey:@"categories"];
        for (NSDictionary *dic in kindArr) {
            KindModel *kindDel = [[KindModel alloc]init];
            [kindDel setValuesForKeysWithDictionary:dic];
            [self.titleArray addObject:kindDel];
        }
        //最低层的条目
        NSArray *moreArr = [dic valueForKey:@"relateCourses"];
        for (NSDictionary *dic in moreArr) {
            MoreDetailModel *moreDel = [[MoreDetailModel alloc]init];
            [moreDel setValuesForKeysWithDictionary:dic];
            [self.moreArray addObject:moreDel];
        }
        
       dispatch_async(dispatch_get_main_queue(), ^{
           //隐藏指示器
           [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.detailTableView reloadData];
        [self.imageVforHead sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"qqPit.png"]];
           self.titleForHead.text = self.headTitle;
       });
        
    });
} error:^(NSError *error) {
}];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.moreArray.count == 0) {
        return 2;
    }
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        return 1;
    }else if (section == 1){
        return self.Array.count;
    }else if (section == 2){
        return 1;
    }
    return self.moreArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 100;
    }else if(indexPath.section == 1) {
        TitleImageModel *model = self.Array[indexPath.row];
        if ([self.Array[indexPath.row] cType] == 0) {
            CGFloat h = [AdjustHeight heightForString:model.text  size:CGSizeMake(320, 1000) font:15];
            return 20+h;
        }else if([self.Array[indexPath.row] cType] == 1){
            return ScreenWidth*_height/_width;

        }
    }else if (indexPath.section == 2){
        return 44;
    }else if(indexPath.section == 3){
 return 94;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        KindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bb" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.urlID = self.ID;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
      if([self.Array[indexPath.row] cType] == 0) {
          TextTableViewCell *tabCell = [tableView dequeueReusableCellWithIdentifier:@"re" forIndexPath:indexPath];
          TitleImageModel *del = self.Array[indexPath.row];
          tabCell.selectionStyle = UITableViewCellSelectionStyleNone;
          tabCell.textLab.text = del.text;
          return tabCell;
      }else{
          _height = [[[self.Array[indexPath.row] img] valueForKey:@"height"] integerValue];
          _width = [[[self.Array[indexPath.row] img]  valueForKey:@"width"] integerValue];
          
          TitleImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"log" forIndexPath:indexPath];

          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[self.Array[indexPath.row] img] [@"originUrl"]] placeholderImage:[UIImage imageNamed:@"qqPit.png"]];
          return cell;
      }
    }else if (indexPath.section == 2 && self.moreArray.count != 0){
        StrTableViewCell *strCell = [tableView  dequeueReusableCellWithIdentifier:@"qp" forIndexPath:indexPath];
        return strCell;
    }else if(indexPath.section == 3){
         MoreTableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"cv" forIndexPath:indexPath];
        NSString *s = [[self.moreArray[indexPath.row] cover] valueForKey: @"imgUrl"];
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [moreCell.moreImageV sd_setImageWithURL:[NSURL URLWithString:s] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        moreCell.moreLab.text = [self.moreArray[indexPath.row] title];
        return moreCell;
    }else{
        return nil;
    }
}


//-(void)passKindID:(NSString *)kindID{
//    self.kindID = kindID;
//    EntryViewController *vc = [[EntryViewController alloc]init];
//        vc.ID = self.kindID;
//        [self.navigationController pushViewController:vc animated:YES];
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        OtherFindDetailViewController *vc = [[OtherFindDetailViewController alloc]init];
           vc.Id= [self.moreArray[indexPath.row] _id];
    [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark scrollView代理协议实现方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //下拉放大效果
    CGFloat y = scrollView.contentOffset.y;
    CGFloat h = EdgeInsetsHeight + y;
    if (h < 0) {
        CGRect rect = self.imageVforHead.frame;
        rect.size.height = EdgeInsetsHeight-h;
        rect.origin.y = h-EdgeInsetsHeight;
        self.imageVforHead.frame = rect;
    }
    
    //设置导航栏随着滚动视图改变透明度
    CGFloat alpha = (y+264)/100;
    
    if (alpha >= 1) {
        //导航栏分享按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-32, 0, 32, 36)];
        [btn setImage:[UIImage imageNamed:@"highlightShare"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(shareSdk) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithCustomView:btn
                                  ];
        self.navigationItem.rightBarButtonItems = @[share,_collectBarButtonItem];
    }else{
        self.navigationItem.rightBarButtonItems = @[_collectBarButtonItem];
    }
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
}

//分享
- (void)shareSdk{
    //1、创建分享参数
    NSArray *imageArray = [NSArray array];
    if (self.imgUrl != nil) {
        imageArray = @[self.imgUrl];
    }else{
        imageArray = @[[UIImage imageNamed:@"dilireba.jpg"]];
    }
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.headTitle
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:self.headTitle
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }
         ];}
    
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
