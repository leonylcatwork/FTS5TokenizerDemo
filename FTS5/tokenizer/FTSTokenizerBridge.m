//
//  FTSTokenizerBridge.m
//  FTS5
//
//  Created by leon on 24/12/2020.
//

#import "FTSTokenizerBridge.h"
#import <sqlite3.h>


int simple_xTokenize(void *pCtx,
                     int flags,
                     const char *pText,
                     int nText,
                     int (*xTokenFn)(void * _Nullable, int, const char * _Nullable, int, int, int)) {
    // suppose we have a c function xTokenize(...)
    return SQLITE_OK;
}


@implementation FTSTokenizerBridge

@end
