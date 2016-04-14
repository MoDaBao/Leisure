//
//  RadioDetailDB.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/13.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioDetailDB.h"


@implementation RadioDetailDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [DBManager shareInstanceWithName:SQLITENAME].dataBase;
    }
    return self;
}

// 创建表
- (void)createDataTable {
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",RADIODETAILTABLE];
    //查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已经存在");
    } else {
        //创建数据表
        NSString  *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ (radioID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, coverimg text, isnew INTEGER, musicUrl text, title text, musicVisit text, savePath text)", RADIODETAILTABLE];
        if ([_dataBase executeUpdate:createSql]) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}

// 插入数据 将model数据和本地音频路径保存到数据表中
- (void)insertReadDetailModel:(RadioDetailModel *)model andPath:(NSString *)path {
    // 创建插入语句
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (coverimg,isnew,musicUrl,title, musicVisit, savePath) values (?,?,?,?,?,?)", RADIODETAILTABLE];
    // 创建插入内容
    NSMutableArray *contentArray = [NSMutableArray array];
    if (model.coverimg) {
        [contentArray addObject:model.coverimg];
    }
    [contentArray addObject:@(model.isnew)];
    [contentArray addObject:model.musicUrl];
    [contentArray addObject:model.title];
    [contentArray addObject:model.musicVisit];
    [contentArray addObject:path];
    // 执行sql
    [_dataBase executeUpdate:insertSql withArgumentsInArray:contentArray];
    
}


@end
