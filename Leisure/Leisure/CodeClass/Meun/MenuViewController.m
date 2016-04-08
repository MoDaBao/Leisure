//
//  MenuViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "DrawerViewController.h"
#import "ReadViewController.h"
#import "RadioViewController.h"
#import "TopicViewController.h"
#import "ProductViewController.h"
#import "LoginViewController.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation MenuViewController


#pragma mark -----loginButton方法-----

- (IBAction)login:(id)sender {
    
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消登录" message:@"确定取消登录？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserInfoManager cancelUserAuth];
            [UserInfoManager cancelUserID];
            [self.loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil];
        LoginViewController *loginVC = [storyBoard instantiateInitialViewController];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
}


#pragma mark -----viewDidLoad-----

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _list = [NSMutableArray array];
    [_list addObject:@"阅读"];
    [_list addObject:@"电台"];
    [_list addObject:@"话题"];
    [_list addObject:@"良品"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[UserInfoManager getUserIcon] isEqualToString:@" "]) {
        [_loginButton setTitle:[UserInfoManager getUserName] forState:UIControlStateNormal];
//        self.iconImageView.image = [UIImage imageNamed:[UserInfoManager getUserIcon]];
    } else {
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -----tableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
//    cell.backgroundView.backgroundColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.00];
    cell.textLabel.text = _list[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  获取抽屉对象
    DrawerViewController *menuController = (DrawerViewController*)((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawerVC;
    
    if(indexPath.row == 0) {  // 设置阅读为抽屉的根视图
        
        ReadViewController *viewController = [[ReadViewController alloc]init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [menuController setRootViewController:navController animated:YES];
        
    } else if(indexPath.row == 1){  // 设置电台为抽屉的根视图
        
        RadioViewController *controller = [[RadioViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [menuController setRootViewController:navController animated:YES];
        
    } else if(indexPath.row == 2){  // 设置话题为抽屉的根视图
        
        TopicViewController *controller = [[TopicViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [menuController setRootViewController:navController animated:YES];
        
    } else if(indexPath.row == 3){ //设置良品为抽屉的根视图
        ProductViewController *controller = [[ProductViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [menuController setRootViewController:navController animated:YES];
    }
    
//    [menuController showRootViewController:YES];
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
