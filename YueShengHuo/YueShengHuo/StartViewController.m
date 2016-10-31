//
//  StartViewController.m
//  YueShengHuo
//
//  Created by lanou on 16/10/29.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "StartViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "AppDelegate.h"
#define kIsFirstLauchApp @"kIsFirstLauchApp"
@interface StartViewController ()
@property (nonatomic, strong)MPMoviePlayerController *moviePlayer;

@end

@implementation StartViewController

- (void)setMoviePath:(NSString *)moviePath{
    _moviePath = [moviePath copy];
    // 停止之前的播放
    //    [self.moviePlayer stop];
    self.moviePlayer.view.backgroundColor = [UIColor cyanColor];
    // 设置播放的路径
    self.moviePlayer.contentURL = [[NSURL alloc] initFileURLWithPath:moviePath];
    [self.moviePlayer prepareToPlay];
    
    [self.moviePlayer play];
}

-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc]init];
        [_moviePlayer.view setFrame:self.view.bounds];
        //设置自动播放
        [_moviePlayer setShouldAutoplay:NO];
        //设置源类型 因为新特性一般都是播放本地的小视频 所以设置源类型为file
        _moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        //取消控制视图 如：播放暂停等
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:_moviePlayer.view];
        //监听播放完成
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinsihed) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    return _moviePlayer;
}
- (BOOL)isFirstLauchApp
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstLauchApp];
}- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}
- (void)playFinsihed{
    //进入按钮
    
    
    //添加进入按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(24, SCREENH -50, SCREEMW - 48, 48);
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 24;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.backgroundColor=(__bridge CGColorRef _Nullable)([UIColor greenColor]);
    [btn setTitle:@"进入应用" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    btn.hidden = NO;
    
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.moviePlayer.view addSubview:btn];
    [[NSNotificationCenter defaultCenter]postNotificationName:PlayFinishedNotify object:nil];
}
- (void)btnclick{
    //btn点击事件 执行block
    self.playFinished();
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
