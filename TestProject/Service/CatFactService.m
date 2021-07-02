//
//  CatFactService.m
//  TestProject
//
//  Created by Jonas Englevid on 2021-07-02.
//

#import "CatFactService.h"
#import "ServiceManager.h"

@implementation CatFactService

+ (CatFactService *)sharedInstance {
    static CatFactService *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (void)fetchCatFacts:(IdBlock)successBlock failure:(ErrorBlock)failureBlock {
    [[ServiceManager sharedInstance].serviceManager GET:@"https://cat-fact.herokuapp.com/facts" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDetail = @{NSLocalizedDescriptionKey:@"Could not fetch cat facts!"};
        NSError *tmpError = [NSError errorWithDomain:@"woma" code:(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 403 ? 403 : 500 userInfo:errorDetail];
        failureBlock(tmpError);
    }];
}

@end
