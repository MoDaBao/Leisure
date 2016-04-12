//
//  RadioPlayInfoModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioPlayInfoModelCell.h"


@implementation RadioPlayInfoModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(RadioPlayInfoModel *)model {
    self.titleLabel.text = model.title;
    self.authNameLabel.text = [NSString stringWithFormat:@"by:%@",model.authorInfo.uname];
//    self.playInfoModel = model;
    if (self.selected) {
        self.markView.backgroundColor = [UIColor orangeColor];
    } else {
        self.markView.backgroundColor = [UIColor clearColor];
    }
}

//- (IBAction)downloadMusic:(id)sender {
//    
//    DownLoad *download = [[DownLoadManager shareInstance] addDownLoadWithUrl:self.playInfoModel.musicUrl];
//    download.downLoading = ^(float progress) {
//        NSLog(@"%.2f%%", progress);
//    };
//    download.downloadFinish = ^(NSString *url, NSString *savaPath) {
//        [[DownLoadManager shareInstance] removeDownLoadWithUrl:url];
//        NSLog(@"%@",savaPath);
//    };
////    download.downLoading = ^
//    NSLog(@"111111");
//    
//    [download start];
//    
//}


@end
