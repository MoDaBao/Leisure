//
//  PlayerManager.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager

@synthesize musicArray = _musicArray;

//创建单例方法
+ (instancetype)shareInstances {
    static PlayerManager *playManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playManager = [[PlayerManager alloc] init];
    });
    return playManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _playState = playStatePause;//默认是暂停
        _playType = playTypeList;   //默认顺序播放
    }
    return self;
}

//重写播放源的setter和getter方法
- (NSMutableArray *)musicArray {
    if (!_musicArray) {
        _musicArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _musicArray;
}
- (void)setMusicArray:(NSMutableArray *)musicArray {
    //清空原始数据
    [self.musicArray removeAllObjects];
    //重新赋值
    [self.musicArray addObjectsFromArray:musicArray];
    
    //根据播放位置创建单元
    AVPlayerItem *avPlayerItem = nil;
    if ([_musicArray[_playIndex] hasPrefix:@"http"]) {//根据网址创建
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_musicArray[_playIndex]]];
    } else {//根据根据本地路径来创建
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:_musicArray[_playIndex]]];
    }
    
    // 创建播放器，如果存在切换播放单元，否则根据播放单元创建新的播放器
    if (_avPlayer) {
        [_avPlayer replaceCurrentItemWithPlayerItem:avPlayerItem];
    } else {
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    }
    // 默认设置播放状态是暂停状态
    _playState = playStatePause;
    
}

- (CGFloat)currentTime {
    //  当前基数为零
    if (_avPlayer.currentItem.timebase == 0) {
        return 0;
    }
    return _avPlayer.currentTime.value / _avPlayer.currentTime.timescale;
}

- (CGFloat)totalTime {
    if (_avPlayer.currentItem.duration.timescale == 0) {
        return 0;
    }
    return _avPlayer.currentItem.duration.value / _avPlayer.currentItem.duration.timescale;
}

#pragma mark -----播放控制-----
//播放
- (void)play {
    [_avPlayer play];
    _playState = playStatePlay;
}

//暂停
- (void)pause {
    [_avPlayer pause];
    _playState = playStatePause;
}

//停止
- (void)stop {
    [self seekToNewTime:0];
    [self pause];
}

//指定位置播放
- (void)seekToNewTime:(CGFloat)time {
    //获取当前播放时间
    CMTime newTime = _avPlayer.currentTime;
    //重新设置播放时间
    newTime.value = newTime.timescale * time;
    //播放器跳转到新的时间
    [_avPlayer seekToTime:newTime];
}

//上一首
- (void)prevMusic {
    if (_playType == playTypeRandom) {//随机模式
        _playIndex = arc4random() % (_musicArray.count - 1 - 0 + 1) + 0;
    } else {//其他模式
        if (_playIndex == 0) {
            _playIndex = _musicArray.count - 1;
        } else {
            _playIndex --;
        }
    }
    [self changeMusicWithIndex:_playIndex];
}
//下一首
- (void)nextMusic {
    if (_playType == playTypeRandom) {//随机模式
        _playIndex = arc4random() % (_musicArray.count - 1 - 0 + 1) + 0;
    } else {//其他模式
        if (_playIndex == _musicArray.count - 1) {
            _playIndex = 0;
        } else {
            _playIndex ++;
        }
    }
    [self changeMusicWithIndex:_playIndex];
}
//指定位置切歌
- (void)changeMusicWithIndex:(NSInteger)index {
    _playIndex = index;
    
    AVPlayerItem *avPlayerItem = nil;
    if ([_musicArray[_playIndex] hasPrefix:@"http"]) {
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_musicArray[_playIndex]]];
    } else {
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:_musicArray[_playIndex]]];
    }
    
    [_avPlayer replaceCurrentItemWithPlayerItem:avPlayerItem];
    [self play];
    
}

//播放完成
- (void)playDidFinsh {
    if (_playType == playTypeSingle) {//单曲循环
        _playIndex --;
    }
    [self nextMusic];
}


@end
