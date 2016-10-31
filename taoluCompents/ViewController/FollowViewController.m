//
//  FollowViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//

#import "FollowViewController.h"

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
