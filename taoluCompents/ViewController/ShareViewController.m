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
    self.shareTitle.text = [SHARETASK_DIC objectForKey:@"title"];
    [self setPlatformsHidden];
}

- (void)setPlatformsHidden{
    NSArray *platformArr = [SHARETASK_DIC objectForKey:@"platforms"];
    NSInteger platNums = platformArr.count > 5?5:platformArr.count;
    _ouViewHidden = platNums % 2 == 1 ? YES : NO;
    self.ou_view.hidden = _ouViewHidden;
    self.ji_view.hidden = !_ouViewHidden;
    
    for (UIButton *btn in self.platformBtns) {
        btn.hidden = YES;
    }
    for (int i = 0; i < platNums; i++) {
        UIButton *btn = self.platformBtns[i];
        btn.hidden = NO;
        //设置logo和对应的事件
        NSDictionary *platformDic = platformArr[i];
        NSInteger typeIndex = [platformDic[@"platformType"]integerValue];
        btn.tag = typeIndex;
        [btn setImage:[self btnImgforIndex:typeIndex] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }

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

- (void)ShareAction:(UIButton *)btn{
    [ShareSDK share:[self typeForIndex:btn.tag] //传入分享的平台类型
         parameters:self.shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateCancel:
                 [TaoLuManager shareManager].taskState(taskCancle);
                 break;
             case SSDKResponseStateFail:
                 [TaoLuManager shareManager].taskState(taskFaild);
                 [self pushPasteView];
                 break;
             case SSDKResponseStateSuccess:
                 [TaoLuManager shareManager].taskState(taskSuccees);
                 [TaoLuManager shareManager].taskIndex++;
                 break;
             default:
                 break;
                 
         }
         
     }];
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
