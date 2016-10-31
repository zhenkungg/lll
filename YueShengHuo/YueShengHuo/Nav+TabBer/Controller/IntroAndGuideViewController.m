//
//  IntroAndGuideViewController.m
//  Intro&GuideView
//
//  Created by lanou on 16/5/9.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import "IntroAndGuideViewController.h"
#import "ABCIntroView.h"
#import "LBTabBarController.h"

@interface IntroAndGuideViewController ()<ABCIntroViewDelegate>



@end

@implementation IntroAndGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    ABCIntroView *abc = [[ABCIntroView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    abc.tag = 100;
    abc.delegate = self;
    [self.view addSubview:abc];

}
- (void)onDoneButtonPressed{
    [UIView animateWithDuration:1 animations:^{
        [self.view viewWithTag:100].alpha = 0;
    } completion:^(BOOL finished) {

        
        [UIView animateWithDuration:0.5 animations:^{
            LBTabBarController *view = [[LBTabBarController alloc]init];
            [[UIApplication sharedApplication].delegate window].rootViewController = view;
//            [self presentViewController:nav animated:YES completion:nil];
            
        }];
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
