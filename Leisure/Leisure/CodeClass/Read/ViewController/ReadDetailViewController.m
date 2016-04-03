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

@interface ReadDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSInteger start;//请求开始的位置

@property (nonatomic) NSInteger limit;//每次请求的数据条数

@property (nonatomic, strong) NSMutableArray *hotListArray;//热门

@property (nonatomic, strong) NSMutableArray *addtimeListArray;//最新

@property (nonatomic, assign) NSInteger requestSort;//请求数据的类型 0最新 1热门

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ReadDetailViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _requestSort = 0;//默认请求最新
    
    [self requestWithSort:@"addtime"];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReadDetailModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"最新", @"热门"]];
    segment.frame = CGRectMake(0, 0, 100, 30);
    
//    CGPoint newCenter = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, segment.center.y);
//    
//    segment.center = newCenter;
    
    segment.selectedSegmentIndex = 0;
    
    [segment addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
    
//    [self.tableView addSubview:segment];
    
//    self.tableView.tableHeaderView = segment;
    
    self.navigationItem.titleView = segment;
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)change {
    
    NSLog(@"change");
    
    
    
    
}

- (void)requestWithSort:(NSString *)sort {
    [NetWorkRequestManager requestWithType:POST urlString:READDETAILLIST_URL parDic:@{@"typeid" : _typeID, @"start" : @(_start), @"limit" : @(_limit), @"sort" : sort} requestFinish:^(NSData *data) {
        
        NSLog(@"data %@",data);
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSArray *listArr = dataDic[@"data"][@"list"];
        NSLog(@"%@",listArr);
        for (NSDictionary *dic in listArr) {
            ReadDetailModel *model = [[ReadDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if (0 ==  self.requestSort) {
                [self.addtimeListArray addObject:model];
            } else {
                [self.hotListArray addObject:model];
            }
        }
        //回到主线程
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            [self.tableView reloadData];
            
        });
        
        
        
    } requsetError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //根据标识来确定数据源
    return _requestSort == 0 ? self.addtimeListArray.count : self.hotListArray.count;
    
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    BaseModel *model = self.hotListArray[indexPath.row];
    
    BaseModel *model = nil;
    
    model = (_requestSort == 0) ? self.addtimeListArray[indexPath.row] : self.hotListArray[indexPath.row];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    ((ReadDetailModelCell *)cell).coverImageView.image = nil;
    
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
