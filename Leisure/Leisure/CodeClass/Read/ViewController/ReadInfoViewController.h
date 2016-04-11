//
//  ReadInfoViewController.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadDetailModel.h"

@interface ReadInfoViewController : BaseViewController

@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, strong) ReadDetailModel *detailModel;

@end
