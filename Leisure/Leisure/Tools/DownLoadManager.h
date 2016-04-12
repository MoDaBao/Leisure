//
//  DownLoadManager.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/12.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoad : NSObject

//  监控下载进度
@property (nonatomic, copy) void (^downLoading)(float);

//  下载完成,将下载地址和文件本地路径传出
@property (nonatomic, copy) void (^downloadFinish) (NSString *url, NSString *savePath);

//  自定义初始化方法，传入下载的地址
- (instancetype)initWithURLPath:(NSString *)urlPath;

//  开始下载
- (void)start;

//  暂停下载
- (void)pause;


@end


@interface DownLoadManager : NSObject

//  单例方法
+ (DownLoadManager *)shareInstance;

//  添加下载对象的方法
- (DownLoad *)addDownLoadWithUrl:(NSString *)url;

//  移除完成的下载对象
- (void)removeDownLoadWithUrl:(NSString *)url;

// 获取所有的下载对象
- (NSArray *)getAllDownLoads;

@end