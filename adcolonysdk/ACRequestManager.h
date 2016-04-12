//
//  ACRequestManager.h
//  adcolonysdk
//
//  Created by Anatoly Macarov on 4/4/16.
//  Copyright © 2016 Opera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACRequestManager : NSObject
+ (instancetype)sharedInstance;
- (void)fetchAllPostsWithCompletionHandler:(void (^) (NSArray *posts, NSError* error))completion;
- (void)fetchPostsForUserId:(NSString *)userId WithCompletionHandler:(void (^) (NSArray* posts, NSError* error))completion;

@end
