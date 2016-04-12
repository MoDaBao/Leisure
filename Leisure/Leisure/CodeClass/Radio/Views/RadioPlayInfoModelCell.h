//
//  RadioPlayInfoModelCell.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RadioPlayInfoModel.h"

@interface RadioPlayInfoModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *markView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *authNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

//@property (nonatomic, strong) RadioPlayInfoModel *playInfoModel;


@end
