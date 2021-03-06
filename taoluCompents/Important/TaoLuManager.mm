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
#import <AFNetworking/AFNetworking.h>
#import "AlertUtils.h"

@implementation TaoLuManager


static dispatch_once_t predict;
static TaoLuManager *manager = nil;

#pragma mark - 内部方法
+ (void)printPara{
        NSLog(@"sys_name:%@",[[UIDevice currentDevice] systemName] );
        NSLog(@"sys_ver:%@",[[UIDevice currentDevice] systemVersion] );
        NSLog(@"sys_model:%@",[[UIDevice currentDevice] model] );
    for (NSString *lan in [NSLocale preferredLanguages]) {
        NSLog(@"%@",lan);
    }
}
+(UIImage *)getSnapShot{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(window.frame.size);
    [window drawViewHierarchyInRect:CGRectMake(0, 0, K_WIDTH, K_HEIGHT) afterScreenUpdates:NO];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //区域截屏,如果需要，用下面两行
    CGRect rect = CGRectMake(0, 0, K_WIDTH, 300);
    screenShot = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(screenShot.CGImage, rect)];
    [UIImagePNGRepresentation(screenShot) writeToFile:SNAPSHOTPATH atomically:YES];
#ifdef YBTEST
    UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil); //调试
#endif
    return screenShot;
}

+ (void)initShareSDK {
//    [self printPara];
    [manager setPlatformModel];
    [ShareSDK registerApp:SHARESDK_ID
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeTwitter),
                            @(SSDKPlatformTypeFacebook)]
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
                 [appInfo SSDKSetupSinaWeiboByAppKey:manager.weiboModel.key
                                           appSecret:manager.weiboModel.secreat
                                         redirectUri:SHARESDK_REURL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:manager.weixinModel.key
                                       appSecret:manager.weixinModel.key];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:manager.QQModel.key
                                      appKey:manager.QQModel.secreat
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeTwitter:
                 [appInfo        SSDKSetupTwitterByConsumerKey:manager.twitterModel.key
                                                consumerSecret:manager.twitterModel.secreat
                                                   redirectUri:SHARESDK_REURL];    //回调地址
                 break;
             case SSDKPlatformTypeFacebook:
             [appInfo SSDKSetupFacebookByApiKey:manager.facebookModel.key
                                      appSecret:manager.facebookModel.secreat
                                       authType:SSDKAuthTypeBoth];
                 
             default:
                 break;
         }
     }];
}

- (void)setPlatformModel{
    NSArray *platforms = SHARESDK_PLATFORMS;
    if(platforms != nil){
        for (NSDictionary *d in platforms) {
            if ([[d allKeys]containsObject:@"platform"]) {  //安全判断
                NSString *name = [d objectForKey:@"platform"];
                [manager setModel:name WithDic:d];
            }
        }
    }
}

- (void)setModel:(NSString *)name WithDic:(NSDictionary *)dic{
    if([name isEqualToString:@"qq"]){
        manager.QQModel = [[PlatformModel alloc]initWithDic:dic];
        return;
    }
    if([name isEqualToString:@"wechat"]){
        manager.weixinModel = [[PlatformModel alloc]initWithDic:dic];
        return;
    }
    if([name isEqualToString:@"sinaweibo"]){
        manager.weiboModel = [[PlatformModel alloc]initWithDic:dic];
        return;
    }
    if([name isEqualToString:@"twitter"]){
        manager.twitterModel = [[PlatformModel alloc]initWithDic:dic];
        return;
    }
    if([name isEqualToString:@"facebook"]){
        manager.facebookModel = [[PlatformModel alloc]initWithDic:dic];
        return;
    }
}

+ (TaoLuManager *)shareManager {
    
    dispatch_once(&predict, ^{
        manager = [[self alloc]init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        manager.classNames = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",@"NewArrivalViewController"];
        for (int i=0; i<manager.classNames.count; i++) {
            if (![userDefaults boolForKey:manager.classNames[i]]) {
                [userDefaults setObject:@NO forKey:manager.classNames[i]];
            }
        }
    });
    
    return manager;
}
+ (void)updateConfig {

    for (NSString *language in [NSLocale preferredLanguages]) {
        YBLog(@"------语言列表-->%@<--",language);
    }
    AFHTTPSessionManager *sessionManager;
    sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = 10;
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [sessionManager GET:@"http://192.168.0.33:8888/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject allKeys]containsObject:@"res"] == NO) {
            [TaoLuManager shareManager].taskState(TaskNone);
            return ;    //更健壮
        }
        [TaoLuManager shareManager].taoLuJson = responseObject;
        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:LOCAL_JSON_NAME];
        [self afterConfig];
        YBLog(@"网络获取成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([TaoLuManager shareManager].taoLuJson) return ;  //判断条件包含指定的key会更安全
        
        NSDictionary *localJson = [[NSUserDefaults standardUserDefaults]objectForKey:LOCAL_JSON_NAME];
        if(localJson){
            [self shareManager].taoLuJson = localJson;
            [self afterConfig];
        }else {
            //都没有的话，[TaoLuManager shareManager].taoLuJson 的值是nil，根据这个控制弹出
            YBLog(@"没有套路数据");
            [TaoLuManager shareManager].taskState(TaskNone);
        }
    }];

}

