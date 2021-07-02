//
//  ServiceManager.h
//  TestProject
//
//  Created by Jonas Englevid on 2021-07-02.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServiceManager : NSObject

+ (ServiceManager *)sharedInstance;

@property (nonatomic, strong) AFHTTPSessionManager *serviceManager;

@end

NS_ASSUME_NONNULL_END
