//  Created by Dominik Hauser on 28.11.22.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHKeychain : NSObject
+ (BOOL)checkOSStatus:(OSStatus)status;
+ (BOOL)saveString:(NSString *)string forKey:(NSString *)key;
+ (NSString *)loadStringForKey:(NSString *)key;
+ (BOOL)deleteObjectForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
