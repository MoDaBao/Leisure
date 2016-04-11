//
//  ReadDetailDB.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ReadDetailDB.h"
#import "ReadDetailModel.h"

@implementation ReadDetailDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [DBManager shareInstanceWithName:SQLITENAME].dataBase;
    }
    return self;
}

//创建表
- (void)createDataTable {
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",READDETAILTABLE];
    //查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已经存在");
    } else {
        //创建数据表
        NSString  *createSql = [NSString stringWithFormat:@"CREATE TABLE %@ (readID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userID text, title text, contentID text, content text, name text, coverimg text)", READDETAILTABLE];
        if ([_dataBase executeUpdate:createSql]) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}
//插入数据
- (void)insertReadDetailModel:(ReadDetailModel *)model {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (userID,title,contentid,content, name, coverimg) values (?,?,?,?,?,?)", READDETAILTABLE];
    //创建插入内容
    NSMutableArray *contentArray = [NSMutableArray array];
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        [contentArray addObject:[UserInfoManager getUserID]];
    }
    if (model.title) {
        [contentArray addObject:model.title];
    }
    if (model.contentID) {
        [contentArray addObject:model.contentID];
    }
    if (model.content) {
        [contentArray addObject:model.content];
    }
    if (model.name) {
        [contentArray addObject:model.name];
    }
    if (model.coverimg) {
        [contentArray addObject:model.coverimg];
    }
    
    [_dataBase executeUpdate:insertSql withArgumentsInArray:contentArray];
    
    
}
//删除一条数据
- (void)deleteWithTitle:(NSString *)title {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where title = '%@'",READDETAILTABLE, title];
    [_dataBase executeUpdate:deleteSql];
}
//查询所有数据
- (NSArray *)selectAllDataWithUserID:(NSString *)userID {
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userID = '%@'",READDETAILTABLE, userID];
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    
    NSMutableArray *contentArray = [NSMutableArray array];
    
    while ([set next]) {
        ReadDetailModel *model = [[ReadDetailModel alloc] init];
        model.title = [set stringForColumn:@"title"];
        model.content = [set stringForColumn:@"content"];
        model.contentID = [set stringForColumn:@"contentID"];
        model.name = [set stringForColumn:@"name"];
        model.coverimg = [set stringForColumn:@"coverimg"];
        [contentArray addObject:model];
    }
    
    [set close];
    
    return contentArray;
}





















@end
