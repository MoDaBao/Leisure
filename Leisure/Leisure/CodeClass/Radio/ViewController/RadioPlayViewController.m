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
#import "RadioPlayInfoModelCell.h"
#import "RadioPlayInfoModel.h"

@interface RadioPlayViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PlayCoverView *playCoverView;//封面
@property (nonatomic, strong) PlayRadioView *playRadioView;//播放视图

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIWebView *webView;


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
    
    //创建计时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}

//计时器方法
- (void)playing {
    
    PlayerManager *manager = [PlayerManager shareInstances];
    //给slider赋值
    self.playCoverView.playSlider.minimumValue = 0;
    self.playCoverView.playSlider.maximumValue = manager.totalTime;
    self.playCoverView.playSlider.value = manager.currentTime;
    
    //剩余时长
    self.playCoverView.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)(manager.totalTime - manager.currentTime) / 60, (NSInteger)(manager.totalTime - manager.currentTime) % 60];
    
    //如果当前播放时间等于总时长
    if (manager.currentTime == manager.totalTime && manager.totalTime!= 0) {
        [manager playDidFinsh];
    }
    
}


#pragma mark -----创建视图-----

//创建滚动视图
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

//创建封面
- (void)createCoverView {
    self.playCoverView = [[[NSBundle mainBundle] loadNibNamed:@"PlayCoverView" owner:nil options:nil] lastObject];
    self.playCoverView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight - 100);
    [self.playCoverView setRadioDetailModel:self.detailListArray[self.selectPlayIndex]];
    [self.scrollView addSubview:self.playCoverView];
    
}

//创建播放视图
- (void)createRadioView {
    UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, ScreenWidth, 100)];
    self.playRadioView = [[[NSBundle mainBundle] loadNibNamed:@"PlayRadioView" owner:nil options:nil] lastObject];
    self.playRadioView.frame = playView.bounds;
    
    // 回调播放的位置
    _playRadioView.selectRadioBlock = ^(NSInteger index){
        // 修改封面数据
//        [self.playCoverView setRadioDetailModel:self.detailListArray[index]];
        //刷新数据
        [self refreshUIWihtIndex:index];
        
    };
    
    [self.playRadioView changeTypeWithIndex:1];
    
    [playView addSubview:self.playRadioView];
    [self.view addSubview:playView];
}

//创建播放列表表视图
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight - 100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.scrollView addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioPlayInfoModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioPlayInfoModel class])];
}

//创建详情webView
- (void)createWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - kNavigationBarHeight - 100)];
    RadioDetailModel *radioDetailModel = self.detailListArray[self.selectPlayIndex];
    NSString *urlString = radioDetailModel.playInfo.webview_url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
    
    [self.scrollView addSubview:self.webView];
    
}


#pragma mark -----播放结束的通知方法-----

- (void)playDidFinshed:(NSNotification *)notification {
    //刷新UI
    [self refreshUIWihtIndex:[PlayerManager shareInstances].playIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createScrollView];
    [self createCoverView];
    [self createRadioView];
    
    [self createTableView];
    [self createWebView];
    [self createPlayerManager];
    
    //  注册消息中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinshed:) name:@"PLAYDIDFINISH" object:nil];
    
    [self refreshUIWihtIndex:self.selectPlayIndex];
    
}


#pragma mark -----刷新UI-----

- (void)refreshUIWihtIndex:(NSInteger)index {
    
    //根据播放位置获取模型
    RadioDetailModel *model = self.detailListArray[index];
    
    //刷新webView
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.playInfo.webview_url]];
    [self.webView loadRequest:request];
    
    //coverView
    [self.playCoverView setRadioDetailModel:model];
    
    //tableView
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectPlayIndex inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];//取消上次选中
    //设置当前选中
    indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    RadioPlayInfoModelCell *cell = (RadioPlayInfoModelCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.markView.backgroundColor = [UIColor orangeColor];
    
    self.selectPlayIndex = index;
    
    
}


#pragma mark -----scrollViewDelegate-----

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        [self.playRadioView changeTypeWithIndex:scrollView.contentOffset.x / ScreenWidth];
    }
}


#pragma mark -----tableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseModel *model = ((RadioDetailModel *)self.detailListArray[indexPath.row]).playInfo;
    NSLog(@"%@",NSStringFromClass([model class]));
    NSLog(@"model %@",model);
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前点中的cell
    RadioPlayInfoModelCell *cell = (RadioPlayInfoModelCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.markView.backgroundColor = [UIColor orangeColor];
    //刷新UI
    [self refreshUIWihtIndex:indexPath.row];
    
    //播放
    PlayerManager *manager = [PlayerManager shareInstances];
    [manager changeMusicWithIndex:indexPath.row];

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
