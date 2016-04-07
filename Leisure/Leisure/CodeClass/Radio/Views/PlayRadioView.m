//
//  PlayRadioView.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PlayRadioView.h"
#import "PlayerManager.h"

@implementation PlayRadioView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//根据当前页面改变标识
- (void)changeTypeWithIndex:(NSInteger)index {
    //  通过tag值来获取标识视图
    UIView *typeView = [self viewWithTag:1000];
    //  当页面滑动时，先将所有标识改成未标识状态
    for (UIView *view in typeView.subviews) {
        view.backgroundColor = [UIColor lightGrayColor];
    }
    //  然后根据scrollview的位置修改成显示状态
    UIView *markView = [self viewWithTag:2000 + index];
    markView.backgroundColor = [UIColor orangeColor];
}

- (IBAction)prevBtn:(id)sender {
    //播放上一首
    [[PlayerManager shareInstances] prevMusic];
    _selectRadioBlock([PlayerManager shareInstances].playIndex);//回调播放位置
    
    UIButton *playBtn = (UIButton *)[self viewWithTag:3002]  ;
    
    [playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    
}

- (IBAction)nextBtn:(id)sender {
    //播放下一首
    [[PlayerManager shareInstances] nextMusic];
    _selectRadioBlock([PlayerManager shareInstances].playIndex);//回调播放位置
    
    UIButton *playBtn = (UIButton *)[self viewWithTag:3002];
    
    [playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
}

- (IBAction)playAndPause:(id)sender {
    PlayerManager *manager = [PlayerManager shareInstances];
    UIButton *playBtn = (UIButton *)[self viewWithTag:3002];
    //如果是暂停状态就播放
    if (manager.playState == playStatePause) {
        [manager play];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    } else {
        [manager pause];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
