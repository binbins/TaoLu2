//
//  AlertUtils.m
//  TaoLu2
//
//  Created by 张帆 on 16/11/8.
//  Copyright © 2016年 adesk. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "AlertUtils.h"
#import "TaoLuManager.h"


@implementation AlertUtils

/*
    说明：原生分享支持 标题，链接，本地图片 
    有网址的时候，qq会自动用爬虫去获取，此时图片，标题无效
 */

+ (void)commentAlert{

    UIAlertController *commentAlert = [UIAlertController alertControllerWithTitle:[GOODTASK_DIC objectForKey:@"title"] message:[GOODTASK_DIC objectForKey:@"nativeSecondTitle"] preferredStyle:UIAlertControllerStyleAlert];
    
    //创建动作
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:[GOODTASK_DIC objectForKey:@"nativeCancleBtnText"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [TaoLuManager shareManager].taskState(taskCancle);
    }]; //取消
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:[GOODTASK_DIC objectForKey:@"BtnTitle"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *iTunesLink = [GOODTASK_DIC objectForKey:@"openUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        [commentAlert dismissViewControllerAnimated:YES completion:nil];
        [TaoLuManager shareManager].taskState(taskSuccees);
    }];
    
    //添加动作
    [commentAlert addAction:cancle];
    [commentAlert addAction:confirm];
    
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:commentAlert animated:YES completion:nil];
}

+ (void)sameToCoustom:(NSInteger)index {
    
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow ]rootViewController];
    UIViewController *vc = [[NSClassFromString([TaoLuManager shareManager].classNames[index]) alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [viewController presentViewController:vc animated:YES completion:nil];

}
+ (void)shareAlert{
    
    NSString *string = [SHARETASK_DIC objectForKey:@"title"];
    NSURL *URL = [NSURL URLWithString:[SHARETASK_DIC objectForKey:@"shareUrl"]];
    UIImage *image = [UIImage imageNamed:@"weibo.png"]; //上传本地截屏
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL, image]
                                      applicationActivities:nil];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:activityViewController animated:YES completion:nil];

}
+ (void)downloadAlert {

    UIAlertController *commentAlert = [UIAlertController alertControllerWithTitle:[DOWNLOADTASK_DIC objectForKey:@"title"] message:[DOWNLOADTASK_DIC objectForKey:@"appName"] preferredStyle:UIAlertControllerStyleAlert];
    
    //创建动作
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:[DOWNLOADTASK_DIC objectForKey:@"nativeCancleBtnText"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [TaoLuManager shareManager].taskState(taskCancle);
    }]; //取消
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:[DOWNLOADTASK_DIC objectForKey:@"btnTitle"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *iTunesLink = [DOWNLOADTASK_DIC objectForKey:@"downloadUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        [commentAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //添加动作
    [commentAlert addAction:cancle];
    [commentAlert addAction:confirm];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:commentAlert animated:YES completion:nil];
    
}


@end
