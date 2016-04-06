//
//  RadioPlayViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioPlayViewController.h"
#import "PlayerManager.h"
#import "PlayCoverView.h"
#import "PlayRadioView.h"

@interface RadioPlayViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) PlayCoverView *playCoverView;//封面
@property (nonatomic, strong) PlayRadioView *playRadioView;//播放视图

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation RadioPlayViewController


#pragma mark -----创建播放器-----
- (void)createPlayerManager {
    //创建播放器管理对象
    PlayerManager *manager = [PlayerManager shareInstances];
    //传入播放位置
    manager.playIndex = self.selectPlayIndex;
    
    //传入播放列表
    NSMutableArray *listArray = [NSMutableArray array];
    for (RadioDetailModel *model in self.detailListArray) {
        [listArray addObject:model.musicUrl];
    }
    [manager setMusicArray:listArray];
    [manager play];//播放
    
    
}


#pragma mark -----创建视图-----

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
}

- (void)createCoverView {
    self.playCoverView = [[[NSBundle mainBundle] loadNibNamed:@"PlayCoverView" owner:nil options:nil] lastObject];
    self.playCoverView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight - 100);
    [self.playCoverView setRadioDetailModel:self.detailListArray[self.selectPlayIndex]];
    [self.scrollView addSubview:self.playCoverView];
    
}

- (void)createRadioView {
    self.playRadioView = [[[NSBundle mainBundle] loadNibNamed:@"PlayRadioView" owner:nil options:nil] lastObject];
    self.playRadioView.frame = CGRectMake(ScreenWidth, ScreenHeight - 100 - kNavigationBarHeight, ScreenWidth, 100);
    
    [self.scrollView addSubview:self.playRadioView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createScrollView];
    
    [self createCoverView];
    [self createRadioView];
    [self createPlayerManager];
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
