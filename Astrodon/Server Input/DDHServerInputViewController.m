//  Created by Dominik Hauser on 25.11.22.
//  
//

#import "DDHServerInputViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "DDHClientKeys.h"
#import "DDHKeychain.h"
#import "DDHConstants.h"
#import "DDHAPIClient.h"

@interface DDHServerInputViewController () <ASWebAuthenticationPresentationContextProviding, NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSButton *goButton;
@property (weak) IBOutlet NSTextField *codeTextField;
@property (weak) IBOutlet NSButton *saveButton;
@property (strong) DDHAPIClient *apiClient;
@end

@implementation DDHServerInputViewController

- (void)viewDidLoad {
  [super viewDidLoad];


}

- (void)authorise:(NSString *)host {

  NSURLComponents *components = [NSURLComponents new];
  components.scheme = @"https";
  components.host = host;
  components.path = @"/oauth/authorize";
  components.queryItems = @[
    [NSURLQueryItem queryItemWithName:@"client_id" value:client_id],
    [NSURLQueryItem queryItemWithName:@"scope" value:@"read+write+follow+push"],
    [NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirect_uri],
    [NSURLQueryItem queryItemWithName:@"response_type" value:@"code"],
  ];

  NSURL *url = components.URL;

  ASWebAuthenticationSession *authSession = [[ASWebAuthenticationSession alloc] initWithURL:url callbackURLScheme:@"astrodon" completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
    NSLog(@"callbackURL: %@", callbackURL);
    NSLog(@"error: %@", error);
  }];

  authSession.presentationContextProvider = self;
  [authSession start];
}

- (nonnull ASPresentationAnchor)presentationAnchorForWebAuthenticationSession:(nonnull ASWebAuthenticationSession *)session {
  return [self.view window];
}

- (IBAction)go:(NSButton *)sender {
  NSString *host = [self.urlTextField stringValue];
  NSLog(@"host: %@", host);
  NSArray<NSString *> *components = [host componentsSeparatedByString:@"."];
  if (components.count > 1 &&
      components[0].length > 0 &&
      components[1].length > 0) {
    [self authorise:host];
    self.codeTextField.enabled = YES;
  } else {
    self.codeTextField.enabled = NO;
  }
}

- (void)controlTextDidChange:(NSNotification *)obj {

  if (obj.object == self.urlTextField) {
    NSString *host = [self.urlTextField stringValue];
    NSArray<NSString *> *components = [host componentsSeparatedByString:@"."];
    if (components.count > 1 &&
        components[0].length > 0 &&
        components[1].length > 0) {
      self.goButton.enabled = YES;
    } else {
      self.goButton.enabled = NO;
    }
  } else if (obj.object == self.codeTextField) {

    NSString *code = [self.codeTextField stringValue];

    if (code.length > 1) {
      self.saveButton.enabled = YES;
    } else {
      self.saveButton.enabled = NO;
    }
  }
}

- (IBAction)save:(NSButton *)sender {

  NSString *code = [self.codeTextField stringValue];

  self.apiClient = [DDHAPIClient new];

  [self.apiClient fetchTokenWithCode:code completionHandler:^(NSString * _Nonnull token, NSError * _Nonnull error) {

    if (token != nil) {
      [DDHKeychain saveString:token forKey:codeKeychainName];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissController:nil];
      });
    }
  }];

}

@end
