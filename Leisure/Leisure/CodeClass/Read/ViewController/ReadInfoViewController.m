//
//  ReadInfoViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ReadInfoViewController.h"
#import "ReadInfoModel.h"
#import "CommentViewController.h"

@interface ReadInfoViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) ReadInfoModel *readInfo;
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation ReadInfoViewController


#pragma mark -----请求数据-----

- (void)requsetData {
    [NetWorkRequestManager requestWithType:POST urlString:READCONTENT_URL parDic:@{@"contentid" : _contentid} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dataDic %@",dataDic);
        self.readInfo = [[ReadInfoModel alloc] init];
        [self.readInfo setValuesForKeysWithDictionary:dataDic[@"data"]];
        
        ReadInfoCounterModel *counter = [[ReadInfoCounterModel alloc] init];
        [counter setValuesForKeysWithDictionary:dataDic[@"data"][@"counterList"]];
        
        ReadShareInfoModel *shareInfo = [[ReadShareInfoModel alloc] init];
        [shareInfo setValuesForKeysWithDictionary:dataDic[@"data"][@"shareinfo"]];
        
        self.readInfo.counter = counter;
        self.readInfo.shareInfo = shareInfo;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createWebView];
        });
    } requsetError:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}


#pragma mark -----创建视图-----

- (void)createWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight)];
//    NSURLRequest *request = [NSURLRequest re]
    NSString *urlString = [NSString importStyleWithHtmlString:self.readInfo.html];
    [self.webView loadHTMLString:urlString baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    [self.view addSubview:self.webView];
}

- (void)createBarButton {
    UIButton *share = [UIButton buttonWithType:(UIButtonTypeCustom)];
    share.frame = CGRectMake(0, 0, 20, 20);
    [share setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:(UIControlStateNormal)];
    [share addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:share];
    
    self.commentBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.commentBtn.frame = CGRectMake(30, 0, 20, 20);
    [self.commentBtn setImage:[UIImage imageNamed:@"cpinglun"] forState:(UIControlStateNormal)];
    [self.commentBtn addTarget:self action:@selector(commentButton:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithCustomView:self.commentBtn];
    
    UIButton *collect = [UIButton buttonWithType:(UIButtonTypeCustom)];
    collect.frame = CGRectMake(60, 0, 20, 20);
    [collect setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:(UIControlStateNormal)];
    UIBarButtonItem *collectButton = [[UIBarButtonItem alloc] initWithCustomView:collect];
    
    self.navigationItem.rightBarButtonItems = @[shareButton, commentButton, collectButton];
}


#pragma mark -----按钮方法-----

- (void)shareAction:(UIButton *)button {
    
}

- (void)commentButton:(UIButton *)button {
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.contentid = self.contentid;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requsetData];
    
    [self createBarButton];
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
