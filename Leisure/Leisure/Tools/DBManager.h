//
//  DBManager.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/11.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;//数据库操作对象

+ (DBManager *)shareInstanceWithName:(NSString *)name;

- (instancetype)initWithDBName:(NSString *)name;


@end
