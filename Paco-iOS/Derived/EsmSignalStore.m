//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: /Users/northropo/Projects/paco/Shared/src/com/pacoapp/paco/shared/scheduling/EsmSignalStore.java
//

#include "EsmSignalStore.h"
#include "J2ObjC_source.h"
#include "java/lang/Long.h"
#include "java/util/List.h"

@interface PAEsmSignalStore : NSObject

@end

@implementation PAEsmSignalStore

+ (const J2ObjcClassInfo *)__metadata {
  static const J2ObjcMethodInfo methods[] = {
    { "storeSignalWithJavaLangLong:withJavaLangLong:withJavaLangLong:withNSString:withJavaLangLong:withJavaLangLong:", "storeSignal", "V", 0x401, NULL, NULL },
    { "getSignalsWithJavaLangLong:withJavaLangLong:withNSString:withJavaLangLong:withJavaLangLong:", "getSignals", "Ljava.util.List;", 0x401, NULL, "(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/String;Ljava/lang/Long;Ljava/lang/Long;)Ljava/util/List<Lorg/joda/time/DateTime;>;" },
    { "deleteAll", NULL, "V", 0x401, NULL, NULL },
    { "deleteAllSignalsForSurveyWithJavaLangLong:", "deleteAllSignalsForSurvey", "V", 0x401, NULL, NULL },
    { "deleteSignalsForPeriodWithJavaLangLong:withJavaLangLong:withNSString:withJavaLangLong:withJavaLangLong:", "deleteSignalsForPeriod", "V", 0x401, NULL, NULL },
  };
  static const J2ObjcClassInfo _PAEsmSignalStore = { 2, "EsmSignalStore", "com.pacoapp.paco.shared.scheduling", NULL, 0x609, 5, methods, 0, NULL, 0, NULL, 0, NULL, NULL, NULL };
  return &_PAEsmSignalStore;
}

@end

J2OBJC_INTERFACE_TYPE_LITERAL_SOURCE(PAEsmSignalStore)