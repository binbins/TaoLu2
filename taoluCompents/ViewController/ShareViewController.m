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
    NSString *_snapShotPath;
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
            _screenShot = [[UIImage alloc]initWithContentsOfFile:_snapShotPath];    // 基本用不上
        }
        NSDictionary *d = [SHARETASK_DIC objectForKey:@"shareContents"];
        _shareParams = [NSMutableDictionary dictionary];
        [_shareParams SSDKSetupShareParamsByText:[d objectForKey:@"shareText"]
                                         images:@[[d objectForKey:@"shareImgUrl"], _screenShot ] //传入要分享的图片
                                            url:[NSURL URLWithString:[d objectForKey:@"shareUrl"]]
                                          title:[d objectForKey:@"shareTitle"]
                                           type:SSDKContentTypeAuto];
    }
    return _shareParams;
}
#pragma mark- shareAction



- (void)pushPasteView{
    PasteViewController *vc = [PasteViewController returnInstance];
    vc.pasteDic = [SHARETASK_DIC objectForKey:@"planB"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    YBLog(@"分享失败，弹出粘贴弹框");
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
    if([[SHARETASK_DIC objectForKey:@"showCloseBtn"]integerValue] == 0){
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
    
    NSInteger index = _ouViewHidden? (platformArr.count/2):(platformArr.count/2-1);   //初始取的下标

    for (int i = 0; i < platNums; i++) {
        UIButton *btn = self.platformBtns[i];
        btn.hidden = NO;
        NSDictionary *platformDic = platformArr[index];
        if (_ouViewHidden) {
            index = i%2==1?(index+(i+1)) : (index-(i+1));   //偶数：先右后左
        }else {
            index = i%2==0?(index+(i+1)) : (index-(i+1));   //奇数：先左后右
        }
        
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //开始截屏
   _snapShotPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shot.png"];
    UIView *view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    _screenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (_screenShot) {  //保存到本地，除非截屏失败，一般情况下是用不到的
        [UIImagePNGRepresentation(_screenShot) writeToFile:_snapShotPath atomically:YES];

    }
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
