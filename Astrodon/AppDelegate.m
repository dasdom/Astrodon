//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "AppDelegate.h"
#import "DDHTimelineViewController.h"
#import "DDHTootInputViewController.h"

@interface AppDelegate ()
@property (strong) NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  DDHTimelineViewController *timeLineViewController = [DDHTimelineViewController new];
  timeLineViewController.title = @"Timeline";

  NSWindow *window = [NSWindow windowWithContentViewController:timeLineViewController];
  [window makeKeyAndOrderFront:self];
  self.window = window;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}

- (void)newDocument:(id)sender {
  DDHTootInputViewController *tootInputViewController = [[DDHTootInputViewController alloc] init];
  tootInputViewController.title = @"New Toot";

  NSWindow *inputWindow = [NSWindow windowWithContentViewController:tootInputViewController];
  [inputWindow makeKeyAndOrderFront:self];
}

@end
