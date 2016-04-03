//
//  DrawerViewController.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DrawerViewController.h"
#define kMenuFullWidth [[UIScreen mainScreen] bounds].size.width
#define kMenuDisplayedWidth 280.0f//菜单显示的高度

@interface DrawerViewController ()<UIGestureRecognizerDelegate>

/**
 *  能否显示左菜单
 */
@property (nonatomic, assign) BOOL canShowLeft;

/**
 *  是否正在显示左菜单
 */
@property (nonatomic, assign) BOOL isShowingLeft;

@end

@implementation DrawerViewController



/**
 *  自定义初始化方法，在初始化方法中设置根视图控制器对象
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        self.rootViewController = rootViewController;
    }
    return self;
    
}


/**
 *  设置导航试图控制器上的按钮
 */
- (void)setNaVCButton {
    if (!_rootViewController) {
        return;
    }
    
    //找到最顶层的视图控制器
    UIViewController *topVC = nil;
    if ([_rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naVC = (UINavigationController *)_rootViewController;
        if (naVC.viewControllers.count > 0 ) {
            topVC = [naVC.viewControllers objectAtIndex:0];
        }
    } else {
        topVC = _rootViewController;
    }
    
    //添加导航栏按钮
    if (_canShowLeft) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_menu_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft:)];
        topVC.navigationItem.leftBarButtonItem = item;
    } else {
        topVC.navigationItem.leftBarButtonItem = nil;
    }
    
}

/**
 *  导航栏按钮方法
 */
- (void)showLeft:(id)sender {
    [self showLeftViewController:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setRootViewController:_rootViewController];
    
    if (!_tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.view addGestureRecognizer:tap];
        tap.delegate = self;
        [tap setEnabled:NO];
        _tap = tap;
    }
}




#pragma mark -----手势方法-----

/**
 *  tap手势方法
 */
- (void)tap:(UITapGestureRecognizer *)tap {
    [tap setEnabled:NO];
    [self showRootViewController:YES];
}

/**
 *  手势代理方法
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _tap) {
        if (_rootViewController && _isShowingLeft) {
            //设置单击手势响应的范围
            return CGRectContainsPoint(_rootViewController.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        return NO;
    }
    return YES;
}


#pragma mark -----显示视图——----

/**
 *  显示根视图
 */
- (void)showRootViewController:(BOOL)animated {
    [_tap setEnabled:NO];//让单击手势不能响应
    //设置根视图能交互
    _rootViewController.view.userInteractionEnabled = YES;
    
    CGRect frame = _rootViewController.view.frame;
    frame.origin.x = 0.0f;
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    [UIView animateWithDuration:.3 animations:^{
        _rootViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        if (_leftViewController && _leftViewController.view.superview) {
            [_leftViewController.view removeFromSuperview];
        }
        _isShowingLeft = NO;
    }];
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
}

/**
 *  显示左边菜单栏视图
 */
- (void)showLeftViewController:(BOOL)animated {
    //如果菜单不能显示，直接跳出
    if (!_canShowLeft) {
        return;
    }
    
    //设置菜单正在显示
    _isShowingLeft = YES;
    
    UIView *view = self.leftViewController.view;
    CGRect frame = self.view.bounds;
    frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    [self.leftViewController viewWillAppear:animated];
    
    frame = _rootViewController.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _rootViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _rootViewController.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];//激活单击手势
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
}


#pragma mark -----设置根视图控制器对象和左菜单视图控制器对象-----

- (void)setRootViewController:(UIViewController *)rootViewController {
    UIViewController *tempRootVC = _rootViewController;
    _rootViewController = rootViewController;
    if (_rootViewController) {
        if (tempRootVC) {
            [tempRootVC.view removeFromSuperview];
            tempRootVC = nil;
        }
        UIView *view = _rootViewController.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
    } else {
        if (tempRootVC) {
            [tempRootVC.view removeFromSuperview];
            tempRootVC = nil;
        }
    }
    
    [self setNaVCButton];
    
}

/**
 *  设置根视图控制器
 */
- (void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated {
    if (!rootViewController) {
        [self setRootViewController:rootViewController];
        return;
    }
    if (_isShowingLeft) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        __block DrawerViewController *selfRef = self;
        __block UIViewController *rootRef = _rootViewController;
        
        CGRect frame = rootRef.view.frame;
        frame.origin.x = rootRef.view.bounds.size.width;
        
        [UIView animateWithDuration:.1 animations:^{
            rootRef.view.frame = frame;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [selfRef setRootViewController:rootViewController];
            _rootViewController.view.frame = frame;
            [selfRef showRootViewController:animated];
        }];
    } else {
        [self setRootViewController:rootViewController];
        [self showRootViewController:YES];
    }
    
    
}


/**
 *  设置左菜单视图控制器
 */
- (void)setLeftViewController:(UIViewController *)leftViewController {
    _leftViewController = leftViewController;
    _canShowLeft = (_leftViewController != nil);
    [self setNaVCButton];
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
