//
//  MLIMGURUploader.h
//  SharingTest
//
//  Created by Little Yoda on 26.12.15.
//  Copyright (c) 2015 Little Yoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImgurUploader : NSObject

+ (void)uploadPhoto:(NSData*)imageData
              title:(NSString*)title
        description:(NSString*)description
      imgurClientId:(NSString*)clientId
    completionBlock:(void(^)(NSString* result))completion
       failureBlock:(void(^)(NSURLResponse *response, NSError *error, NSInteger status))failureBlock;

@end
