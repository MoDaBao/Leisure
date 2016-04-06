//
//  PlayerManager.h
//  Leisure
//
//  Created by 莫大宝 on 16/4/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//播放模式
typedef enum {
    playTypeSingle, //单曲循环
    playTypeRandom, //随机播放
    playTypeList    //顺序播放
}PlayType;


//播放状态
typedef enum {
    playStatePlay, //播放
    playStatePause //暂停
}PlayState;

@interface PlayerManager : NSObject


@property (nonatomic, assign, readonly) PlayState playState;//播放状态
@property (nonatomic, assign) PlayType playType;//播放模式

@property (nonatomic, strong) NSMutableArray *musicArray;//传入的播放列表
@property (nonatomic, assign) NSUInteger playIndex;//传入播放位置

@property (nonatomic, assign, readonly) CGFloat currentTime;//当前时长
@property (nonatomic, assign, readonly) CGFloat totalTime;//总时长

@property (nonatomic, strong) AVPlayer *avPlayer;//播放器对象

//创建单例方法
+ (instancetype)shareInstances;

//播放
- (void)play;

//暂停
- (void)pause;

//停止
- (void)stop;

//指定位置播放
- (void)seekToNewTime:(CGFloat)time;

//上一首
- (void)prevMusic;
//下一首
- (void)nextMusic;
//指定位置切歌
- (void)changeMusicWithIndex:(NSInteger)index;

//播放完成
- (void)playDidFinsh;









@end
