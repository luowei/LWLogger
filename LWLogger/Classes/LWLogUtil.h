//
//  LWLogUtil.h
//  CocoaLumberjack
//
//  Created by luowei on 2019/11/8.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
static const DDLogLevel ddLogLevel = DDLogLevelAll;
NS_ASSUME_NONNULL_BEGIN

@interface LWLogUtil : NSObject

+ (void)initLogConfig;
+ (NSString *)logZipPath;

@end

NS_ASSUME_NONNULL_END
