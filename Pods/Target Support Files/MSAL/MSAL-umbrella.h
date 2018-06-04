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

#import "MSAL.h"
#import "MSALError.h"
#import "MSALLogger.h"
#import "MSALPublicClientApplication.h"
#import "MSALResult.h"
#import "MSALTelemetry.h"
#import "MSALTelemetryApiId.h"
#import "MSALUIBehavior.h"
#import "MSALUser.h"

FOUNDATION_EXPORT double MSALVersionNumber;
FOUNDATION_EXPORT const unsigned char MSALVersionString[];

