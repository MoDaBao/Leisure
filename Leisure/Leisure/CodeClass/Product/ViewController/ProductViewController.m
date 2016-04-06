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


#pragma mark -----loadLazy-----

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}


#pragma mark -----数据加载-----

- (void)loadaddtimeNewData {
    [NetWorkRequestManager requestWithType:POST urlString:SHOPLIST_URL parDic:@{@"start":@(self.start = 0), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        
        [self.listArray removeAllObjects];
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
            
            [self.tableView.mj_header endRefreshing];
        });
        
    } requsetError:^(NSError *error) {
        
    }];
}

- (void)loadaddtimeMoreData {
    [NetWorkRequestManager requestWithType:POST urlString:SHOPLIST_URL parDic:@{@"start":@(self.start += 10), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"dataDic = %@", dataDic);
        
        //获取列表数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *dic in listArr) {
            ProductListModel *model = [[ProductListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.listArray addObject:model];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
        });
        
    } requsetError:^(NSError *error) {
        
    }];

}


#pragma mark -----创建视图-----

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductListModel class])];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeMoreData)];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _start = 0;
    _limit = 10;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"良品";
    
    [self createTableView];
    
    [self loadaddtimeNewData];
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
