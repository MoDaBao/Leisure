//
//  DBManager.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DBManager.h"


@implementation DBManager

static DBManager *manager = nil;

+ (DBManager *)shareInstanceWithName:(NSString *)name {
    @synchronized (self) {
        if (!manager) {
            manager = [[DBManager alloc] initWithDBName:name];
        }
    }
    return manager;
}

- (instancetype)initWithDBName:(NSString *)name {
    if (self = [super init]) {
        if (!name) {
            NSLog(@"创建数据库失败");
        } else {
            //获取沙盒路径
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            //创建数据库路径
            NSString *dbPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
            //isExist = 0 路径不存在  isExists = 1 路径已经存在
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
            if (!isExist) {
                NSLog(@"路径不存在创建成功，%@",dbPath);
            } else {
                NSLog(@"路径已存在, %@",dbPath);
            }
            
            [self openDBWithDBPath:dbPath];
        }
    }
    return self;
}

- (void)openDBWithDBPath:(NSString *)path {
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:path];
    }
    if (![_dataBase open]) {
        NSLog(@"打开数据库失败");
    } else {
        NSLog(@"打开数据库成功");
    }
}

- (void)closeDB {
    [_dataBase close];
    manager = nil;
}

- (void)dealloc {
    [self closeDB];
}













@end
