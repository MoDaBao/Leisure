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
@property (nonatomic, assign) NSInteger addtimeStart; // 最新开始的位置
@property (nonatomic, assign) NSInteger hotStart; // 热门开始的位置

@property (nonatomic, strong) NSMutableArray *listArray;//最新数据源

@property (nonatomic, strong) UITableView *tableView;//最新表视图

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIScrollView *scorllView;//滚动视图

@property (nonatomic, strong) UITableView *hotTableView;//热门表视图

@property (nonatomic, strong) NSMutableArray *hotListArray;//热门数据源

@property (nonatomic, assign) NSInteger requestSort;//0代表最新 1代表热门

@end

@implementation TopicViewController


#pragma mark -----loadLazy-----

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


#pragma mark -----请求数据-----

//请求数据
- (void)requestDataWithSort:(NSString *)sort {
    if ([sort isEqualToString:@"hot"]) {
        _start = _hotStart;
    } else {
        _start = _addtimeStart;
    }
    
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort":sort, @"start":@(self.start), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        //是否移除原有数据
        if (_start == 0) {
            if ([sort isEqualToString:@"addtime"]) {
                [self.listArray removeAllObjects];
            } else {
                [self.hotListArray removeAllObjects];
            }
        }
        
        //获取列表数据
        NSArray *listArr = dataDic[@"data"][@"list"];
//        NSLog(@"dataDic %@",dataDic);
        for (NSDictionary *dic in listArr) {
            [self setValueForModelWithDic:dic sort:sort];//通过字典给模型赋值并且添加到对应的数组中
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新表视图and停止MJRefresh刷新
            [self reloadTableViewAndEndRefreshingWithSort:sort];
//            if (_hotTableView == nil) {
//                [self createHotTableView];
//            }
            
            });
    } requsetError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

//加载更多
//- (void)requestDataRefreshWithSort:(NSString *)sort {
//    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort":sort, @"start":@(self.start += 10), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
//        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//        //获取列表数据
//        NSArray *listArr = dataDic[@"data"][@"list"];
////        NSLog(@"dataDic %@",dataDic);
//        for (NSDictionary *dic in listArr) {
//            [self setValueForModelWithDic:dic sort:sort];//通过字典给模型赋值并且添加到对应的数组中
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //刷新表视图and停止MJRefresh刷新
//            [self reloadTableViewAndEndRefreshingWithSort:sort];
//        });
//        
//    } requsetError:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    
//}

//通过字典给模型赋值并且添加到对应的数组中
- (void)setValueForModelWithDic:(NSDictionary *)dic sort:(NSString *)sort {
    
    TopicListModel *listModel = [[TopicListModel alloc] init];
    TopicUserInfoModel *userInfo = [[TopicUserInfoModel alloc] init];
    TopicCounterListModel *counter = [[TopicCounterListModel alloc] init];
    
    [listModel setValuesForKeysWithDictionary:dic];
    [counter setValuesForKeysWithDictionary:dic[@"counterList"]];
    [userInfo setValuesForKeysWithDictionary:dic[@"userinfo"]];
    
    listModel.userInfo = userInfo;
    listModel.counter = counter;
    
    [self addArrayWithModel:listModel bySort:sort];//将模型加进数组

}

//添加数据到数组
- (void)addArrayWithModel:(TopicListModel *)model bySort:(NSString *)sort {
    if ([sort isEqualToString:@"hot"]) {
        [self.hotListArray addObject:model];
    } else {
        [self.listArray addObject:model];
    }
}

//刷新表视图脚视图and停止MJRefresh刷新
- (void)reloadTableViewAndEndRefreshingWithSort:(NSString *)sort {
//    NSLog(@"_listArray is %@",self.listArray);
//    NSLog(@"_hotListArray is %@",self.hotListArray);
    if ([sort isEqualToString:@"addtime"]) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } else {
        [self.hotTableView.mj_footer endRefreshing];
        [self.hotTableView.mj_header endRefreshing];
        [self.hotTableView reloadData];
        
    }
}

//刷新最新数据
- (void)loadaddtimeNewData {
    _requestSort = 0;
    _addtimeStart = 0;
    _limit = 10;
    [self requestDataWithSort:@"addtime"];
}

//加载更多最新数据
- (void)loadaddtimeMoreData {
    _requestSort = 0;
    _addtimeStart += _limit;
    [self requestDataWithSort:@"addtime"];
}

//刷新热门数据
- (void)loadHotNewData {
    _requestSort = 1;
    _hotStart = 0;
    _limit = 10;
    [self requestDataWithSort:@"hot"];
}

//加载更多热门数据
- (void)loadHotMoreData {
    _requestSort = 1;
    _hotStart += _limit;
    [self requestDataWithSort:@"hot"];
}


#pragma mark -----创建视图-----

- (void)createScrollView {
    self.scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    self.scorllView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    self.scorllView.contentOffset = CGPointMake(0, 0);
    self.scorllView.delegate = self;
    self.scorllView.pagingEnabled = YES;
    self.scorllView.showsHorizontalScrollIndicator = NO;
    self.scorllView.bounces = NO;
    
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
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHotNewData)];
    // 马上进入刷新状态
//    [self.hotTableView.mj_header beginRefreshing];
    //上拉加载更多
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadHotMoreData)];
    
    [self.scorllView addSubview:self.hotTableView];
    
//    [self loadHotNewData];
    
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
    
//    [self loadaddtimeNewData];
}


#pragma mark -----viewDidLoad-----

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"话题";
    
    _requestSort = 0;//默认请求最新
    _addtimeStart = 0;
    _hotStart = 0;
    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"热门"]];
    [self.segment addTarget:self action:@selector(chang:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
    self.segment.selectedSegmentIndex = 0;
    
    [self createScrollView];
    [self createTableView];
    [self createHotTableView];
    
    [self requestDataWithSort:@"addtime"];
    
}


#pragma mark -----segment的target方法-----

- (void)chang:(UISegmentedControl *)segment {
    //计算偏移量
    CGPoint offset = CGPointMake(segment.selectedSegmentIndex * ScreenWidth, 0);
    [self.scorllView setContentOffset:offset animated:YES];
    
    if (segment.selectedSegmentIndex) {
        _requestSort = 1;
        if (self.hotListArray.count) {
            return;
        }
        [self loadHotNewData];
    } else {
        _requestSort = 0;
        if (self.listArray.count) {
            return;
        }
        [self loadaddtimeNewData];
    }
    
}

#pragma mark -----tableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_requestSort == 0) ? self.listArray.count : self.hotListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicListModel *model = (_requestSort == 0) ? self.listArray[indexPath.row] : self.hotListArray[indexPath.row];
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


#pragma mark -----scorllViewDelegate-----

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scorllView) {
        int num = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
        if (0 == num) {
            _requestSort = 0;
            _segment.selectedSegmentIndex = 0;
//            if (self.listArray.count != 0) {
//                return;
//            }
//            [self loadaddtimeNewData];
        } else {
            _requestSort = 1;
            _segment.selectedSegmentIndex = 1;
            if (_hotListArray.count != 0) {
                return;
            }
            [self loadHotNewData];
        }
    }
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
