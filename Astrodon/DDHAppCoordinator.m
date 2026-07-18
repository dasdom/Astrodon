//  Created by Dominik Hauser on 03.04.26.
//  
//


#import "DDHAppCoordinator.h"
#import "DDHMainWindowController.h"
#import "DDHTimelineWindowController.h"
#import "DDHTimelineWindowControllerDelegate.h"
#import "DDHImageLoader.h"
#import "DDHAPIClient.h"
#import "DDHMediaAttachment.h"
#import "DDHImageViewerViewController.h"
#import "DDHAccount.h"
#import "DDHAccountViewController.h"
#import "DDHToot.h"
#import "DDHStatusContextViewController.h"
#import "DDHTag.h"
#import "DDHTimelineViewController.h"

@interface DDHAppCoordinator () <DDHTimelineWindowControllerDelegate>
@property (strong) NSWindowController *windowController;
@property (strong) DDHAPIClient *apiClient;
@property (strong) DDHImageLoader *imageLoader;
@end

@implementation DDHAppCoordinator

- (NSWindowController *)start {
  _imageLoader = [[DDHImageLoader alloc] init];
  _apiClient = [[DDHAPIClient alloc] init];

//  _windowController = [[DDHMainWindowController alloc] initWithDelegate:self imageLoader:_imageLoader apiClient:_apiClient];
  _windowController = [[DDHTimelineWindowController alloc] initWithDelegate:self imageLoader:_imageLoader apiClient:_apiClient];
  return _windowController;
}

// MARK: - DDHTimelineWindowControllerDelegate
- (void)windowController:(NSWindowController *)windowController didClickItem:(id)item {
  if ([item isKindOfClass:[NSURL class]]) {
    // Link in post
    NSURL *url = (NSURL *)item;
    NSLog(@"url: %@", url);
    [NSWorkspace.sharedWorkspace openURL:url];

  } else if ([item isKindOfClass:[DDHMediaAttachment class]]) {
    // Image
    DDHMediaAttachment *attachment = (DDHMediaAttachment *)item;
    DDHImageViewerViewController *imageViewController = [[DDHImageViewerViewController alloc] initWithMediaAttachment:attachment imageLoader:self.imageLoader];
    [windowController.contentViewController presentViewControllerAsModalWindow:imageViewController];

  } else if ([item isKindOfClass:[DDHAccount class]]) {
    // Account
    DDHAccount *account = (DDHAccount *)item;
    DDHAccountViewController *accountViewController = [[DDHAccountViewController alloc] initWithAccount:account imageLoader:self.imageLoader apiClient:self.apiClient];
    [windowController.contentViewController presentViewControllerAsModalWindow:accountViewController];

  } else if ([item isKindOfClass:[DDHToot class]]) {
    // Thread
    DDHToot *toot = (DDHToot *)item;
    DDHStatusContextViewController *statusContextViewController = [[DDHStatusContextViewController alloc] initWithAPIClient:self.apiClient toot:toot.tootToShow imageLoader:self.imageLoader];
//    [windowController.contentViewController presentViewControllerAsModalWindow:statusContextViewController];

    NSWindow *contextWindow = [NSWindow windowWithContentViewController:statusContextViewController];
    [contextWindow makeKeyAndOrderFront:self];

    NSRect windowRect = self.windowController.window.frame;
    windowRect.origin.x = windowRect.origin.x + windowRect.size.width;
    windowRect.origin.y = windowRect.origin.y + (windowRect.size.height - contextWindow.frame.size.height);
    [contextWindow setFrameOrigin:windowRect.origin];
  } else if ([item isKindOfClass:[DDHTag class]]) {
    // Tag
    DDHTag *hashtag = (DDHTag *)item;

    DDHTimelineWindowController *windowController = [[DDHTimelineWindowController alloc] initWithDelegate:self hashtag:hashtag.name imageLoader:self.imageLoader apiClient:self.apiClient];

    NSWindow *hashtagWindow = windowController.window;
    [hashtagWindow makeKeyAndOrderFront:self];

    NSRect windowRect = self.windowController.window.frame;
    windowRect.origin.x = windowRect.origin.x + windowRect.size.width / 2;
    [hashtagWindow setFrameOrigin:windowRect.origin];
  }
}

@end
