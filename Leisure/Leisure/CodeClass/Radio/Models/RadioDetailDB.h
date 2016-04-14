//
//  RadioDetailDB.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/13.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadioDetailModel.h"

@interface RadioDetailDB : NSObject

// 数据库操作对象
@property (nonatomic, strong) FMDatabase *dataBase;

// 创建表
- (void)createDataTable;

// 插入数据 将model数据和本地音频路径保存到数据表中
- (void)insertReadDetailModel:(RadioDetailModel *)model andPath:(NSString *)path;

// 删除一条数据
- (void)deleteWithTitle:(NSString *)title;

//  查询所有数据
- (NSArray *)selectAllDataWithUserID:(NSString *)userID;

@end
