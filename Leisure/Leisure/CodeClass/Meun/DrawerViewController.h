//
//  DrawerViewController.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerViewController : UIViewController

/**
 抽屉的根视图控制器
 */
@property (nonatomic, strong) UIViewController *rootViewController;

/**
 抽屉的左菜单视图控制器
 */
@property (nonatomic, strong) UIViewController *leftViewController;

/**
 当菜单成为第一响应者，通过手势进行返回
 */
@property (nonatomic, readonly) UITapGestureRecognizer *tap;



/**
 *  自定义初始化方法，在初始化方法中设置根视图控制器对象
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

/**
 *  设置根视图控制器
 */
- (void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated;

/**
 *  显示根视图
 */
- (void)showRootViewController:(BOOL)animated;

/**
 *  显示左边菜单栏视图
 */
- (void)showLeftViewController:(BOOL)animated;









@end
