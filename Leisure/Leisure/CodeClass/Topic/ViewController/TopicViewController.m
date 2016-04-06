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

@interface TopicViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic) NSInteger start;//数据请求起始位置

@property (nonatomic) NSInteger limit;//数据请求条数

@property (nonatomic, strong) NSMutableArray *listArray;//最新数据源

@property (nonatomic, strong) UITableView *tableView;//最新表视图

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIScrollView *scorllView;//滚动视图

@property (nonatomic, strong) UITableView *hotTableView;//热门表视图

@property (nonatomic, strong) NSMutableArray *hotListArray;//热门数据源

@end

@implementation TopicViewController

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)hotListArray {
    if (!_hotListArray) {
        self.hotListArray  = [NSMutableArray array];
    }
    return _hotListArray;
}


#pragma mark -----请求数据

//请求数据
- (void)requestDataWithSort:(NSString *)sort {
    
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort":sort, @"start":@(self.start = 0), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        //获取列表数据
        [self.listArray removeAllObjects];
        NSArray *listArr = dataDic[@"data"][@"list"];
        NSLog(@"dataDic %@",dataDic);
        for (NSDictionary *list in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfo = [[TopicUserInfoModel alloc] init];
            TopicCounterListModel *counter = [[TopicCounterListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            [counter setValuesForKeysWithDictionary:list[@"counterList"]];
            [userInfo setValuesForKeysWithDictionary:list[@"userinfo"]];
            listModel.userInfo = userInfo;
            listModel.counter = counter;
            
            [self.listArray addObject:listModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
            
        }
        
    } requsetError:^(NSError *error) {
        
    }];
    
}

//加载更多
- (void)requestDataRefreshWithSort:(NSString *)sort {
    
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort":sort, @"start":@(self.start += 10), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        //获取列表数据
        NSArray *listArr = dataDic[@"data"][@"list"];
        NSLog(@"dataDic %@",dataDic);
        for (NSDictionary *list in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfo = [[TopicUserInfoModel alloc] init];
            TopicCounterListModel *counter = [[TopicCounterListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            [counter setValuesForKeysWithDictionary:list[@"counterList"]];
            [userInfo setValuesForKeysWithDictionary:list[@"userinfo"]];
            listModel.userInfo = userInfo;
            listModel.counter = counter;
            
            [self.listArray addObject:listModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
        
    } requsetError:^(NSError *error) {
        
    }];
    
}

- (void)loadaddtimeNewData {
    [self requestDataWithSort:@"addtime"];
}

- (void)loadaddtimeMoreData {
    [self requestDataRefreshWithSort:@"addtime"];
}

- (void)loadHotNewData {
    [self requestDataWithSort:@"hot"];
}

- (void)loadHotMoreData {
    [self requestDataRefreshWithSort:@"hot"];
}


#pragma mark -----创建视图-----

- (void)createScrollView {
    self.scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    self.scorllView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    self.scorllView.contentOffset = CGPointMake(0, 0);
    self.scorllView.delegate = self;
    self.scorllView.pagingEnabled = YES;
    
    [self.view addSubview:self.scorllView];
}

- (void)createHotTableView {
    
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeNewData)];
    // 马上进入刷新状态
    [self.hotTableView.mj_header beginRefreshing];
    //上拉加载更多
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeMoreData)];
    
    [self.scorllView addSubview:self.hotTableView];
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeMoreData)];
    
    [self.scorllView addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"话题";
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"热门"]];
    self.navigationItem.titleView = self.segment;
    
    
    [self requestDataWithSort:@"hot"];
    
    [self createScrollView];
    
    [self createTableView];
    
    [self createHotTableView];
    
}


#pragma mark -----tableView-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicListModel *model = self.listArray[indexPath.row];
    BaseTableViewCell *cell = nil;
    
    if (model.coverimg.length > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"pic"];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"pic" forIndexPath:indexPath];  用加了indexPath这个参数的方法在重用池中取的cell，这个cell必须要是注册过的cell，没有注册过的cell使用没有indexPath这个参数的方法
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicListModelCell" owner:nil options:nil] lastObject];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"nopic"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoPicTopicListModelCell" owner:nil options:nil] lastObject];
        }
    }
    
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
