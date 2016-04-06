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
#import "WheelView.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

@interface ReadViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *ListDataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *carouselArray;//轮播图数据源

//轮播滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

//轮播图数据源
@property (nonatomic, strong) NSMutableArray *imageArray;

//控制轮播图滚动
@property (nonatomic, strong) NSTimer *timer;

//标记当前位置
@property (nonatomic, assign) NSInteger nowIndex;

@property (nonatomic, strong) WheelView *testScrollView;




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


- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nowIndex = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"阅读";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, 164)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self requstData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    
    [self createCollectionView];
}

//请求数据
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
            [_collectionView reloadData];
//            [self.collectionView.mj_header endRefreshing];
            [self createScrollSubviews];
            
        });
        
        
    } requsetError:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}


- (void)scroll {
    
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth * 2, 0) animated:YES];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX >= ScreenWidth * 2) {
        _nowIndex =  [self getNextIndex:_nowIndex + 1];
        [self createScrollSubviews];
    } else if (offsetX <= 0) {
        _nowIndex =  [self getNextIndex:_nowIndex - 1];
        [self createScrollSubviews];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //让计时器在未来开启 相当于暂停功能
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
}


- (void)setScrollData {
    
    [self.imageArray removeAllObjects];
    
    NSInteger befIndex = [self getNextIndex:_nowIndex - 1];
    NSInteger aftIndex = [self getNextIndex:_nowIndex + 1];
    
    [self.imageArray addObject:self.carouselArray[befIndex]];
    [self.imageArray addObject:self.carouselArray[_nowIndex]];
    [self.imageArray addObject:self.carouselArray[aftIndex]];
}

- (void)createScrollSubviews {
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self setScrollData];
    
    
    for (int i = 0; i < self.imageArray.count; i ++) {
        
        ReadCarouselModel *model = self.imageArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, 200)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        [self.scrollView addSubview:imageView];
        
        
    }
    
    self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    
    
    
}

//获取数组中元素对应的位置
- (NSInteger)getNextIndex:(NSInteger)index {
    if (index == -1) {
        return self.carouselArray.count - 1;
    } else if (index == self.carouselArray.count) {
        return 0;
    } else {
        return index;
    }
}


//创建集合视图
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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 164 + kNavigationBarHeight, kWidth, kHeight - 164) collectionViewLayout:layout];
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
