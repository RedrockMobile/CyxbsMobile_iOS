#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Bagel.h"
#import "BagelBaseModel.h"
#import "BagelBrowser.h"
#import "BagelConfiguration.h"
#import "BagelController.h"
#import "BagelDeviceModel.h"
#import "BagelProjectModel.h"
#import "BagelRequestCarrier.h"
#import "BagelRequestInfo.h"
#import "BagelRequestPacket.h"
#import "BagelURLConnectionInjector.h"
#import "BagelURLSessionInjector.h"
#import "BagelUtility.h"

FOUNDATION_EXPORT double BagelVersionNumber;
FOUNDATION_EXPORT const unsigned char BagelVersionString[];

