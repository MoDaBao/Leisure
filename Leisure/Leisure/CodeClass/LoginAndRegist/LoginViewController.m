//
//  LoginViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/8.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

//返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//登录
- (IBAction)login:(id)sender {
    [NetWorkRequestManager requestWithType:POST urlString:LOGIN_URL parDic:@{@"email" : self.emailTF.text, @"passwd" : self.passwordTF.text} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSNumber *result = [dataDic objectForKey:@"result"];
        
        //登录失败
        if ([result intValue] == 0) {
            NSLog(@"msg = %@", [[dataDic objectForKey:@"data"] objectForKey:@"msg"]);
            NSString *message = [[dataDic objectForKey:@"data"] objectForKey:@"msg"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:action];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else { //登录成功
            NSLog(@"data = %@", [dataDic objectForKey:@"data"]);
            //保存用户的auth
            [UserInfoManager saveUserAuth:[[dataDic objectForKey:@"data"] objectForKey:@"auth"]];
            //保存用户名
            [UserInfoManager saveUserName:[[dataDic objectForKey:@"data"] objectForKey:@"uname"]];
            //保存用户id
            [UserInfoManager saveUserID:[[dataDic objectForKey:@"data"] objectForKey:@"uid"]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        

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
