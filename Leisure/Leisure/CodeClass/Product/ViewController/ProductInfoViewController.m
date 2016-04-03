//
//  ProductInfoViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "NetWorkRequestManager.h"
#import "URLHeaderDefine.h"
#import "ProductCommentListModel.h"

@interface ProductInfoViewController ()

//用户评论数据源
@property (nonatomic, strong) NSMutableArray *commentList;


@end

@implementation ProductInfoViewController

- (NSMutableArray *)commentList {
    if ( _commentList == nil) {
        self.commentList = [NSMutableArray array];
    }
    return _commentList;
}

- (void)requestData {
    [NetWorkRequestManager requestWithType:POST urlString:SHOPINFO_URL parDic:@{@"contentid":self.contentid} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSLog(@"dataDic = %@",dataDic);
        
        //获取评论列表数据
        NSArray *commentListArr = dataDic[@"data"][@"commentlist"];
        for (NSDictionary *commentList in commentListArr) {
            ProductCommentListModel *model = [[ProductCommentListModel alloc] init];
            
            //创建用户对象
            ProductUserInfoModel *userModel = [[ProductUserInfoModel alloc] init];
            [userModel setValuesForKeysWithDictionary:commentList[@"userinfo"]];
            
            model.userInfo = userModel;
            
            [model setValuesForKeysWithDictionary:commentList];
            
            [self.commentList addObject:model];
            
        }
        
        //获取详情信息,用webview进行展示
        NSString *htmlContent = dataDic[@"data"][@"html"];
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        
        
    } requsetError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestData];
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
