//
//  AppDelegate.m
//  YueShengHuo
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroAndGuideViewController.h"
#import "LBTabBarController.h"
#import "MainViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "WeiboSDK.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

//启动
#import "StartViewController.h"
#import "LaunViewController.h"

@interface AppDelegate ()
@property(nonatomic,strong)StartViewController *StartView;

@end

@implementation AppDelegate

-(StartViewController *)StartView{
    if (!_StartView) {
        _StartView =[[StartViewController alloc]init];
        _StartView.moviePath=[[NSBundle mainBundle]pathForResource:@"V" ofType:@"mp4"];
        _StartView.playFinished=^{
            UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:[[LBTabBarController alloc] init]];
            [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
        };
    }
    return _StartView;
}
-(void)start{
    LBTabBarController * vc = [[LBTabBarController alloc]init];
    self.window.backgroundColor = [UIColor colorWithRed:252/255.0f green:106/255.0f blue:8/225.0f alpha:1.0];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    UIView * backLayer = [[UIView alloc]initWithFrame:vc.view.bounds];
    backLayer.backgroundColor = [UIColor whiteColor];
    [vc.view addSubview:backLayer];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"Image"].CGImage;
    maskLayer.position = vc.view.center;
    maskLayer.bounds = CGRectMake(0, 0, 59, 59);
    vc.view.layer.mask = maskLayer;
    
    CAKeyframeAnimation * logoKeyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    logoKeyFrameAnimation.delegate = self;
    CGRect initRect = maskLayer.frame;
    CGRect beforeRect = CGRectMake(0, 0, 20, 20);
    CGRect afterRect = CGRectMake(0, 0, 2000, 2000);
    logoKeyFrameAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    logoKeyFrameAnimation.values = @[[NSValue valueWithCGRect:initRect],[NSValue valueWithCGRect:beforeRect],[NSValue valueWithCGRect:afterRect]];
    logoKeyFrameAnimation.fillMode = kCAFillModeForwards;
    logoKeyFrameAnimation.removedOnCompletion = NO;
    logoKeyFrameAnimation.duration = 1.0f;
    logoKeyFrameAnimation.beginTime = CACurrentMediaTime() + 1.0f;
    
    [maskLayer addAnimation:logoKeyFrameAnimation forKey:@"logoFirstAnimation"];
    vc.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    [UIView animateWithDuration:0.2 delay:1.75f options:UIViewAnimationOptionCurveLinear animations:^{
        backLayer.alpha = 0.0;
        vc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [backLayer removeFromSuperview];
    }];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstOpen"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstOpen"];
       self.window.rootViewController = self.StartView;
        
        
    }else{
        [self start];
        
    }
   
     [self.window makeKeyAndVisible];
     
    [ShareSDK registerApp:@"1241db7dac565"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                              redirectUri:@"http://www.sharesdk.cn"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeTencentWeibo:
                      //设置腾讯微博应用信息
                      [appInfo SSDKSetupTencentWeiboByAppKey:@"801307650"
                                                   appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                                 redirectUri:@"http://www.sharesdk.cn"];
                      break;
                      
                      
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:@"wx7e025bd33e1323f1"
                                            appSecret:@"72f5804737085e02b7f4d13fe3561af6"];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:@"1105367418"
                                           appKey:@"lQdk3d1FNfLYZIYf"
                                         authType:SSDKAuthTypeSSO];
                      break;
                  default:
                      break;
              }
          }];
    
    
    //在iOS8以后中须注册通知类型
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        //注册通知类型
        [application registerUserNotificationSettings:settings];
    }
    
    
    [UMSocialData setAppKey:@"573683cae0f55af2be0016d0"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx7e025bd33e1323f1" appSecret:@"72f5804737085e02b7f4d13fe3561af6" url:@"http://www.baidu.com"];
    
    [UMSocialQQHandler setQQWithAppId:@"1105366588" appKey:@"vOh0vTPuCuMjivw9" url:@"http://www.baidu.com"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954" secret:@"04b48b094faeb16683c32669824ebdad" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    return YES;
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
