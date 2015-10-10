//
//  CommMamanger.m
//  TheLine
//
//  Created by Gal Blank on 5/21/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "CommManager.h"
#import "StringHelper.h"
#import "definitions.h"
@implementation CommManager


static CommManager *sharedSampleSingletonDelegate = nil;

@synthesize imagesDownloadQueue;


+ (CommManager *)sharedInstance {
    @synchronized(self) {
        if (sharedSampleSingletonDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSampleSingletonDelegate;
}



+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedSampleSingletonDelegate == nil) {
            sharedSampleSingletonDelegate = [super allocWithZone:zone];
            // assignment and return on first allocation
            return sharedSampleSingletonDelegate;
        }
    }
    // on subsequent allocation attempts return nil
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)init
{
    if (self = [super init]) {
       self.imagesDownloadQueue = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)getAPIBlock:(NSString *)api andParams:(NSMutableDictionary*)params completion:(void(^)(NSMutableDictionary*))callback
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/rss+xml",nil];
    
    NSString *fullAPI = [NSString stringWithFormat:@"%@%@",ROOT_API,api];
    NSLog(@"GET: %@%@",fullAPI,params);
    [manager GET:fullAPI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RESPONSE: %@", responseObject);
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setObject:responseObject forKeyedSubscript:@"result"];
        callback(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(void)getAPI:(NSString*)api andParams:(NSMutableDictionary*)params andDelegate:(id)delegate{
    CommDelegate = delegate;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/rss+xml",nil];
    
    NSString *fullAPI = [NSString stringWithFormat:@"%@%@",ROOT_API,api];
    NSLog(@"GET: %@%@",fullAPI,params);
    [manager GET:fullAPI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RESPONSE: %@", responseObject);
        if([CommDelegate respondsToSelector:@selector(getApiFinished:)]){
            NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
            [result setObject:responseObject forKeyedSubscript:@"result"];
            [CommDelegate getApiFinished:result];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)postAPI:(NSString*)api andParams:(NSMutableDictionary*)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    NSString *fullAPI = [NSString stringWithFormat:@"%@%@",ROOT_API,api];
    NSLog(@"POST: %@:%@",fullAPI,params);
    [manager POST:fullAPI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
