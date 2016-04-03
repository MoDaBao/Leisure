//
//  TopicViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TopicViewController.h"
#import "URLHeaderDefine.h"
#import "NetWorkRequestManager.h"
#import "TopicListModel.h"

@interface TopicViewController ()

@property (nonatomic) NSInteger start;

@property (nonatomic) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation TopicViewController

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)requestDataWithSort:(NSString *)sort {
    
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort":sort, @"start":@(self.start), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        //获取列表数据
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfo = [[TopicUserInfoModel alloc]init];
            TopicCounterListModel *counter = [[TopicCounterListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            [counter setValuesForKeysWithDictionary:list[@"counter"]];
            [userInfo setValuesForKeysWithDictionary:list[@"userinfo"]];
            listModel.userInfo = userInfo;
            listModel.counter = counter;
            
            [self.listArray addObject:listModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            
        }
        
    } requsetError:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor greenColor];
    
    self.navigationItem.title = @"话题";
    
    [self requestDataWithSort:@"hot"];
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
