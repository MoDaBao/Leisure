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

@interface ProductViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSInteger start;//请求开始位置

@property (nonatomic) NSInteger limit;//请求条数

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) UITableView *tableView;

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
//            ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] init];
//            ProductListModel *model = self.listArray[0];
//            infoVC.contentid = model.contentid;
//            [self.navigationController pushViewController:infoVC animated:YES];
            
            [self.tableView reloadData];
        });
        
    } requsetError:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"良品";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductListModel class])];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    
    [self requstData];
}


#pragma mark -----tableView-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.listArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
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
