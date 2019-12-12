
#ifndef LWLogger____FILEEXTENSION___
#define LWLogger____FILEEXTENSION___

#import "LWLogUtil.h"

//#define LWLog DDLogInfo

#ifdef DEBUG
#define LWLog DDLogInfo
#else
#define LWLog(...)
#endif



#endif