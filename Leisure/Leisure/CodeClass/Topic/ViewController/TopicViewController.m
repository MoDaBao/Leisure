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

@property (nonatomic) NSInteger start;

@property (nonatomic) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIScrollView *scorllView;

@property (nonatomic, strong) UITableView *hotTableView;

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
        NSLog(@"dataDic %@",dataDic);
        for (NSDictionary *list in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfo = [[TopicUserInfoModel alloc]init];
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

- (void)createScrollView {
    self.scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    self.scorllView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    self.scorllView.contentOffset = CGPointMake(0, 0);
    self.scorllView.delegate = self;
    
    
    [self.view addSubview:self.scorllView];
}

- (void)createHotTableView {
    
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    
    [self.scorllView addSubview:self.hotTableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"话题";
    
    [self requestDataWithSort:@"hot"];
    
    
    [self createScrollView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TopicListModel class])];
    
    
    
    
    [self.scorllView addSubview:self.tableView];
    
    [self createHotTableView];
    
    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"热门"]];
    
    
    self.navigationItem.titleView = self.segment;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"TopicListModelCell" owner:nil options:nil];
    
    BaseModel *model = self.listArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
    
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
