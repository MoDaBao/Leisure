//
//  RadioDetailInfoView.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioInfoModel.h"

@interface RadioDetailInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *unameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *musicvisitnumLabel;

- (void)setDataWithModel:(RadioInfoModel *)model;

@end
