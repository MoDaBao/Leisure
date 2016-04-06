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


#pragma mark -----创建视图-----

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)createCoverView {
    self.playCoverView = [[[NSBundle mainBundle] loadNibNamed:@"PlayCoverView" owner:nil options:nil] lastObject];
    self.playRadioView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight - 100);
    
}

- (void)createRadioView {
    self.playRadioView = [[[NSBundle mainBundle] loadNibNamed:@"PlayRadioView" owner:nil options:nil] lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
