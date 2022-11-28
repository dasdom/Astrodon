//  Created by Dominik Hauser on 28.11.22.
//  
//

#import "DDHKeychain.h"

// Source: https://github.com/Keyflow/Keychain-iOS-ObjC/blob/master/KFKeychain.m
@implementation DDHKeychain

+ (BOOL)checkOSStatus:(OSStatus)status {
  return status == noErr;
}

+ (NSMutableDictionary *)keychainQueryForKey:(NSString *)key {
  return [@{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
            (__bridge id)kSecAttrService : key,
            (__bridge id)kSecAttrAccount : key,
            (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
          } mutableCopy];
}

+ (BOOL)saveString:(NSString *)string forKey:(NSString *)key {
  NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
  // Deleting previous object with this key, because SecItemUpdate is more complicated.
  [self deleteObjectForKey:key];

  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  [keychainQuery setObject:data forKey:(__bridge id)kSecValueData];
  return [self checkOSStatus:SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL)];
}

+ (NSString *)loadStringForKey:(NSString *)key {
  NSString *object = nil;

  NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];

  [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
  [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];

  CFDataRef keyData = NULL;

  if ([self checkOSStatus:SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData)]) {
    @try {
      NSData *data = (__bridge NSData *)keyData;
      object = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
      NSLog(@"Unarchiving for key %@ failed with exception %@", key, exception.name);
      object = nil;
    }
    @finally {}
  }

  if (keyData) {
    CFRelease(keyData);
  }

  return object;
}

+ (BOOL)deleteObjectForKey:(NSString *)key {
  NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
  return [self checkOSStatus:SecItemDelete((__bridge CFDictionaryRef)keychainQuery)];
}

@end
