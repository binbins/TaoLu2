//
//  ShareViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "TaoLuManager.h"
#import "PasteViewController.h"



@interface ShareViewController ()
@property (nonatomic, strong)NSMutableDictionary *shareParams;

@property (weak, nonatomic) IBOutlet UILabel *shareTitle;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


//奇数个
@property (weak, nonatomic) IBOutlet UIView *ji_view;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn1;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn2;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn3;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn4;
@property (weak, nonatomic) IBOutlet UIButton *ji_btn5;

//偶数个
@property (weak, nonatomic) IBOutlet UIView *ou_view;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn1;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn2;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn3;
@property (weak, nonatomic) IBOutlet UIButton *ou_btn4;

@property (nonatomic, strong)NSArray *platformBtns;
@end

@implementation ShareViewController {
    BOOL _ouViewHidden;
    UIImage *_screenShot;
}

- (NSArray *)platformBtns{
    if (_platformBtns == nil) {
        if (_ouViewHidden) {
            _platformBtns = @[self.ji_btn1, self.ji_btn2, self.ji_btn3, self.ji_btn4, self.ji_btn5];
        }else {
            _platformBtns = @[self.ou_btn1, self.ou_btn2, self.ou_btn3, self.ou_btn4];
        }
    }
    return _platformBtns;
}

- (NSMutableDictionary *)shareParams {

    if (_shareParams == nil) {
        if (_screenShot == nil) {
            _screenShot = [[UIImage alloc]initWithContentsOfFile:SNAPSHOTPATH];    // 基本用不上
        }
        NSDictionary *d = [SHARETASK_DIC objectForKey:@"sharecontents"];
        _shareParams = [NSMutableDictionary dictionary];
        [_shareParams SSDKSetupShareParamsByText:[d objectForKey:@"sharetext"]
                                         images:@[_screenShot, [d objectForKey:@"shareimgurl"] ] //传入要分享的图片
                                            url:[NSURL URLWithString:[d objectForKey:@"shareurl"]]
                                          title:[d objectForKey:@"sharetitle"]
                                           type:SSDKContentTypeAuto];
    }
    return _shareParams;
}

+ (instancetype)returnInstance {
    ShareViewController *vc = [[ShareViewController alloc]init];
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
    self.shareTitle.text = [SHARETASK_DIC objectForKey:@"title"];
    [self setPlatformsHidden];
    if([[SHARETASK_DIC objectForKey:@"showclosebtn"]boolValue] == NO){
        self.closeBtn.hidden = YES;
    }
    
}

- (void)setPlatformsHidden{
    NSArray *platformArr = [SHARETASK_DIC objectForKey:@"platforms"];//优化，映射排序 偶数初始减一
    
    NSInteger platNums = platformArr.count > 5?5:platformArr.count;
    _ouViewHidden = platNums % 2 == 1 ? YES : NO;
    self.ou_view.hidden = _ouViewHidden;
    self.ji_view.hidden = !_ouViewHidden;
    
    for (UIButton *btn in self.platformBtns) {  //统一设为隐藏
        btn.hidden = YES;
    }
    
    NSInteger index = _ouViewHidden? (platNums/2):(platNums/2-1);   //初始取的下标
    for (int i = 0; i < platNums; i++) {
        UIButton *btn = self.platformBtns[i];
        btn.hidden = NO;
        NSString *platName = [platformArr objectAtIndex:index];
        if (_ouViewHidden) {
            index = i%2==1?(index+(i+1)) : (index-(i+1));   //偶数：先右后左
        }else {
            index = i%2==0?(index+(i+1)) : (index-(i+1));   //奇数：先左后右
        }
                
       btn.tag = [self returnTypeIndexWithName:platName];
        [self setBtnImage:btn orReturnTypeForIndex:btn.tag];
        [btn addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark- shareAction
- (void)ShareAction:(UIButton *)btn{
    
    NSDate *deadTime = [NSDate dateWithTimeIntervalSinceNow:4];
    SSDKPlatformType type = [self setBtnImage:nil orReturnTypeForIndex:btn.tag];
    [ShareSDK share:type //传入分享的平台类型
         parameters:self.shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateCancel:
                 if ([[[NSUserDefaults standardUserDefaults]objectForKey:CLASSNAME_SHARE]boolValue] == NO) {
                     [TaoLuManager shareManager].taskState(TaskCancle);
                 }
                 break;
             case SSDKResponseStateFail:
                 if ([[[NSUserDefaults standardUserDefaults]objectForKey:CLASSNAME_SHARE]boolValue] == NO) {
                     [TaoLuManager shareManager].taskState(TaskFaild);
                 }
                 [self pushPasteView:deadTime];
                 break;
             case SSDKResponseStateSuccess:
                 if ([[[NSUserDefaults standardUserDefaults]objectForKey:CLASSNAME_SHARE]boolValue] == NO) {
                     [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:CLASSNAME_SHARE];//任务++
                     [TaoLuManager shareManager].taskState(TaskSuccees);
                 }
                 break;
             default:
                 break;
                 
         }
         
     }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushPasteView:(NSDate *)deadTime{

    if ([[NSDate date] laterDate:deadTime] == deadTime) {  //在约定时间内
        PasteViewController *vc = [PasteViewController returnInstance];
        vc.pasteDic = [SHARETASK_DIC objectForKey:@"planb"];
        //响应时间太久，若在切出程序的时候弹出粘贴框，程序会崩溃  最好的方法就是设定flag
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
        YBLog(@"分享失败，启动B计划");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    _screenShot = [TaoLuManager getSnapShot];
}


@end
