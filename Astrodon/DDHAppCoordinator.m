//  Created by Dominik Hauser on 03.04.26.
//  
//


#import "DDHAppCoordinator.h"
#import "DDHTimelineWindowController.h"
#import "DDHTimelineWindowControllerDelegate.h"
#import "DDHImageLoader.h"
#import "DDHAPIClient.h"

@interface DDHAppCoordinator () <DDHTimelineWindowControllerDelegate>
@property (strong) NSWindowController *windowController;
@property (strong) DDHAPIClient *apiClient;
@property (strong) DDHImageLoader *imageLoader;
@end

@implementation DDHAppCoordinator

- (NSWindowController *)start {
  _imageLoader = [[DDHImageLoader alloc] init];
  _apiClient = [[DDHAPIClient alloc] init];

  _windowController = [[DDHTimelineWindowController alloc] initWithDelegate:self imageLoader:_imageLoader apiClient:_apiClient];
  return _windowController;
}

// MARK: - DDHTimelineWindowControllerDelegate
- (void)windowController:(NSWindowController *)windowController didClickItem:(id)item {
  
}

@end
