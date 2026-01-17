//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "AppDelegate.h"
#import "DDHTimelineWindowController.h"

@interface AppDelegate ()
@property (strong) DDHTimelineWindowController *windowController;
@property (strong) NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  _windowController = [[DDHTimelineWindowController alloc] init];

  NSWindow *window = _windowController.window;
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
