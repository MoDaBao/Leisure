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

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _list = [NSMutableArray array];
    [_list addObject:@"阅读"];
    [_list addObject:@"电台"];
    [_list addObject:@"话题"];
    [_list addObject:@"良品"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
