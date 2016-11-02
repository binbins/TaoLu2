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

//国内
@property (weak, nonatomic) IBOutlet UIView *CN_view;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform1;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform2;
@property (weak, nonatomic) IBOutlet UIButton *CN_platform3;

//海外
@property (weak, nonatomic) IBOutlet UIView *EN_view;
@property (weak, nonatomic) IBOutlet UIButton *EN_platform1;
@property (weak, nonatomic) IBOutlet UIButton *EN_platform2;

@end

@implementation FollowViewController

+ (instancetype)returnInstance {
    FollowViewController *vc = [[FollowViewController alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return vc;
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)follow_wb:(UIButton *)sender {
    [ShareSDK authorize:SSDKPlatformTypeSinaWeibo settings:@{SSDKAuthSettingKeyScopes : @[@"follow_app_official_microblog"]} onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        //授权并关注指定微博
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   [self changLanguage:[TaoLuManager shareManager].isEnglish];
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
