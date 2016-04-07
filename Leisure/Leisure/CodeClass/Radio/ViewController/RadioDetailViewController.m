//
//  RadioDetailViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioDetailModel.h"
#import "RadioDetailModelCell.h"
#import "RadioPlayViewController.h"
#import "RadioDetailInfoView.h"

@interface RadioDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *detailDataArray;//详情数据源

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) RadioDetailInfoView *headView;



@end

@implementation RadioDetailViewController


#pragma mark -----loadLazy-----

- (NSMutableArray *)detailDataArray {
    if (!_detailDataArray) {
        self.detailDataArray = [NSMutableArray array];
    }
    return _detailDataArray;
}


#pragma mark -----请求数据-----

- (void)requestData {
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILLIST_URL parDic:@{@"radioid":self.radioID} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSLog(@"radio detail %@",dataDic);
        
        NSArray *detailArr = dataDic[@"data"][@"list"];
        // 获取电台信息
        RadioInfoModel *radioInfo = [[RadioInfoModel alloc] init];
        [radioInfo setValuesForKeysWithDictionary:dataDic[@"data"][@"radioInfo"]];
        RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
        [userInfo setValuesForKeysWithDictionary:dataDic[@"data"][@"radioInfo"][@"userinfo"]];
        radioInfo.userInfo = userInfo;
        
        for (NSDictionary *list in detailArr) {
            RadioDetailModel *detailListModel = [[RadioDetailModel alloc] init];
            [detailListModel setValuesForKeysWithDictionary:list];
            
            // 创建playinfo
            RadioPlayInfoModel *playInfo = [[RadioPlayInfoModel alloc] init];
            [playInfo setValuesForKeysWithDictionary:list[@"playInfo"]];
            
            // 创建authorinfo
            RadioUserInfoModel *authorInfo = [[RadioUserInfoModel alloc] init];
            [authorInfo setValuesForKeysWithDictionary:list[@"playInfo"][@"authorinfo"]];
            playInfo.authorInfo = authorInfo;
            
            // 创建shareinfo
            RadioShareInfoModel *shareInfo = [[RadioShareInfoModel alloc] init];
            [shareInfo setValuesForKeysWithDictionary:list[@"playInfo"][@"shareinfo"]];
            playInfo.shareInfo = shareInfo;
            
            // 创建userinfo
            RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
            [userInfo setValuesForKeysWithDictionary:list[@"playInfo"][@"userinfo"]];
            playInfo.userInfo = userInfo;
            
            detailListModel.playInfo = playInfo;
            
            
            [self.detailDataArray addObject:detailListModel];
        }
        
        
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",self.detailDataArray);
            [self.headView setDataWithModel:radioInfo];
            [self.tableView reloadData];
            
        });
        
        
        
    } requsetError:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}


#pragma mark -----创建视图-----

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioDetailModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioDetailModel class])];
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"RadioDetailInfoView" owner:nil options:nil] lastObject];
    self.headView.frame = CGRectMake(0, 0, ScreenWidth, 235);
    self.tableView.tableHeaderView = self.headView;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestData];
    
    [self createTableView];
    
}


#pragma mark -----tableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.detailDataArray[indexPath.row];
//    RadioDetailModel *model = [[RadioDetailModel alloc] init];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    RadioDetailModel *model = self.detailDataArray[indexPath.row];
    
    RadioPlayViewController *radioPlayVC = [[RadioPlayViewController alloc] init];
//    radioPlayVC.typeID = model.
    radioPlayVC.selectPlayIndex = indexPath.row;
    radioPlayVC.detailListArray = _detailDataArray;
//    radioPlayVC.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController pushViewController:radioPlayVC animated:YES];
    
    
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
