//
//  LWLogUtil.m
//  CocoaLumberjack
//
//  Created by luowei on 2019/11/8.
//

#import "LWLogUtil.h"
#import <ZipArchive/ZipArchive.h>

@interface LWLogUtil ()
@end

@implementation LWLogUtil
+ (void)initLogConfig {
    [DDLog addLogger:[DDOSLogger sharedInstance]];

    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

+ (NSString *)logZipPath {
    //获取DDLog打印的日志
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    //获取log文件夹路径
    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    DDLogDebug(@"%@", logDirectory);
    //获取排序后的log名称
    NSArray <NSString *> *logsNameArray = [fileLogger.logFileManager sortedLogFileNames];
    DDLogDebug(@"%@", logsNameArray);
    //创建zip文件
    ZipArchive *logZip = [[ZipArchive alloc] init];
    //zip文件路径
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *zipFileName = [NSString stringWithFormat:@"/feadbackLog-%@.zip", [fmt stringFromDate:date]];
    NSString *logZipPath = [logDirectory stringByAppendingString:zipFileName];
    if ([logZip CreateZipFile2:logZipPath]) {
        DDLogDebug(@"创建zip成功");
        //添加log文件
        [logsNameArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            //使用log本身的名字命名
            [logZip addFileToZip:[logDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", obj]] newname:obj];
        }];

    } else {
        DDLogDebug(@"创建zip失败");
    }
    //关闭
    [logZip CloseZipFile2];

    return logZipPath;
}


@end
