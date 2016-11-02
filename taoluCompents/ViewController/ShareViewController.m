//
//  ShareViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>

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
                                         images:@[] //传入要分享的图片
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
    }
    return _shareParams;
}
#pragma mark- shareAction
- (IBAction)CN_wx:(UIButton *)sender {
    [ShareSDK share:SSDKPlatformTypeWechat //传入分享的平台类型
         parameters:self.shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}
- (IBAction)CN_Qzone:(UIButton *)sender {
    
}
- (IBAction)CN_QQ:(UIButton *)sender {
}
- (IBAction)CN_pyq:(UIButton *)sender {
}
- (IBAction)CN_wb:(UIButton *)sender {
}
- (IBAction)EN_fb:(UIButton *)sender {
}
- (IBAction)EN_tt:(UIButton *)sender {
}

- (void)ShareAction:(SSDKPlatformType )platformType{
    [ShareSDK share:platformType //传入分享的平台类型
         parameters:self.shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
     }];
}
+ (instancetype)returnInstance {
    ShareViewController *vc = [[ShareViewController alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return vc;
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
