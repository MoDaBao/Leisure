//
//  PlayRadioView.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayRadioView : UIView

// 修改当年播放标识
@property (nonatomic , copy) void (^selectRadioBlock)(NSInteger index);

//根据当前页面改变标识
- (void)changeTypeWithIndex:(NSInteger)index;



@end
