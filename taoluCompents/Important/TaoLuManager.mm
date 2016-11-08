//
//  TaoLuManager.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//


#define AppVerName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppVerCode [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppBundleID [[NSBundle mainBundle] bundleIdentifier]

#define SysName [[[UIDevice currentDevice] systemName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysVersion [[[UIDevice currentDevice] systemVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysModel [[[UIDevice currentDevice] model] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define CurrentLanguageAd [[NSLocale preferredLanguages] count] > 0 ? [[NSLocale preferredLanguages] objectAtIndex:0] : @""

#define AppGeneralInfoDict @{@"platform": @"ios", @"package" : AppBundleID, @"appvername":AppVerName, @"appvercode":AppVerCode, @"sys_name":SysName, @"sys_ver":SysVersion, @"sys_model":SysModel, @"sys_language":CurrentLanguageAd, @"taolu_version":@"1.0"}

#import <UIKit/UIKit.h>
#import "TaoLuManager.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


#import <TencentOpenAPI/TencentOAuth.h>     //腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"   //微信SDK头文件
#import "WeiboSDK.h"    //新浪微博SDK头文件

//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import <AFNetworking.h>
#import "AlertUtils.h"


@implementation TaoLuManager


static dispatch_once_t predict;
static TaoLuManager *manager = nil;

#pragma mark - 内部方法
+ (void)initShareSDK {
    
    [ShareSDK registerApp:SHARESDK_ID
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
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
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:SHARESDK_KEY_WEIBO
                                           appSecret:SHARESDK_SECREAT_WEIBO
                                         redirectUri:SHARESDK_REURL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:SHARESDK_KEY_WEIXIN
                                       appSecret:SHARESDK_SECREAT_WEIXIN];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:SHARESDK_KEY_QQ
                                      appKey:SHARESDK_SECREAT_QQ
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeTwitter:
                 [appInfo        SSDKSetupTwitterByConsumerKey:SHARESDK_KEY_TWITTER
                                                consumerSecret:SHARESDK_SECREAT_TWITTER
                                                   redirectUri:SHARESDK_REURL];    //回调地址
                 break;
                 
             default:
                 break;
         }
     }];
}
- (void)setTaskIndex:(NSInteger)taskIndex {   //重写set方法
    _taskIndex = taskIndex;
    [[NSUserDefaults standardUserDefaults]setObject:@(taskIndex) forKey:TAOLU_ORDER];
    YBLog(@"当前taskIndex %ld",(long)taskIndex);
}
+ (TaoLuManager *)shareManager {
    
    dispatch_once(&predict, ^{
        manager = [[self alloc]init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        if (![userDefaults boolForKey:TAOLU_ORDER]) {   //首次下载
            [userDefaults setObject:@(0) forKey:TAOLU_ORDER];
        }
        manager.taskIndex = [[userDefaults objectForKey:TAOLU_ORDER]integerValue];
        YBLog(@"查看路径 -->%@",NSHomeDirectory());
        manager.classNames = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController"];
    });
    
    return manager;
}
+ (void)updateConfig {

    for (NSString *language in [NSLocale preferredLanguages]) {
        YBLog(@"需要注意可能有问题，语言列表-->%@<--",language);
    }
    AFHTTPSessionManager *sessionManager;
    sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [sessionManager GET:@"http://192.168.0.20:9001/" parameters:AppGeneralInfoDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [TaoLuManager shareManager].taoLuJson = responseObject;
        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:LOCAL_JSON_NAME];
        [self initShareSDK];
        YBLog(@"网络获取成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([TaoLuManager shareManager].taoLuJson) return ;
        
        NSDictionary *localJson = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_JSON_NAME];
        if(localJson){
            [self shareManager].taoLuJson = localJson;
            [self initShareSDK];
        }else {
            //都没有的话，[TaoLuManager shareManager].taoLuJson 的值是nil，根据这个控制弹出
            YBLog(@"当前是空");
            [TaoLuManager shareManager].taskState(taskNone);
        }
    }];

}

+ (NSDictionary *)returnTaoLuJSON {
    return [TaoLuManager shareManager].taoLuJson;
}
#pragma mark - unity调用 等同