+ (void)afterConfig{
    [self setNewOrderClassNames];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initShareSDK];
    });
}

+ (void)setNewOrderClassNames{
    NSMutableArray *newClassNames = [NSMutableArray array];
    NSArray *arr = [CONFIGJSON objectForKey:@"taskpriority"];
    for (int i =0; i < arr.count; i++) {
        [newClassNames addObject:[self changeName:arr[i]]];
    }
    if(arr.count == newClassNames.count && arr.count <= 5){
        [TaoLuManager shareManager].classNames = newClassNames; //也加了容错处理
    }
}

+ (NSString *)changeName:(NSString *)name{
    if([name isEqualToString:@"sharetask"]){
        return CLASSNAME_SHARE;
    }
    if([name isEqualToString:@"goodtask"]){
        return CLASSNAME_GOOD;
    }
    if([name isEqualToString:@"followtask"]){
        return CLASSNAME_FOLLOW;
    }
    if([name isEqualToString:@"downloadtask"]){ //新品推荐任务不是一次性的，区别对待
        NSString *adid = [DOWNLOADTASK_DIC objectForKey:@"adid"];
        NSString *newName = [NSString stringWithFormat:@"NewArrivalViewController%@",adid];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults boolForKey:newName] == NO) {
            [userDefaults setObject:@NO forKey:newName];
        }
        return newName;
    }
    YBLog(@"字符串不符合------");
    return nil;
}

+ (NSDictionary *)returnTaoLuJSON {
    return [TaoLuManager shareManager].taoLuJson;
}
#pragma mark - 封装unity调用方法

extern "C" {
    
    void __startTask(){
        [TaoLuManager startTask];
            }
    
    void __resetTask(){
        [TaoLuManager resetTask];
    }
    
    void __doShareTask(){
        [TaoLuManager doShareTask];
    }
    
    void __gotoAppstore(){
        [TaoLuManager doCommentTask];
    }
}

+ (void)startTask {
    
 
    if ([[TaoLuManager shareManager] taoLuJson] == nil) {
        [TaoLuManager shareManager].taskState(TaskNone);
        return;
    }
    if([[TASKLIST objectForKey:@"isopen"]boolValue] == NO){
        [TaoLuManager shareManager].taskState(TaskClose);
        return;
    }
//    //根据任务的有无，来判断是否执行完毕
    NSString *currentClassName;
    NSArray *newClassNames = [TaoLuManager shareManager].classNames;
    for (int i=0; i<newClassNames.count; i++) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:newClassNames[i]]boolValue] == NO) {
            currentClassName = newClassNames[i];
            break;
        }
    }
    
    if(currentClassName == nil){
          [TaoLuManager shareManager].taskState(TaskAllFinish); //空就是没有了
    }else{
        [AlertUtils StartTaskWithClassName:currentClassName];
//        currentClassName = nil;
    }
    
    
}

+ (void)resetTask{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *adid = @"";
    if ([[DOWNLOADTASK_DIC allKeys]containsObject:@"adid"]) {
        adid = [DOWNLOADTASK_DIC objectForKey:@"adid"];
    }
    NSString *newName = [NSString stringWithFormat:@"NewArrivalViewController%@",adid];
    NSArray *names = @[@"ShareViewController",@"CommentViewController",@"FollowViewController",newName];
    
    for (int i =0; i<names.count; i++) {
        [userDefaults setObject:@NO forKey:names[i]];
    }
}

+ (void)doShareTask {
    if(SHARETASK_DIC) {
        [AlertUtils StartTaskWithClassName:CLASSNAME_SHARE];
    }
}

+ (void)doCommentTask {
    if(GOODTASK_DIC) {
        NSString *iTunesLink = [GOODTASK_DIC objectForKey:@"openurl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

#pragma mark - 拖进unity导出的工程后打开注释

+ (void)sendMsgtoUnityWhenGetResult:(TaskState)state{
/*
    switch (state) {
        case TaskClose:
        YBLog(@"任务关闭");
        UnitySendMessage("Canvas", "GetIosResult", "关闭");
        break;
        case TaskCancle:
            YBLog(@"任务取消");
            UnitySendMessage("Canvas", "GetIosResult", "取消");
            break;
        case TaskFaild:
            YBLog(@"任务失败");
            UnitySendMessage("Canvas", "GetIosResult", "失败");
            break;
        case TaskSuccees:
            YBLog(@"任务成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [UILabel showStats:@"task succeed" atView:[[UIApplication sharedApplication] keyWindow]];
        });
            UnitySendMessage("Canvas", "GetIosResult", "成功");
            break;
        case TaskAllFinish:
            YBLog(@"mobi");
            UnitySendMessage("Canvas", "GetIosResult", "mobi");
            break;
        case TaskNone:
            YBLog(@"无数据");
            UnitySendMessage("Canvas", "GetIosResult", "无数据");
            break;
        
        default:
            break;
    }
*/
}

@end
