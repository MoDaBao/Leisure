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
    markView.backgroundColor = [UIColor greenColor];
}

- (IBAction)prevBtn:(id)sender {
    [[PlayerManager shareInstances] prevMusic];
    
    _selectRadioBlock([PlayerManager shareInstances].playIndex);
}

- (IBAction)nextBtn:(id)sender {
    [[PlayerManager shareInstances] nextMusic];
}

- (IBAction)playAndPause:(id)sender {
    [[PlayerManager shareInstances] pause];
}


@end
