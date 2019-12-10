//
//  KOOLogUtil.h
//  CocoaLumberjack
//
//  Created by wupeng01 on 2019/11/7.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
static const DDLogLevel ddLogLevel = DDLogLevelAll;
NS_ASSUME_NONNULL_BEGIN

@interface KOOLogUtil : NSObject
- (void)uploadLog;
+ (void)initLogConfig;
@end

NS_ASSUME_NONNULL_END
