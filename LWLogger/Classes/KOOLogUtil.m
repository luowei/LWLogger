//
//  KOOLogUtil.m
//  CocoaLumberjack
//
//  Created by wupeng01 on 2019/11/7.
//

#import "KOOLogUtil.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <ZipArchive/ZipArchive.h>
@interface KOOLogUtil ()
@end
@implementation KOOLogUtil
+ (void)initLogConfig{
    [DDLog addLogger:[DDOSLogger sharedInstance]];

           DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
           fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
           fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
           [DDLog addLogger:fileLogger];
}
- (void)uploadLog{
     //获取DDLog打印的日志
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        //获取log文件夹路径
        NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
        DDLogDebug(@"%@", logDirectory);
        //获取排序后的log名称
        NSArray <NSString *>*logsNameArray = [fileLogger.logFileManager sortedLogFileNames];
        DDLogDebug(@"%@", logsNameArray);
    //创建zip文件
        ZipArchive *logZip = [[ZipArchive alloc] init];
        //zip文件路径
    NSDate * date = [NSDate date];
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString * zipFileName = [NSString stringWithFormat:@"/feadbackLog-%@.zip", [fmt stringFromDate:date]];
        NSString *logZipPath = [logDirectory stringByAppendingString:zipFileName];
        if ([logZip CreateZipFile2:logZipPath]) {
            DDLogDebug(@"创建zip成功");
            //添加log文件
            [logsNameArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //使用log本身的名字命名
                [logZip addFileToZip:[logDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", obj]] newname:obj];
            }];
            [self shareWithFilePath:logZipPath];
        }else{
            DDLogDebug(@"创建zip失败");
            [logZip CloseZipFile2];
            //返回为空
        }
        //关闭
        [logZip CloseZipFile2];
}


- (void)shareWithFilePath:(NSString *)filePath{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSArray *objectsToShare = @[url];
    NSArray *excludedActivities = @[UIActivityTypeMessage, UIActivityTypeMail];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        controller.excludedActivityTypes = excludedActivities;
//     Present the controller
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
}
@end
