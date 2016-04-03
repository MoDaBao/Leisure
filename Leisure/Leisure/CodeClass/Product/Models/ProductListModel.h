//
//  ProductListModel.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface ProductListModel : BaseModel

//购买地址
@property (nonatomic, copy) NSString *buyurl;
//图片地址
@property (nonatomic, copy) NSString *coverimg;
//商品id
@property (nonatomic, copy) NSString *contentid;
//标题
@property (nonatomic, copy) NSString *title;


@end
