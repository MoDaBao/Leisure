//
//  ReadDetailViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailModel.h"
#import "ReadDetailModelCell.h"
#import "ReadInfoViewController.h"

@interface ReadDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic) NSInteger start;//请求开始的位置
@property (nonatomic) NSInteger limit;//每次请求的数据条数
@property (nonatomic, assign) NSInteger addtimeStart; // 最新开始的位置
@property (nonatomic, assign) NSInteger hotStart; // 热门开始的位置

@property (nonatomic, strong) NSMutableArray *hotListArray;//热门

@property (nonatomic, strong) NSMutableArray *addtimeListArray;//最新

@property (nonatomic, assign) NSInteger requestSort;//请求数据的类型 0最新 1热门

@property (nonatomic, strong) UITableView *tableView;//最新表视图

@property (nonatomic, strong) UIScrollView *scrollView;//滚动视图

@property (nonatomic, strong) UITableView *hotTableView;//热门表视图

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, copy) NSString *sort;

@end

@implementation ReadDetailViewController


#pragma mark -----loadLazy-----

- (NSMutableArray *)hotListArray {
    if (_hotListArray == nil) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}

- (NSMutableArray *)addtimeListArray {
    if (_addtimeListArray == nil) {
        self.addtimeListArray = [NSMutableArray array];
    }
    return _addtimeListArray;
}


#pragma mark -----数据加载-----

- (void)loadaddtimeNewData {
    _addtimeStart = 0;
    [self requestWithSort:@"addtime"];
}

- (void)loadaddtimeMoreData {
    _addtimeStart += _limit;
    [self requestWithSort:@"addtime"];
}

- (void)loadhotNewData {
    _hotStart = 0;
    [self requestWithSort:@"hot"];
}

- (void)loadhotMoreData {
    _hotStart += _limit;
    [self requestWithSort:@"hot"];
}

/**
 *  请求数据
 */
- (void)requestWithSort:(NSString *)sort {
    
    // 确定请求开始的位置
    if ([sort isEqualToString:@"hot"]) {
        _start = _hotStart;
    } else {
        _start = _addtimeStart;
    }

    
    [NetWorkRequestManager requestWithType:POST urlString:READDETAILLIST_URL parDic:@{@"typeid" : _typeID, @"start" : @(_start), @"limit" : @(_limit), @"sort" : sort} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSArray *listArr = dataDic[@"data"][@"list"];
        //        NSLog(@"datadic %@",dataDic);
        self.sort = sort;
        
        // 确定是否清空数组
        if ([sort isEqualToString:@"hot"]) {
            if (_start == 0) {
                [self.hotListArray removeAllObjects];
            }
        } else {
            if (_start == 0) {
                [self.addtimeListArray removeAllObjects];
            }
        }
        
        for (NSDictionary *dic in listArr) {
            ReadDetailModel *model = [[ReadDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if ([sort isEqualToString:@"addtime"]) {
                [self.addtimeListArray addObject:model];
            } else {
                [self.hotListArray addObject:model];
            }
        }
        //回到主线程
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            if ([sort isEqualToString:@"addtime"]) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.hotTableView.mj_header endRefreshing];
                [self.hotTableView.mj_footer endRefreshing];
                [self.hotTableView reloadData];
            }
        });
        
    } requsetError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

