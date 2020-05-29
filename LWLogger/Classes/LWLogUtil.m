//
//  LWLogUtil.m
//  CocoaLumberjack
//
//  Created by luowei on 2019/11/8.
//

#import "LWLogUtil.h"
#import "ZipArchive.h"

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
    //zip文件路径
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *zipFileName = [NSString stringWithFormat:@"/feadbackLog-%@.zip", [fmt stringFromDate:[NSDate date]]];
    NSString *logZipPath = [logDirectory stringByAppendingString:zipFileName];

    //获取排序后的log名称
    NSArray <NSString *> *logsNameArray = [fileLogger.logFileManager sortedLogFileNames];
    DDLogDebug(@"%@", logsNameArray);
    [SSZipArchive createZipFileAtPath:logZipPath withFilesAtPaths:logsNameArray];

    return logZipPath;
}


@end
