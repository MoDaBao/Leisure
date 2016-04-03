//
//  ReadViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadDetailViewController.h"
#import "ReadCarouselModel.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

@interface ReadViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *ListDataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *carouselArray;//轮播图数据源




@end

@implementation ReadViewController

- (NSMutableArray *)ListDataArray {
    if (_ListDataArray == nil) {
        self.ListDataArray = [NSMutableArray array];
    }
    return _ListDataArray;
}

- (NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray array];
    }
    return _carouselArray;
}

- (void)requstData {
    [NetWorkRequestManager requestWithType:POST urlString:READLIST_URL parDic:nil requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        //获取列表数据源
        NSDictionary *listDic = dataDic[@"data"];
        NSArray *arr = listDic[@"list"];
        for (NSDictionary *dic in arr) {
            ReadListModel *model = [[ReadListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.ListDataArray addObject:model];
        }
        
        
        //获取轮播图数据源
        NSArray *carouselArray = dataDic[@"data"][@"carousel"];
        for (NSDictionary *dic in carouselArray) {
            ReadCarouselModel *model = [[ReadCarouselModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.carouselArray addObject:model];
        }
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            NSLog(@"list %@",self.ListDataArray);
            
            NSLog(@"carousel %@",self.carouselArray);
            
            [_collectionView reloadData];
        });
        
        
    } requsetError:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"阅读";
        
    [self requstData];
    
    [self createCollectionView];
}

- (void)createCollectionView { 
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置行之间的最小间隔
    layout.minimumLineSpacing = 10;
    //设置列之间的最小间隔
    layout.minimumInteritemSpacing = 2;
    //设置item（cell）的大小
    layout.itemSize = CGSizeMake((kWidth - 4 * 10) / 3, kWidth / 3 );
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 164, kWidth, kHeight - 164) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"ReadListModelCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ReadListModel class])];
    
    [self.view addSubview:_collectionView];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ListDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.ListDataArray[indexPath.row];
    
    BaseCollectionViewCell *cell = [FactoryCollectionViewCell createCollectionViewCell:model andCollectionView:collectionView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadDetailViewController *readDetailVC = [[ReadDetailViewController alloc] init];
    ReadListModel *model = self.ListDataArray[indexPath.item];
    
    readDetailVC.typeID = model.type;
    
    [self.navigationController pushViewController:readDetailVC animated:YES];
    
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
