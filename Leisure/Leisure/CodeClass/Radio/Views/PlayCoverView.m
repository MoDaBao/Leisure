//
//  PlayCoverView.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PlayCoverView.h"
#import "PlayerManager.h"

@implementation PlayCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setRadioDetailModel:(RadioDetailModel *)radioDetailModel {
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:radioDetailModel.coverimg]];
    self.titleLabel.text = radioDetailModel.title;
    
    [self.playSlider addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
}

- (void)changeValue {
    PlayerManager *manager = [PlayerManager shareInstances];
    [manager seekToNewTime:self.playSlider.value];
}

@end
