//
//  ServiceManager.m
//  TestProject
//
//  Created by Jonas Englevid on 2021-07-02.
//

#import "ServiceManager.h"

@implementation ServiceManager

+ (ServiceManager *)sharedInstance {
    static ServiceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *serviceManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        serviceManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [serviceManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [serviceManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        sharedInstance.serviceManager = serviceManager;
    });

    return sharedInstance;
}

@end
