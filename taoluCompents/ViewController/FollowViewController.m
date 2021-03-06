//
//  FollowViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//


#import "FollowViewController.h"
#import "TaoLuManager.h"
#import <ShareSDK/ShareSDK.h>


@interface FollowViewController ()

@property (weak, nonatomic) IBOutlet UILabel *followTitle;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

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
@property (nonatomic, copy)NSString *facebookAccount, *sinaweiboAccount, *twitterAccount;
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
    
    [TaoLuManager shareManager].taskState(TaskCancle);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.followTitle.text = [FOLLOWTASK_DIC objectForKey:@"title"];
    [self setPlatformsHidden];
    if(![[FOLLOWTASK_DIC objectForKey:@"showclosebtn"]boolValue]){
        self.closeBtn.hidden = YES;
    }
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
    NSInteger index = _ouViewHidden? (platNums/2):(platNums/2-1);   //初始取的下标
    for (int i = 0; i < platNums; i++) {
        UIButton *btn = self.platformBtns[i];
        btn.hidden = NO;
        //设置logo和对应的事件
        NSDictionary *nameAndKey = [platformArr objectAtIndex:index];
        NSString *platName = [nameAndKey objectForKey:@"platform"];
        if (_ouViewHidden) {
            index = i%2==1?(index+(i+1)) : (index-(i+1));   //偶数：先右后左
        }else {
            index = i%2==0?(index+(i+1)) : (index-(i+1));   //奇数：先左后右
        }
        NSInteger typeIndex = [self returnTypeIndexWithName:platName];
        btn.tag = typeIndex;
        [self setBtnImage:btn orReturnTypeForIndex:btn.tag];
        [btn addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    }
 
}

- (void)setFollowAccount:(NSString *)account withPlatform:(NSString *)name{
    
    if([name isEqualToString:@"qq"]){
        return;
    }
    if([name isEqualToString:@"wechat"]){
        return;
    }
    if([name isEqualToString:@"sinaweibo"]){
        self.sinaweiboAccount = account;
        return;
    }
    if([name isEqualToString:@"twitter"]){
        self.twitterAccount = account;
        return;
    }
    if([name isEqualToString:@"facebook"]){
        self.facebookAccount = account;
        return;
    }
}
- (NSInteger)returnTypeIndexWithName:(NSString *)name{  //考虑健壮性
    if([name isEqualToString:@"wechat"]){
        return 1;
    }
    if([name isEqualToString:@"wechattimeline"]){
        return 2;
    }
    if([name isEqualToString:@"qq"]){
        return 3;
    }
    if([name isEqualToString:@"qzone"]){
        return 4;
    }
    if([name isEqualToString:@"sinaweibo"]){
        return 5;
    }
    if([name isEqualToString:@"facebook"]){
        return 6;
    }
    if([name isEqualToString:@"twitter"]){
        return 7;
    }
    return 1;
}

- (void)followAction:(UIButton *)btn {
    switch (btn.tag) {
        case 5:
            [ShareSDK authorize:SSDKPlatformTypeSinaWeibo settings:@{SSDKAuthSettingKeyScopes : @[@"follow_app_official_microblog"]} onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                //授权并关注指定微博
                if (state == SSDKResponseStateSuccess)
                {
                    NSLog(@"关注成功");
                    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:CLASSNAME_FOLLOW];
                    [TaoLuManager shareManager].taskState(TaskSuccees);
                }
                else if (state == SSDKResponseStateFail)
                {
                    NSLog(@"%@", [NSString stringWithFormat:@"关注失败:%@", error.debugDescription]);
                }else if (state == SSDKResponseStateCancel){
                    [TaoLuManager shareManager].taskState(TaskCancle);
                }
            }];
            break;
        case 7:
            [ShareSDK authorize:SSDKPlatformTypeTwitter settings:@{SSDKAuthSettingKeyScopes : @[@"all",@"SmartGames@wangqianqian100"]} onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                //授权并关注指定微博
                if (state == SSDKResponseStateSuccess)
                {
                    NSLog(@"关注成功");
                    [TaoLuManager shareManager].taskState(TaskSuccees);
                    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:CLASSNAME_FOLLOW];
                }
                else if (state == SSDKResponseStateFail)
                {
                    NSLog(@"%@", [NSString stringWithFormat:@"关注失败:%@", error.debugDescription]);
                    [TaoLuManager shareManager].taskState(TaskFaild);
                }else if (state == SSDKResponseStateCancel){
                    [TaoLuManager shareManager].taskState(TaskCancle);
                }
            }];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(SSDKPlatformType)setBtnImage:(UIButton *)btn orReturnTypeForIndex:(NSInteger)typeIndex {
    
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
    //有按钮参数的话设置上图片，没有只返回 平台枚举类型
    if (btn != nil) {
        [btn setImage:[UIImage imageNamed:btnImgName] forState:UIControlStateNormal];
    }
    
    return type;
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
