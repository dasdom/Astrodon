//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "AppDelegate.h"
#import "DDHAppCoordinator.h"

@interface AppDelegate ()
@property (strong) DDHAppCoordinator *appCoordinator;
@property (strong) NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  _appCoordinator = [[DDHAppCoordinator alloc] init];

  NSWindowController *windowController = [_appCoordinator start];
  NSWindow *window = windowController.window;
  [window makeKeyAndOrderFront:self];
  self.window = window;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}

@end
