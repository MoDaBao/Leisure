//
//  RadioPlayInfoModelDB.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/14.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioPlayInfoModelDB.h"

@implementation RadioPlayInfoModelDB


- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [DBManager shareInstanceWithName:SQLITENAME].dataBase;
    }
    return self;
}

// 创建表
- (void)createDataTable {
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",RADIOPLAYINFOTABLE];
    // 查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已经存在");
    } else {
        // 创建表
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ (radioID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, imgUrl text, sharepic text, sharetext text, shareurl text, ting_contentid text, tingid text, title text, webview_url text)", RADIOPLAYINFOTABLE];
        if ([_dataBase executeUpdate:createSql]) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
    
}

// 插入数据 将model数据保存到数据表中
- (void)insertReadDetailModel:(RadioPlayInfoModel *)model {
    // 创建插入语句
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (coverimg,isnew,musicUrl,title, musicVisit, savePath) values (?,?,?,?,?,?)", RADIOPLAYINFOTABLE];
    // 创建插入内容
    NSMutableArray *contentArray = [NSMutableArray array];
    if (model.imgUrl) {
        [contentArray addObject:model.imgUrl];
        [contentArray addObject:model.sharepic];
        [contentArray addObject:model.sharetext];
        [contentArray addObject:model.shareurl];
//        conte
    }
    
}

@end
