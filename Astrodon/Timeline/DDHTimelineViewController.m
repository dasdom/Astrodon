//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineViewController.h"
#import "DDHToot.h"
#import "DDHAccount.h"
#import "DDHAPIClient.h"
#import "DDHTimelineCellView.h"
#import "DDHImageLoader.h"
#import "DDHServerInputViewController.h"
#import "DDHKeychain.h"
#import "DDHConstants.h"
#import "DDHEndpoint.h"

@interface DDHTimelineViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) NSArray<DDHToot *> *toots;
@property (strong) DDHAPIClient *apiClient;
@property IBOutlet NSTableView *tableView;
@property (strong) DDHImageLoader *imageLoader;
@end

@implementation DDHTimelineViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.toots = @[];
  self.apiClient = [DDHAPIClient new];
  self.imageLoader = [DDHImageLoader new];
}

- (void)viewWillAppear {
  [super viewWillAppear];

}

- (void)viewDidAppear {
  [super viewDidAppear];

  [self loadToots:nil];
}

// MARK: - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [self.toots count];
}

// MARK: - NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

  DDHToot *toot = self.toots[row];
  DDHTimelineCellView *cellView = [tableView makeViewWithIdentifier:@"DDHTimelineCellView" owner:self];

  [cellView updateWithToot:toot imageLoader:self.imageLoader];

  return cellView;
}

// MARK: - Actions
- (IBAction)loadToots:(NSButton *)sender {
  NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
  if (code.length < 1) {
    [self presentViewControllerAsSheet:[DDHServerInputViewController new]];
  } else {
    [self.apiClient timelineFromEndpoint:DDHEndpointHome completionHandler:^(NSArray<DDHToot *> * _Nonnull toots, NSError * _Nonnull error) {
      NSLog(@"error: %@", error);
      self.toots = toots;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
      });
    }];
  }
}

@end
