//
//  PlayCoverView.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioDetailModel.h"

@interface PlayCoverView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@property (nonatomic, strong) RadioDetailModel *radioDetailModel;
@property (nonatomic, strong) RadioPlayInfoModel *playInfoModel;

@end
