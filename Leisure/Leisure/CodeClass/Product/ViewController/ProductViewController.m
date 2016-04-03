//
//  ProductViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ProductViewController.h"
#import "NetWorkRequestManager.h"
#import "URLHeaderDefine.h"
#import "ProductListModel.h"
#import "ProductInfoViewController.h"

@interface ProductViewController ()

@property (nonatomic) NSInteger start;//请求开始位置

@property (nonatomic) NSInteger limit;//请求条数

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation ProductViewController

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)requstData {
    [NetWorkRequestManager requestWithType:POST urlString:SHOPLIST_URL parDic:@{@"start":@(self.start), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dataDic = %@", dataDic);
        
        //获取列表数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *dic in listArr) {
            ProductListModel *model = [[ProductListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.listArray addObject:model];
        }
//        NSLog(@"self.listArray = %@",self.listArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //测试
            ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] init];
            ProductListModel *model = self.listArray[0];
            infoVC.contentid = model.contentid;
            [self.navigationController pushViewController:infoVC animated:YES];
        });
        
    } requsetError:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"良品";
    
    [self requstData];
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
