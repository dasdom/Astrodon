//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineViewController.h"
#import "DDHToot.h"
#import "DDHAPIClient.h"
#import "DDHTimelineCellView.h"

@interface DDHTimelineViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) NSArray<DDHToot *> *toots;
@property (strong) DDHAPIClient *apiClient;
@property IBOutlet NSTableView *tableView;
@end

@implementation DDHTimelineViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.toots = @[];
  self.apiClient = [DDHAPIClient new];
}

- (void)viewWillAppear {
  [super viewWillAppear];

  [self.apiClient publicTimeline:^(NSArray<DDHToot *> * _Nonnull toots, NSError * _Nonnull error) {
    self.toots = toots;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView reloadData];
    });
  }];
}

// MARK: - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [self.toots count];
}

// MARK: - NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

  DDHToot *toot = self.toots[row];
  DDHTimelineCellView *cellView = [tableView makeViewWithIdentifier:@"DDHTimelineCellView" owner:self];
  cellView.textField.stringValue = toot.content;
  return cellView;
}

@end
