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

@interface RadioDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *detailDataArray;//详情数据源

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIWebView *webView;



@end

@implementation RadioDetailViewController

- (NSMutableArray *)detailDataArray {
    if (!_detailDataArray) {
        self.detailDataArray = [NSMutableArray array];
    }
    return _detailDataArray;
}

- (void)requestData {
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILLIST_URL parDic:@{@"radioid":self.radioID} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSLog(@"radio detail %@",dataDic);
        
        NSArray *detailArr = dataDic[@"data"][@"list"];
        
        for (NSDictionary *dic in detailArr) {
            RadioDetailModel *model = [[RadioDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.detailDataArray addObject:model];
        }
        
        
        
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",self.detailDataArray);
            
            [self.tableView reloadData];
            
        });
        
        
        
    } requsetError:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestData];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, 164)];
    
    
    [self.view addSubview:self.webView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 164 + kNavigationBarHeight, ScreenWidth, ScreenHeight - 164) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioDetailModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioDetailModel class])];
    
    [self.view addSubview:self.tableView];
    
    
    
    
}

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
