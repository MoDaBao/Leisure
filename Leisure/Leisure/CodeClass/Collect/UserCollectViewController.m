//
//  UserCollectViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UserCollectViewController.h"
#import "ReadDetailDB.h"
#import "ReadInfoViewController.h"
#import "ReadDetailModel.h"

@interface UserCollectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation UserCollectViewController


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ReadDetailModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收藏";
    
    //创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"icon-1460114980616"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    [self createTableView];
    
    [self findDB];
    
}

- (void)findDB {
    ReadDetailDB *db = [[ReadDetailDB alloc] init];
    _dataArray = [[db selectAllDataWithUserID:[UserInfoManager getUserID]] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark -----返回按钮方法-----

- (void)back:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -----tableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseModel *model = self.dataArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    [cell setDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailModel *model = self.dataArray[indexPath.row];
    ReadInfoViewController *readInfoVC = [[ReadInfoViewController alloc] init];
    readInfoVC.contentid = model.contentID;
    readInfoVC.detailModel = model;
    
    [self.navigationController pushViewController:readInfoVC animated:YES];
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