///**
// *  上拉加载
// */
//- (void)requestRefreshDataWithSort:(NSString *)sort {
//    [NetWorkRequestManager requestWithType:POST urlString:READDETAILLIST_URL parDic:@{@"typeid" : _typeID, @"start" : @(_start += 10), @"limit" : @(_limit), @"sort" : sort} requestFinish:^(NSData *data) {
//        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//        
//        self.sort = sort;
//        NSArray *listArr = dataDic[@"data"][@"list"];
//        for (NSDictionary *dic in listArr) {
//            ReadDetailModel *model = [[ReadDetailModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
//            if ([sort isEqualToString:@"addtime"]) {
//                [self.addtimeListArray addObject:model];
//            } else {
//                [self.hotListArray addObject:model];
//            }
//        }
//        //回到主线程
//        dispatch_queue_t mainQueue = dispatch_get_main_queue();
//        dispatch_async(mainQueue, ^{
//            
//            if ([sort isEqualToString:@"addtime"]) {
//                [self.tableView.mj_footer endRefreshing];
//                [self.tableView reloadData];
//            } else {
//                [self.hotTableView.mj_footer endRefreshing];
//                [self.hotTableView reloadData];
//            }
//            
//        });
//        
//        
//        
//    } requsetError:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}


#pragma mark -----创建视图-----

//创建滚动视图
- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    [self.view addSubview:self.scrollView];
}

//创建热门表视图
- (void)createHotTableView {
    
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    [self.hotTableView registerNib:[UINib nibWithNibName:@"ReadDetailModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadhotNewData)];
    // 马上进入刷新状态
    [self.hotTableView.mj_header beginRefreshing];
    //上拉加载更多
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadhotMoreData)];
    
    [self.scrollView addSubview:self.hotTableView];
    
//    [self loadhotNewData];
    
}

//创建最新表视图
- (void)createAddTimeTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ReadDetailModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadaddtimeMoreData)];
    
    [self.scrollView addSubview:self.tableView];
    
    [self loadaddtimeNewData];
}


#pragma mark -----viewDidLoad-----

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestSort = 0;//默认请求最新
    _start = 0;//默认第一条数据为起始位置
    _limit = 10;//默认每次请求10条数据
    _addtimeStart = 0;
    _hotStart = 0;
    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"热门"]];
    self.segment.frame = CGRectMake(0, 0, 100, 30);
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment;
    
    [self createScrollView];
    [self createAddTimeTableView];
    [self createHotTableView];
    
    
    
}

//segment值改变时触发的方法
- (void)change:(UISegmentedControl *)segment {
    //计算偏移量
    CGPoint offset = CGPointMake(segment.selectedSegmentIndex * ScreenWidth, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    
    if (segment.selectedSegmentIndex) {
        _requestSort = 1;
        if (self.hotListArray.count) {
            return;
        }
        [self loadhotNewData];
    } else {
        _requestSort = 0;
        if (self.addtimeListArray.count) {
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
    //根据标识来确定数据源
    return _requestSort == 0 ? self.addtimeListArray.count : self.hotListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = nil;
    
    model = (_requestSort == 0) ? self.addtimeListArray[indexPath.row] : self.hotListArray[indexPath.row];
    if ([self.sort isEqualToString:@"addtime"]) {
        model = self.addtimeListArray[indexPath.row];
    } else {
        model = self.hotListArray[indexPath.row];
    }
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    ((ReadDetailModelCell *)cell).coverImageView.image = nil;
    
    [cell setDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailModel *model = (_requestSort == 0) ? self.addtimeListArray[indexPath.row] : self.hotListArray[indexPath.row];
    ReadInfoViewController *readInfoVC = [[ReadInfoViewController alloc] init];
    readInfoVC.contentid = model.contentID;
    readInfoVC.detailModel = model;
    [self.navigationController pushViewController:readInfoVC animated:YES];
}


#pragma mark -----scrollViewDelegate-----

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x == 0) {
        self.segment.selectedSegmentIndex = 0;
        _requestSort = 0;
//        if (!self.addtimeListArray.count) {
//            return;
//        }
//        [self loadaddtimeNewData];
    } else if (self.scrollView.contentOffset.x == ScreenWidth) {
        self.segment.selectedSegmentIndex = 1;
        _requestSort = 1;
        if (!self.hotListArray.count) {
            return;
        }
        [self loadhotNewData];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.scrollView.contentOffset.x > 0) {
//        if (_hotListArray.count == 0) {
//            [self requestWithSort:@"hot"];
//        }
//    }
//}



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
