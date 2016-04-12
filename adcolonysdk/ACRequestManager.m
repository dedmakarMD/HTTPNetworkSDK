//
//  ACRequestManager.m
//  adcolonysdk
//
//  Created by Anatoly Macarov on 4/4/16.
//  Copyright © 2016 Opera. All rights reserved.
//

#import "ACRequestManager.h"
#import "ACErrorHandler.h"
#import "ACModelFactory.h"

#define kServerEndPoint @"http://jsonplaceholder.typicode.com"
#define kServerSecretKey @"VERy_LOng_seCreT_KeeeeeeY"

#define kServerPathGetPosts @"GET /posts"
#define kServerPathPostInfo @"POST /posts"

@interface ACRequestManager ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic) dispatch_queue_t queue;
@end

@implementation ACRequestManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
        [sharedInstance config];
    });
    return sharedInstance;
}

- (void)config
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    configuration.timeoutIntervalForResource = 30;
    
    _session = [NSURLSession sessionWithConfiguration:configuration];
    _queue = dispatch_queue_create("com.opera.request_manager", NULL);
    
}

- (NSMutableURLRequest *)requestForPathAPI:(NSString *)pathApi parameters:(NSDictionary *)parameters httpBody:(NSData *)data
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSArray *components = [pathApi componentsSeparatedByString:@" "];
    if ([components count] >= 2) {
        pathApi = [components lastObject];
        [request setHTTPMethod:[components firstObject]];
    }
    else
    {
        [request setHTTPMethod:@"GET"];
    }
    
    NSMutableString *strParameters = [[NSMutableString alloc] initWithString:@"?"];
    for (NSString *key in [parameters allKeys])
    {
        if([strParameters length] > 1)
        {
            [strParameters appendString:@"&"];
        }
        NSString *value = [NSString stringWithFormat:@"%@",[parameters objectForKey:key]];
        [strParameters appendFormat:@"%@=%@", key, value];
    }
    
    NSMutableString *strURL = [NSMutableString stringWithFormat:@"%@%@%@", kServerEndPoint, pathApi, [strParameters length] > 1 ? strParameters : @""];
    
    [request setURL:[NSURL URLWithString:strURL]];
    
    if (data) {
        [request setHTTPBody:data];
    }
    
    NSLog(@"strURL: %@", strURL);
    return request;
}


- (void)fetchAllPostsWithCompletionHandler:(void (^) (NSArray* posts, NSError* error))completion
{
    dispatch_async(_queue, ^{
        
        NSMutableURLRequest *request = [self requestForPathAPI:kServerPathGetPosts parameters:nil httpBody:nil];
        
        NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSArray *posts;
                                          NSError *errorRef;
                                          if (!(errorRef = [ACErrorHandler responseVerification:response withError:error]))
                                          {
                                              posts = [ACModelFactory postsWithJSONData:data
                                                                               errorRef:&errorRef];
                                          }
                                          
                                          dispatch_sync(dispatch_get_main_queue(), ^{
                                              completion(posts, errorRef);
                                          });
                                      }];
        [task resume];
    });
}

- (void)fetchPostsForUserId:(NSString *)userId WithCompletionHandler:(void (^) (NSArray* posts, NSError* error))completion
{
    dispatch_async(_queue, ^{
        
        NSMutableURLRequest *request = [self requestForPathAPI:kServerPathGetPosts parameters:@{@"userId": userId} httpBody:nil];
        
        NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSArray *posts;
                                          NSError *errorRef;
                                          if (!(errorRef = [ACErrorHandler responseVerification:response withError:error]))
                                          {
                                              posts = [ACModelFactory postsWithJSONData:data
                                                                               errorRef:&errorRef];
                                          }
                                          
                                          dispatch_sync(dispatch_get_main_queue(), ^{
                                              completion(posts, errorRef);
                                          });
                                      }];
        [task resume];
    });
}

@end
