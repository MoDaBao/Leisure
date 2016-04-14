//
//  ConstantHeaderDefine.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#ifndef ConstantHeaderDefine_h
#define ConstantHeaderDefine_h


/**
 *  屏幕宽度
 */
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

/**
 *  屏幕高度
 */
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 *  导航条高度
 */
#define kNavigationBarHeight 64

#pragma mark -数据库-
#define SQLITENAME           @"leisure.sqlite" // 数据库名
#define READDETAILTABLE      @"ReadDetail" // 阅读详情数据表
#define RADIODETAILTABLE     @"RadioDetail"// 电台详情表明
#define RADIOPLAYINFOTABLE   @"RadioPlayInfo"//


#endif /* ConstantHeaderDefine_h */