extern "C" {
    
    void __startTask(){
        
       
        UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow ]rootViewController];
       
        NSInteger index = [[TaoLuManager shareManager] taskIndex];
        NSArray * arr = [CONFIGJSON objectForKey:@"UITypeCoustom"];
        if ([[TaoLuManager shareManager] taoLuJson] == nil) {
            [TaoLuManager shareManager].taskState(taskNone);
            return;
        }
        if (index < [TaoLuManager shareManager].classNames.count) {
            
            if ([[arr objectAtIndex:index] integerValue]==0) {  //使用原生
                switch (index) {
                    case 0:
                        [AlertUtils shareAlert];
                        break;
                    case 1:
                        [AlertUtils commentAlert];
                        break;
                    case 2:
                        [AlertUtils sameToCoustom:index];
                        break;
                    case 3:
                        [AlertUtils downloadAlert];
                        break;
                    default:
                        break;
                }
                [TaoLuManager shareManager].taskIndex++;
            }else { //其他都使用自定义
                
                UIViewController *vc = [[NSClassFromString(manager.classNames[index]) alloc]init];
                [vc setDefinesPresentationContext:YES];
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [viewController presentViewController:vc animated:YES completion:nil];
                [TaoLuManager shareManager].taskIndex++;   //回调结束之后再去增加任务数，防止奖励bug
            }
            
        }else{
            [TaoLuManager shareManager].taskState(taskAllFinish);
        }
    }

}

extern "C" {
    
    void __resetTask(){
        NSLog(@"xcode 原生执行事件 置为0");
        
        [TaoLuManager shareManager].taskIndex = 0;
        
    }
    
}


+ (void)startTaskInViewController:(UIViewController *)viewController {
    
    if (viewController == nil) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    NSInteger index = [[self shareManager] taskIndex];
    NSArray * arr = [CONFIGJSON objectForKey:@"UITypeCoustom"];
    if ([[TaoLuManager shareManager] taoLuJson] == nil) {
        [TaoLuManager shareManager].taskState(taskNone);
        return;
    }
    if (index < [self shareManager].classNames.count) {
        
        if ([[arr objectAtIndex:index] integerValue]==0) {  //使用原生
            switch (index) {
                case 0:
                    [AlertUtils shareAlert];
                    break;
                case 1:
                    [AlertUtils commentAlert];
                    break;
                case 2:
                    [AlertUtils sameToCoustom:index];
                    break;
                case 3:
                    [AlertUtils downloadAlert];
                    break;
                default:
                    break;
            }
            [self shareManager].taskIndex++;
        }else { //其他都使用自定义
            UIViewController *vc = [[NSClassFromString(manager.classNames[index]) alloc]init];
            [vc setDefinesPresentationContext:YES];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [viewController presentViewController:vc animated:YES completion:nil];
            [self shareManager].taskIndex++;   //回调结束之后再去增加任务数，防止奖励bug
        }
        
    }else{
        [TaoLuManager shareManager].taskState(taskAllFinish);
    }
    
}

+ (void)resetTaskIndex{
    [self shareManager].taskIndex = 0;
}


#pragma mark - 导入unity后打开
/*
+ (void)sendMsgtoUnityWhenGetResult:(TaskState)state{
    
    switch (state) {
        case taskCancle:
            YBLog(@"任务取消");
            [UILabel showStats:@"任务取消" atView:[UIApplication sharedApplication].keyWindow];
            UnitySendMessage("Main Camera", "GetIosResult", "取消");
            break;
        case taskFaild:
            YBLog(@"任务失败");
            UnitySendMessage("Main Camera", "GetIosResult", "失败");
            break;
        case taskSuccees:
            YBLog(@"任务成功");
            [UILabel showStats:@"任务完成" atView:[UIApplication sharedApplication].keyWindow];
            UnitySendMessage("Main Camera", "GetIosResult", "成功");
            break;
        case taskAllFinish:
            YBLog(@"mobi");
            UnitySendMessage("Main Camera", "GetIosResult", "mobi");
            break;
        case taskNone:
            YBLog(@"无数据");
            UnitySendMessage("Main Camera", "GetIosResult", "无数据");
        default:
            break;
    }
    
}
*/
@end
