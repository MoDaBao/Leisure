//
//  RadioViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListModel.h"
#import "RadioCarouselModel.h"
#import "RadioDetailViewController.h"
#import "RadioListModelCell.h"

@interface RadioViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic) NSInteger start;

@property (nonatomic) NSInteger limit;
//所有电台列表数据源
@property (nonatomic, strong) NSMutableArray *allListArray;

//轮播图数据源
@property (nonatomic, strong) NSMutableArray *carouselArray;

//热门电台数据源
@property (nonatomic, strong) NSMutableArray *hotListArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;



@end

@implementation RadioViewController

- (NSMutableArray *)hotListArray {
    if (!_hotListArray) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}

- (NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray array];
    }
    return _carouselArray;
}

- (NSMutableArray *)allListArray {
    if (!_allListArray) {
        self.allListArray = [NSMutableArray array];
    }
    return _allListArray;
}

//上拉刷新请求
- (void)requestRefreshData {
    [NetWorkRequestManager requestWithType:POST urlString:RADIOMLISTMORE_URL parDic:@{@"start":@(self.start), @"limit":@(self.limit)} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        //获取所有电台列表数据
        NSArray *listArray = dataDic[@"data"][@"list"];
        for (NSDictionary *dic in listArray) {
            RadioListModel *listModel = [[RadioListModel alloc] init];
            RadioUserInfoModel *userInfo  = [[RadioUserInfoModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [userInfo setValuesForKeysWithDictionary:dic[@"userinfo"]];
            listModel.userInfo = userInfo;
            [self.allListArray addObject:listModel];
        }
        
        //回到主队列操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        

    } requsetError:^(NSError *error) {
        
    }];
}

//首次请求
- (void)requsetDataFirst {
    [NetWorkRequestManager requestWithType:POST urlString:RADIOLIST_URL parDic:nil requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        //获取所有电台列表数据
        NSArray *allListArray = dataDic[@"data"][@"alllist"];
        for (NSDictionary *dic in allListArray) {
            RadioListModel *listModel = [[RadioListModel alloc] init];
            RadioUserInfoModel *userInfo  = [[RadioUserInfoModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            [userInfo setValuesForKeysWithDictionary:dic[@"userinfo"]];
            listModel.userInfo = userInfo;
            [self.allListArray addObject:listModel];
        }
        
        
        //获取轮播图数据
        NSArray *carouselArray = dataDic[@"data"][@"carousel"];
        for (NSDictionary *causoule in carouselArray) {
            RadioCarouselModel *carouselModel = [[RadioCarouselModel alloc] init];
            [carouselModel setValuesForKeysWithDictionary:causoule];
            [self.carouselArray addObject:carouselModel];
        }
        
        //获取热门电台数据
        NSArray *hotListArray = dataDic[@"data"][@"hotlist"];
        for (NSDictionary *hotList in hotListArray) {
            RadioListModel *listModel = [[RadioListModel alloc] init];
            RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
            [listModel setValuesForKeysWithDictionary:hotList];
            [userInfo setValuesForKeysWithDictionary:hotList[@"userinfo"]];
            listModel.userInfo = userInfo;
            
            [self.hotListArray addObject:userInfo];
        }
        
        //回到主队列操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"alllist %@",self.allListArray);
            [self.tableView reloadData];

            
        });
        
    } requsetError:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.navigationItem.title = @"电台";
    
    [self requsetDataFirst];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 164 + kNavigationBarHeight, ScreenWidth, ScreenHeight - 164) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioListModel class])];
    
    [self.view addSubview:self.tableView];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, 164)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 0);
    self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    [self.view addSubview:self.scrollView];
    
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.allListArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailViewController *detailVC = [[RadioDetailViewController alloc] init];
    RadioListModel *model = self.allListArray[indexPath.row];
    detailVC.radioID = model.radioid;
    
    [self.navigationController pushViewController:detailVC animated:YES];
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
