//  Created by Dominik Hauser on 20.11.22.
//  
//

#import <AppKit/AppKit.h>

@interface DDHImageLoader : NSObject
- (void)loadImageForURL:(NSURL *)url completionHandler:(void(^)(NSImage *image))completionHandler;
@end
