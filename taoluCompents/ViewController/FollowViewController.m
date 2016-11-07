//
//  FollowViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//
#define FOLLOWTASK_DIC [CONFIGJSON objectForKey:@"followTask"]

#import "FollowViewController.h"
#import "TaoLuManager.h"
#import <ShareSDK/ShareSDK.h>


@interface FollowViewController ()

@property (weak, nonatomic) IBOutlet UILabel *followTitle;

//奇数
@property (weak, nonatomic) IBOutlet UIView *ji_view;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn1;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn2;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn3;

//偶数
@property (weak, nonatomic) IBOutlet UIView *ou_view;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn1;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn2;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn3;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn4;

@property (nonatomic, strong)NSArray *platformBtns;
@end

@implementation FollowViewController {
    BOOL _ouViewHidden;
}

- (NSArray *)platformBtns{
    if (_platformBtns == nil) {
        if (_ouViewHidden) {
            _platformBtns = @[self.ji_btn1, self.ji_btn2, self.ji_btn3];
        }else {
            _platformBtns = @[self.ou_btn1, self.ou_btn2, self.ou_btn3, self.ou_btn4];
        }
    }
    return _platformBtns;
}

+ (instancetype)returnInstance {
    FollowViewController *vc = [[FollowViewController alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return vc;
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [TaoLuManager shareManager].taskState(taskCancle);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.followTitle.text = [FOLLOWTASK_DIC objectForKey:@"title"];
    [self setPlatformsHidden];
}

- (void)setPlatformsHidden{
    NSArray *platformArr = [FOLLOWTASK_DIC objectForKey:@"platforms"];
    NSInteger platNums = platformArr.count > 4?4:platformArr.count;
    _ouViewHidden = platNums % 2 == 1 ? YES : NO;
    self.ou_view.hidden = _ouViewHidden;
    self.ji_view.hidden = !_ouViewHidden;
    
    for (UIButton *btn in self.platformBtns) {
        btn.hidden = YES;
    }
    NSInteger index = _ouViewHidden? (platformArr.count/2):(platformArr.count/2-1);   //初始取的下标
    for (int i = 0; i < platNums; i++) {
        UIButton *btn = self.platformBtns[i];
        btn.hidden = NO;
        //设置logo和对应的事件
        NSDictionary *platformDic = platformArr[index];
        if (_ouViewHidden) {
            index = i%2==1?(index+(i+1)) : (index-(i+1));   //偶数：先右后左
        }else {
            index = i%2==0?(index+(i+1)) : (index-(i+1));   //奇数：先左后右
        }
        NSInteger typeIndex = [platformDic[@"platformType"]integerValue];
        btn.tag = typeIndex;
        [btn setImage:[self btnImgforIndex:typeIndex] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)followAction:(UIButton *)btn {
    switch (btn.tag) {
        case 5:
            [ShareSDK authorize:SSDKPlatformTypeSinaWeibo settings:@{SSDKAuthSettingKeyScopes : @[@"follow_app_official_microblog"]} onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                //授权并关注指定微博
            }];
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (SSDKPlatformType )typeForIndex:(NSInteger)typeIndex{
    
    SSDKPlatformType type;
    switch (typeIndex) {
        case 1:
            type = SSDKPlatformSubTypeWechatSession;
            break;
        case 2:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 3:
            type = SSDKPlatformSubTypeQQFriend;
            break;
        case 4:
            type = SSDKPlatformSubTypeQZone;
            break;
        case 5:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        case 6:
            type = SSDKPlatformTypeFacebook;
            break;
        case 7:
            type = SSDKPlatformTypeTwitter;
            break;
            
        default:
            break;
    }
    return type;
}
-(UIImage *)btnImgforIndex:(NSInteger)typeIndex {
    
    NSString *btnImgName;
    SSDKPlatformType type;
    switch (typeIndex) {
        case 1:
            type = SSDKPlatformSubTypeWechatSession;
            btnImgName = @"weixin";
            break;
        case 2:
            type = SSDKPlatformSubTypeWechatTimeline;
            btnImgName = @"pyq";
            break;
        case 3:
            type = SSDKPlatformSubTypeQQFriend;
            btnImgName = @"qq";
            break;
        case 4:
            type = SSDKPlatformSubTypeQZone;
            btnImgName = @"qzone";
            break;
        case 5:
            type = SSDKPlatformTypeSinaWeibo;
            btnImgName = @"weibo";
            break;
        case 6:
            type = SSDKPlatformTypeFacebook;
            btnImgName = @"facebook";
            break;
        case 7:
            type = SSDKPlatformTypeTwitter;
            btnImgName = @"twitter";
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:btnImgName];
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
