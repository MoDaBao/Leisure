//
//  DownLoadManager.m
//  Leisure
//
//  Created by 莫大宝 on 16/4/12.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DownLoadManager.h"

@interface DownLoad ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downLoadTask;
@property (nonatomic, strong) NSData *reData;// 用来保存断点数据
@property (nonatomic, copy) NSString *urlPath;// 用来保存下载地址

@end


@implementation DownLoad

//  自定义初始化方法，传入下载的地址
- (instancetype)initWithURLPath:(NSString *)urlPath {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        //        self.downLoadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:urlPath]];
        self.urlPath = urlPath;
    }
    return self;
}

- (void)start {
    
    // 断点
    if (!self.downLoadTask) {
        // 从文件中读取断点数据
        self.reData = [NSData dataWithContentsOfFile:[self createFilePath]];
        if (!self.reData) {
            self.downLoadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.urlPath]];
        } else {
            self.downLoadTask = [self.session downloadTaskWithResumeData:self.reData];
        }
    }
    
    [self.downLoadTask resume];
}

- (void)pause {
    // 暂停，不能调用cancel，cancel是取消任务
    //    [self.downLoadTask suspend];
    
    // 断点下载
    [self.downLoadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.reData = resumeData;// 获取新的断点数据
        self.downLoadTask = nil;// 将task置空，因为再次开始时需要用新的断点数据来创建task
        
        // 将data保存到本地,防止用户退出引用，内存数据被回收
        [self.reData writeToFile:[self createFilePath] atomically:YES];
    }];
}

//  创建下载文件的路径，第一个作用用来保存断点数据，第二个作用用来保存最后下载完成的文件（下载完成后，会将保存的断点数据进行覆盖）
- (NSString *)createFilePath {
    // 获取caches文件夹
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 创建一个视频文件夹
    NSString *videoPath = [cachesPath stringByAppendingPathComponent:@"video"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:videoPath]) {// 判断文件夹是否存在，若是不存在则创建
        [fileManager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 创建视频文件路径
    //    NSString *filePath = [videoPath stringByAppendingPathComponent:self.downLoadTask.response.suggestedFilename];
    // 在创建task时，因为task还为空，找不到建议的文件名
    NSArray *array = [self.urlPath componentsSeparatedByString:@"/"];
    NSString *filePath = [videoPath stringByAppendingPathComponent:[array lastObject]];
    
    return filePath;
}


#pragma mark -----代理方法-----

//  当下载完成时被调用,将缓存数据保存到caches文件夹
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *filePath = [self createFilePath];
    // 先把缓存数据清空掉
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    // 将数据移到文件路径下
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
    NSLog(@"filePath = %@",filePath);
    
    // 下载完成后通过block将网络路径和本地路径传出
    self.downloadFinish(self.urlPath, filePath);
}

/**
 *  下载中被调用，用来监控
 *
 *  @param bytesWritten              本次写入的字节数
 *  @param totalBytesWritten         总共写入的字节数
 *  @param totalBytesExpectedToWrite 下载的文件的字节数
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //    NSLog(@"23333333");
    // 获取下载进度
    float progress = totalBytesWritten  * 1.0 / totalBytesExpectedToWrite;
    
    //将进度值传出去
    self.downLoading(progress);
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

//  请求完成时调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"error is %@",error);
    
    
}

@end

@interface DownLoadManager ()

@property (nonatomic, strong) NSMutableDictionary *downloadDic;// 用来保存下载对象

@end

@implementation DownLoadManager

- (NSMutableDictionary *)downloadDic {
    if (!_downloadDic) {
        self.downloadDic = [NSMutableDictionary dictionary];
    }
    return _downloadDic;
}

//  单例方法
+ (DownLoadManager *)shareInstance {
    static DownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc] init];
    });
    return manager;
}


//  添加下载对象的方法
- (DownLoad *)addDownLoadWithUrl:(NSString *)url {
    // 根据地址查找字典中的下载对象，如果不存在要创建新的
    DownLoad *download = self.downloadDic[url];
    if (!download) {
        download = [[DownLoad  alloc] initWithURLPath:url];
        [self.downloadDic setObject:download forKey:url];
    }
    return download;
}

//  移除完成的下载对象
- (void)removeDownLoadWithUrl:(NSString *)url {
    [self.downloadDic removeObjectForKey:url];
}

// 获取所有的下载对象
- (NSArray *)getAllDownLoads {
    NSMutableArray *array = [NSMutableArray array];
    // 遍历字典中所有的下载对象，放到数组中
    for (NSString *url in self.downloadDic) {
        [array addObject:self.downloadDic[url]];
    }
    return array;
}

@end
