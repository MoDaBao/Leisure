//
//  KeyBoardView.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeyBoardView;
@protocol KeyBoardViewDelegate <NSObject>

-(void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView;

@end

@interface KeyBoardView : UIView

@property (nonatomic, assign) id<KeyBoardViewDelegate> delegate;
@property (nonatomic, strong) UITextView *textView;

@end
