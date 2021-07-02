//
//  CatFactService.h
//  TestProject
//
//  Created by Jonas Englevid on 2021-07-02.
//

#import <Foundation/Foundation.h>

typedef void (^ VoidBlock)(void);
typedef void (^ ErrorBlock)(NSError *_Nullable);
typedef void (^ IdBlock)(id _Nullable );

NS_ASSUME_NONNULL_BEGIN

@interface CatFactService : NSObject

+ (CatFactService *)sharedInstance;

- (void)fetchCatFacts:(IdBlock)successBlock failure:(ErrorBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
