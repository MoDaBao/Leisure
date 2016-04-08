//
//  UserInfoManager.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/8.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

+ (UserInfoManager *)shareInstance {
    static UserInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserInfoManager alloc] init];
    });
    return manager;
    
}

//  保存用户的auth
+ (void)saveUserAuth:(NSString *)userAuth {
    [[NSUserDefaults standardUserDefaults] setObject:userAuth forKey:@"UserAuth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//  获取用户的auth
+ (NSString *)getUserAuth {
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAuth"];
    if (!auth) {
        return @" ";
    }
    return auth;
}
//  取消用户的auth
+ (void)cancelUserAuth {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAuth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//保存用户的name
+ (void)saveUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取用户的name
+ (NSString *)getUserName {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    if (!userName) {
        return @" ";
    }
    return userName;
}

//保存用户的id
+ (void)saveUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", userID] forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取用户的id
+ (NSString *)getUserID {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if (userID == nil) {
        return @" ";
    }
    return userID;
}
//  取消用户的id
+ (void)cancelUserID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//保存用户的icon
+ (void)saveUserIcon:(NSString *)userIcon {
    [[NSUserDefaults standardUserDefaults] setObject:userIcon forKey:@"UserIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取用户的Icon
+ (NSString *)getUserIcon {
    NSString *userIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserIcon"];
    if (!userIcon) {
        return @" ";
    }
    return userIcon;
}


@end
