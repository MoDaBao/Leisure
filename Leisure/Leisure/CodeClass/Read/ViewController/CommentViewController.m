//
//  CommentViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CommentViewController.h"
#import "KeyBoardView.h"
#import "CommentModel.h"

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource,KeyBoardViewDelegate>

@property (nonatomic, strong) UITableView *commentTableView;

@property (assign) NSInteger start; // 上拉请求开始位置
@property (assign) NSInteger limit; // 每次请求的条数
@property (nonatomic, strong) NSMutableArray *commentArray; // 评论数据源

@property (nonatomic, strong) KeyBoardView *keyView;
@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@end

@implementation CommentViewController


#pragma mark -----loadLazy-----

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        self.commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

#pragma mark -----请求数据-----

//获取数据
- (void)requestData {
    [NetWorkRequestManager requestWithType:POST urlString:GETCOMMENT_url parDic:@{@"auth" : [UserInfoManager getUserAuth], @"contentid" : _contentid, @"start":[NSString stringWithFormat:@"%ld", _start], @"limit":[NSString stringWithFormat:@"%ld", _limit]} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        [self.commentArray removeAllObjects];
        
        
        for (NSDictionary *dic in dataDic[@"data"][@"list"]) {
            // 创建model对象
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            CommentUserModel *userInfo = [[CommentUserModel alloc] init];
            [userInfo setValuesForKeysWithDictionary:dic[@"userinfo"]];
            
            model.userInfo = userInfo;
            
            [self.commentArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentTableView reloadData];
        });
    } requsetError:^(NSError *error) {
        
    }];
}

//  发表评论
- (void)requestSendComment:(NSString *)comment {
    [NetWorkRequestManager requestWithType:POST urlString:ADDCOMMENT_url parDic:@{@"auth" : [UserInfoManager getUserAuth], @"contentid" : _contentid, @"content" : comment} requestFinish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dataDic = %@", dataDic);
        NSNumber *result = [dataDic objectForKey:@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 发送成功
            if ([result intValue] == 1) {
                [self requestData];
            }
        });
    } requsetError:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

#pragma mark -----创建视图-----

//创建表视图
- (void)createCommentTableView {
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self.commentTableView registerNib:[UINib nibWithNibName:@"CommentModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CommentModel class])];
    
    [self.view addSubview:self.commentTableView];
}

//创建按钮
- (void)createButton {
    //  发表评论按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 20, 20);
    [sendButton setBackgroundImage:[UIImage imageNamed:@"sendpinglun"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItems = @[addButton];
}

- (void)addBtn:(UIButton *)button {
//    [self requestSendComment:self.keyView.textView.text];
    if (!self.keyView) {
        self.keyView = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    }
    self.keyView.delegate = self;
    [self.keyView.textView becomeFirstResponder];//成为第一响应者
    self.keyView.textView.returnKeyType = UIReturnKeySend;//设置return键样式为send
    [self.view addSubview:self.keyView];
}


#pragma mark -----viewDidLoad-----

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestData];
    [self createCommentTableView];
    [self createButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -----通知方法-----

//显示键盘
- (void)keyBoardShow:(NSNotification *)notification {
    //  获取键盘的大小
    CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    self.keyBoardHeight = deltaY;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyBoardHidden:(NSNotification *)notification {
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.keyView.textView.text = @"";
        [self.keyView removeFromSuperview];
    }];
}


#pragma mark -----输入框代理方法-----

- (void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView {
    [contentView resignFirstResponder];
    [self requestSendComment:contentView.text];
}


#pragma mark -----tableViewDelegate-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseModel *model = self.commentArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
}


#pragma mark -----didReceiveMemoryWarning-----

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
