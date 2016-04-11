//
//  ReadDetailDB.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadDetailModel.h"

@interface ReadDetailDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

//创建表
- (void)createDataTable;
//插入数据
- (void)insertReadDetailModel:(ReadDetailModel *)model;
//删除一条数据
- (void)deleteWithTitle:(NSString *)title;
//查询所有数据
- (NSArray *)selectAllDataWithUserID:(NSString *)userID;



@end
