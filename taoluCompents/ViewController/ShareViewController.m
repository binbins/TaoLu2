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

#define SHARETASK_DIC [CONFIGJSON objectForKey:@"shareTask"]


@interface ShareViewController ()
@property (nonatomic, strong)NSMutableDictionary *shareParams;

@property (weak, nonatomic) IBOutlet UILabel *shareTitle;
//国内
@property (weak, nonatomic) IBOutlet UIView *CN_view;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform1;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform2;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform3;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform4;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform5;

//海外
@property (weak, nonatomic) IBOutlet UIView *EN_view;
@property (weak, nonatomic) IBOutlet UIButton *EN_platform1;
@property (weak, nonatomic) IBOutlet UIButton *EN_platform2;

@end

@implementation ShareViewController

- (NSMutableDictionary *)shareParams {

    if (_shareParams == nil) {
        
        _shareParams = [NSMutableDictionary dictionary];
        [_shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:@[[UIImage imageNamed:@"star.png"]] //传入要分享的图片
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
    }
    return _shareParams;
}
#pragma mark- shareAction
- (IBAction)CN_wx:(UIButton *)sender {
      [self ShareAction:SSDKPlatformSubTypeWechatSession];
}
- (IBAction)CN_Qzone:(UIButton *)sender {
      [self ShareAction:SSDKPlatformSubTypeQZone];
}
- (IBAction)CN_QQ:(UIButton *)sender {
      [self ShareAction:SSDKPlatformSubTypeQQFriend];
}
- (IBAction)CN_pyq:(UIButton *)sender {
      [self ShareAction:SSDKPlatformSubTypeWechatTimeline];
}
- (IBAction)CN_wb:(UIButton *)sender {
      [self ShareAction:SSDKPlatformTypeSinaWeibo];
}
- (IBAction)EN_fb:(UIButton *)sender {
      [self ShareAction:SSDKPlatformTypeFacebook];
}
- (IBAction)EN_tt:(UIButton *)sender {
    [self ShareAction:SSDKPlatformTypeTwitter];
}

- (void)ShareAction:(SSDKPlatformType )platformType{
    [ShareSDK share:platformType //传入分享的平台类型
         parameters:self.shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         
         switch (state) {
             case SSDKResponseStateCancel:
                 YBLog(@"分享结果：--取消");   //分享成功不经过指定返回按钮返回会被误判取消
                 break;
            case SSDKResponseStateFail:
                 YBLog(@"分享结果：--失败");
                 [self pushPasteView];
                 break;
             case SSDKResponseStateSuccess:
                 YBLog(@"分享结果：--成功");
                 [TaoLuManager shareManager].taskIndex++;  //
                 break;
             default:
                 break;
                 
         }
        
     }];
    

}

- (void)pushPasteView{
    PasteViewController *vc = [PasteViewController returnInstance];
    vc.pasteDic = [SHARETASK_DIC objectForKey:@"planB"];
    [self presentViewController:vc animated:YES completion:nil];
}
+ (instancetype)returnInstance {
    ShareViewController *vc = [[ShareViewController alloc]init];
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
    [self changLanguage:[TaoLuManager shareManager].isEnglish];
    self.shareTitle.text = [SHARETASK_DIC objectForKey:@"title"];
}

- (void)changLanguage:(BOOL)isEnglish{
    self.EN_view.hidden = !isEnglish;
    self.CN_view.hidden = isEnglish;
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
