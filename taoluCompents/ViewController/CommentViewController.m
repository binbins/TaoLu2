//
//  CommentViewController.m
//  TaoLu2
//
//  Created by 张帆 on 16/10/27.
//  Copyright © 2016年 adesk. All rights reserved.
//
#import "TaoLuManager.h"

#import "CommentViewController.h"

@interface CommentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *comTitle;
@property (weak, nonatomic) IBOutlet UILabel *com1;
@property (weak, nonatomic) IBOutlet UILabel *com2;
@property (weak, nonatomic) IBOutlet UILabel *com3;

@property (weak, nonatomic) IBOutlet UIImageView *check1;
@property (weak, nonatomic) IBOutlet UIImageView *check2;
@property (weak, nonatomic) IBOutlet UIImageView *check3;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


@end

@implementation CommentViewController

+ (instancetype)returnInstance {
    CommentViewController *vc = [[CommentViewController alloc]init];
    [vc setDefinesPresentationContext:YES];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    return vc;
}

- (IBAction)closeAction:(UIButton *)sender {
    
    [TaoLuManager shareManager].taskState(taskCancle);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)choseComment:(UITapGestureRecognizer *)sender {
    
    _check1.hidden = YES;
    _check2.hidden = YES;
    _check3.hidden = YES;
    for (UIView *member in sender.view.subviews) {
        if ([member isKindOfClass:[UIImageView class]]) {
            member.hidden = NO;
        }
        if ([member isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)member;
            YBLog(@"%@",label.text);
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.comTitle.text = [GOODTASK_DIC objectForKey:@"title"];
    [self setCommentLabeText];
    [self.startBtn setTitle:[GOODTASK_DIC objectForKey:@"BtnTitle"] forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(gotoAppStore) forControlEvents:UIControlEventTouchUpInside];
    if(![[GOODTASK_DIC objectForKey:@"showCloseBtn"]boolValue]){
        self.closeBtn.hidden = YES;
    }
}

- (void)gotoAppStore {
    NSString *iTunesLink = [GOODTASK_DIC objectForKey:@"openUrl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)setCommentLabeText{
    NSArray *commentExamples = [GOODTASK_DIC objectForKey:@"comments"];
    NSArray *comLabels = @[self.com1, self.com2, self.com3];
    for (int i =0; i<comLabels.count; i++) {
        UILabel *label = comLabels[i];
        label.text = commentExamples[i];
    }
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
