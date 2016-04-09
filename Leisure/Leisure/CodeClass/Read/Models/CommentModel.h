//
//  CommentModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"
#import "CommentUserModel.h"

@interface CommentModel : BaseModel

@property (nonatomic, strong) NSString *addtime_f;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentid;
@property (nonatomic, assign) BOOL isdel;

@property (nonatomic, strong) CommentUserModel *userInfo;

@end
