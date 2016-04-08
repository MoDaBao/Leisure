//
//  UserInfoManager.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/8.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject


+ (UserInfoManager *)shareInstance;

//  保存用户的auth
+ (void)saveUserAuth:(NSString *)userAuth;
//  获取用户的auth
+ (NSString *)getUserAuth;
//  取消用户的auth
+ (void)cancelUserAuth;

//保存用户的name
+ (void)saveUserName:(NSString *)userName;
//获取用户的name
+ (NSString *)getUserName;

//保存用户的id
+ (void)saveUserID:(NSString *)userID;
//获取用户的id
+ (NSString *)getUserID;
//  取消用户的id
+ (void)cancelUserID;

//保存用户的icon
+ (void)saveUserIcon:(NSString *)userIcon;
//获取用户的Icon
+ (NSString *)getUserIcon;


@end
