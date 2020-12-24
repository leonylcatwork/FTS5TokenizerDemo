//
//  FTSTokenizerBridge.h
//  FTS5
//
//  Created by leon on 24/12/2020.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT int simple_xTokenize(void * _Nullable pCtx,
                                       int flags,
                                       const char * _Nullable pText,
                                       int nText,
                                       int (*xTokenFn)(void * _Nullable, int, const char * _Nullable, int, int, int));

@interface FTSTokenizerBridge : NSObject
@end

NS_ASSUME_NONNULL_END
