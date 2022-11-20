//  Created by Dominik Hauser on 20.11.22.
//  
//

#import "DDHImageLoader.h"

@implementation DDHImageLoader
- (void)loadImageForURL:(NSURL *)url completionHandler:(void(^)(NSImage *image))completionHandler {

  NSString *imageName = [url lastPathComponent];

  NSFileManager *fileManager = NSFileManager.defaultManager;
  NSURL *supportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] firstObject];
  NSURL *avatarsImagesURL = [supportURL URLByAppendingPathComponent:@"avatarImages"];

  if (NO == [fileManager fileExistsAtPath:[avatarsImagesURL path]]) {
    NSError *createDirectoryError = nil;
    [fileManager createDirectoryAtURL:avatarsImagesURL withIntermediateDirectories:YES attributes:nil error:&createDirectoryError];
  }

  NSURL *imageURL = [avatarsImagesURL URLByAppendingPathComponent:imageName];

  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
  if (imageData) {
    NSLog(@">>> Use existing image >>>");
    NSImage *image = [[NSImage alloc] initWithData:imageData];
    completionHandler(image);
    return;
  } else {
    NSLog(@"-- loading image");
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

      if (data) {
        NSImage *image = [[NSImage alloc] initWithData:data];
        completionHandler(image);
        return;
      }

    }];

    [dataTask resume];
  }
}
@end
