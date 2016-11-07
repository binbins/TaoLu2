//
//  NewArrivalViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//
#define DOWNLOADTASK_DIC [CONFIGJSON objectForKey:@"downloadTask"]
#import "TaoLuManager.h"
#import "NewArrivalViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewArrivalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *RecomAppTitle;
@property (weak, nonatomic) IBOutlet UIImageView *appLogo;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appDes;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation NewArrivalViewController

+ (instancetype)returnInstance {
    NewArrivalViewController *vc = [[NewArrivalViewController alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return vc;
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [TaoLuManager shareManager].taskState(taskCancle);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)startAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RecomAppTitle.text = [DOWNLOADTASK_DIC objectForKey:@"title"];
    self.appName.text = [DOWNLOADTASK_DIC objectForKey:@"appName"];
    self.appDes.text = [DOWNLOADTASK_DIC objectForKey:@"appIntro"];
    [self.appLogo sd_setImageWithURL:[NSURL URLWithString:[DOWNLOADTASK_DIC objectForKey:@"appLogo"]] placeholderImage:[UIImage imageNamed:@"logo_placeholder"]];
    [self.startBtn setTitle:[DOWNLOADTASK_DIC objectForKey:@"btnTitle"] forState:UIControlStateNormal];
    YBLog(@"logo地址：%@",[DOWNLOADTASK_DIC objectForKey:@"appLogo"]);
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
