//
//  PlayCoverView.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PlayCoverView.h"
#import "PlayerManager.h"
#import "RadioDetailDB.h"

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
    if (_radioDetailModel != radioDetailModel) {
        _radioDetailModel = nil;
        _radioDetailModel = radioDetailModel;
    }
//    self.radioDetailModel = radioDetailModel;
    self.playInfoModel = radioDetailModel.playInfo;
    [self.playSlider addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
}

- (void)changeValue {
    PlayerManager *manager = [PlayerManager shareInstances];
    [manager seekToNewTime:self.playSlider.value];
}

- (IBAction)downloadMusic:(UIButton *)sender {
    // 创建一个下载对象，并且用下载管理器进行管理
//    DownLoad *download = [[DownLoadManager shareInstance] addDownLoadWithUrl:self.playInfoModel.musicUrl];
    
    DownLoad *download = [[DownLoadManager shareInstance] addDownLoadWithUrl:self.radioDetailModel.playInfo.musicUrl];
    download.downLoading = ^(float progress) {
        NSLog(@"%.2f%%", progress * 100);
        [sender setTitle:[NSString stringWithFormat:@"%.2f%%",progress * 100] forState:UIControlStateNormal];
    };
    // 监控下载完成
    download.downloadFinish = ^(NSString *url, NSString *savaPath) {
        [[DownLoadManager shareInstance] removeDownLoadWithUrl:url];
        NSLog(@"%@",savaPath);
        // 1、UI变化
//        [sender setTitle:@"完成" forState:UIControlStateNormal];
        
        // 2、数据保存、数据模型、本地音频路径
        // 1>存电台详情列表数据
        RadioDetailDB *radioDetailDB = [[RadioDetailDB alloc] init];
        [radioDetailDB createDataTable];
        [radioDetailDB insertReadDetailModel:_radioDetailModel andPath:savaPath];
        
        // 2>存playInfo
        
        
        // 3、移除下载对象
        [[DownLoadManager shareInstance] removeDownLoadWithUrl:url];
    };
    NSLog(@"111111");
    
    // 开始下载
    [download start];
}



@end
