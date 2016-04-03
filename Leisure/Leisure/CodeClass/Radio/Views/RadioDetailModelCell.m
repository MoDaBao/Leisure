//
//  RadioDetailModelCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RadioDetailModelCell.h"

@implementation RadioDetailModelCell

- (void)setDataWithModel:(RadioDetailModel *)model {
    self.titleLabel.text = model.title;
    self.musicVisit.text = model.musicVisit;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:model.coverimg];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.coverImageView.image = [UIImage imageWithData:data];
            });
        }];
        
        [task resume];
        
        
    });
}


@end
