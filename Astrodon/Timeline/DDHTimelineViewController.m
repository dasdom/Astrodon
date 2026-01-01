//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineViewController.h"
#import "DDHTimelineView.h"
#import "DDHToot.h"
#import "DDHAccount.h"
#import "DDHAPIClient.h"
#import "DDHTimelineCellView.h"
#import "DDHImageLoader.h"
#import "DDHServerInputViewController.h"
#import "DDHKeychain.h"
#import "DDHConstants.h"
#import "DDHEndpoint.h"
#import <OSLog/OSLog.h>

@interface DDHTimelineViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) NSRelativeDateTimeFormatter *relativeDateTimeFormatter;
@property (strong) NSArray<DDHToot *> *toots;
@property (strong) DDHAPIClient *apiClient;
@property (strong) DDHImageLoader *imageLoader;
@end

@implementation DDHTimelineViewController

- (instancetype)init {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _relativeDateTimeFormatter = [[NSRelativeDateTimeFormatter alloc] init];
    _relativeDateTimeFormatter.unitsStyle = NSRelativeDateTimeFormatterUnitsStyleAbbreviated;
  }
  return self;
}

- (DDHTimelineView *)contentView {
  return (DDHTimelineView *)self.view;
}

- (NSTableView *)tableView {
  return self.contentView.tableView;
}

- (void)loadView {
  self.view = [[DDHTimelineView alloc] initWithFrame:CGRectMake(0, 0, 480, 600)];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  self.tableView.usesAutomaticRowHeights = YES;
  [self.tableView sizeLastColumnToFit];

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
  if (nil == cellView) {
    cellView = [[DDHTimelineCellView alloc] init];
    cellView.boostButton.target = self;
    cellView.boostButton.action = @selector(boost:);
    cellView.clickHandler = ^(NSURL *url) {
      NSLog(@"url: %@", url);
      [NSWorkspace.sharedWorkspace openURL:url];
    };
  }

  [cellView updateWithToot:toot imageLoader:self.imageLoader relativeDateTimeFormatter:self.relativeDateTimeFormatter];

  return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  NSLog(@"notification: %@", notification);
}

// MARK: - Actions
- (void)loadToots:(id)sender {
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

- (IBAction)showMore:(NSButton *)sender {
  NSInteger index = [self.tableView rowForView:sender];
  os_log(OS_LOG_DEFAULT, "index: %ld", index);
  DDHToot *toot = self.toots[index];
  toot.showsSensitive = !toot.showsSensitive;

  [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}

- (void)boost:(NSButton *)sender {
  NSPoint buttonOriginInCellView = sender.frame.origin;
  NSPoint buttonOriginInTableView = [self.tableView convertPoint:buttonOriginInCellView fromView:sender.superview];
  NSInteger row = [self.tableView rowAtPoint:buttonOriginInTableView];
  DDHToot *toot = self.toots[row];
  NSLog(@"toot id: %@", toot.statusId);
  [self.apiClient boostStatusWithId:toot.statusId completionHandler:^(NSError * _Nonnull error) {
    if (nil == error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        sender.bezelColor = [NSColor colorNamed:@"colors/boosted"];
      });
    } else {
      NSLog(@"error: %@", error);
    }
  }];
}

@end
