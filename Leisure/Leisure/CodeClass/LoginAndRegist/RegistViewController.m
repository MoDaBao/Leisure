//
//  RegistViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/8.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (nonatomic, assign) NSInteger gender;//0为男性 1为女性

@end

@implementation RegistViewController

//选择男性
- (IBAction)male:(id)sender {
    _gender = 0;
    [self.maleBtn setBackgroundColor:[UIColor orangeColor]];
    [self.femaleBtn setBackgroundColor:[UIColor lightGrayColor]];
}

//选择女性
- (IBAction)female:(id)sender {
    _gender = 1;
    [self.maleBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.femaleBtn setBackgroundColor:[UIColor orangeColor]];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)regist:(id)sender {
    [NetWorkRequestManager requestWithType:POST urlString:REGIST_URL parDic:@{@"email" : self.emailTF.text, @"gender" : [NSNumber numberWithInteger:_gender], @"passwd" : self.passwordTF.text, @"uname" : [self.userNameTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} requestFinish:^(NSData *data) {
//        [self.userNameTF.text stringByAddingPercentEncodingWithAllowedCharacters:[]];
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *result = [dataDic objectForKey:@"result"];
            if (![result intValue]) {//注册失败
                NSLog(@"msg = %@", [[dataDic objectForKey:@"data"] objectForKey:@"msg"]);
                NSString *message = [[dataDic objectForKey:@"data"] objectForKey:@"msg"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:action];
                
                [self presentViewController:alertController animated:YES completion:nil];
            } else {//注册成功
                //保存用户的auth
                [UserInfoManager saveUserAuth:[[dataDic objectForKey:@"data"] objectForKey:@"auth"]];
                //保存用户名
                [UserInfoManager saveUserName:[[dataDic objectForKey:@"data"] objectForKey:@"uname"]];
                //保存用户id
                [UserInfoManager saveUserID:[[dataDic objectForKey:@"data"] objectForKey:@"uid"]];
                //保存用户icon
                [UserInfoManager saveUserIcon:[[dataDic objectForKey:@"data"] objectForKey:@"icon"]];
                
                [self.maleBtn setImage:[UIImage imageNamed:@"29-heart"] forState:UIControlStateNormal];
                
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
    } requsetError:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _gender = 0;//默认是男
    [self.maleBtn setBackgroundColor:[UIColor orangeColor]];
    
    //设置圆角
    self.maleBtn.layer.cornerRadius = 10;
    self.femaleBtn.layer.cornerRadius = 10;
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
