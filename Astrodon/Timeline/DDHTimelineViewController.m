//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineViewController.h"
#import "DDHTimelineView.h"
#import "DDHToot.h"
#import "DDHAccount.h"
#import "DDHAPIClient.h"
#import "DDHTootCellView.h"
#import "DDHImageLoader.h"
#import "DDHServerInputViewController.h"
#import "DDHKeychain.h"
#import "DDHConstants.h"
#import "DDHEndpoint.h"
#import "DDHTootInputViewController.h"
#import "DDHTootView.h"
#import <OSLog/OSLog.h>

@interface DDHTimelineViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) NSRelativeDateTimeFormatter *relativeDateTimeFormatter;
@property (strong) NSTableViewDiffableDataSource *dataSource;
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

  __weak typeof(self)weakSelf = self;
  _dataSource = [[NSTableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^NSView * _Nonnull(NSTableView * _Nonnull tableView, NSTableColumn * _Nonnull column, NSInteger row, id  _Nonnull itemId) {

    DDHToot *toot = weakSelf.toots[row];
    DDHTootCellView *cellView;

//    if (nil != toot.quote) {
//      DDHTootWithQuoteCellView *tootWithQuoteCellView = [tableView makeViewWithIdentifier:@"DDHTootWithQuoteCellView" owner:self];
//      if (nil == tootWithQuoteCellView) {
//        tootWithQuoteCellView = [[DDHTootWithQuoteCellView alloc] init];
//        tootWithQuoteCellView.identifier = @"DDHTootWithQuoteCellView";
//        tootWithQuoteCellView.boostButton.target = weakSelf;
//        tootWithQuoteCellView.boostButton.action = @selector(boost:);
//        tootWithQuoteCellView.replyButton.target = weakSelf;
//        tootWithQuoteCellView.replyButton.action = @selector(reply:);
//        tootWithQuoteCellView.clickHandler = ^(NSURL *url) {
//          NSLog(@"url: %@", url);
//          [NSWorkspace.sharedWorkspace openURL:url];
//        };
//      }
//      cellView = tootWithQuoteCellView;
//    } else {
      DDHTootCellView *tootCellView = [tableView makeViewWithIdentifier:@"DDHTimelineCellView" owner:self];
      if (nil == tootCellView) {
        tootCellView = [[DDHTootCellView alloc] init];
        tootCellView.identifier = @"DDHTimelineCellView";
        tootCellView.boostButton.target = weakSelf;
        tootCellView.boostButton.action = @selector(boost:);
        tootCellView.replyButton.target = weakSelf;
        tootCellView.replyButton.action = @selector(reply:);
        tootCellView.tootView.clickHandler = ^(NSURL *url) {
          NSLog(@"url: %@", url);
          [NSWorkspace.sharedWorkspace openURL:url];
        };
      }
      cellView = tootCellView;
//      }

    [cellView updateWithToot:toot imageLoader:weakSelf.imageLoader relativeDateTimeFormatter:weakSelf.relativeDateTimeFormatter];

    return cellView;
  }];

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

- (void)updateWithToots:(NSArray<DDHToot *> *)toots {
  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
  [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
  NSMutableArray<NSString *> *tootsIds = [[NSMutableArray alloc] initWithCapacity:[toots count]];
  for (DDHToot *toot in toots) {
    [tootsIds addObject:toot.statusId];
  }
  [snapshot appendItemsWithIdentifiers:tootsIds];
  [self.dataSource applySnapshot:snapshot animatingDifferences:true];
}

// MARK: - Actions
- (void)loadToots:(id)sender {
  NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
  if (code.length < 1) {
    [self presentViewControllerAsSheet:[DDHServerInputViewController new]];
  } else {
    __weak typeof(self)weakSelf = self;
    [self.apiClient timelineFromEndpoint:DDHEndpointHome completionHandler:^(NSArray<DDHToot *> * _Nonnull toots, NSError * _Nonnull error) {
      NSLog(@"error: %@", error);
      weakSelf.toots = toots;
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//      });
      [weakSelf updateWithToots:toots];
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
  NSInteger row = [self.tableView rowForView:sender];
  DDHToot *toot = self.toots[row];
  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;
  NSLog(@"toot id: %@", toot.statusId);
  NSLog(@"boosting toot with id: %@", tootToShow.statusId);
  [self.apiClient boostStatusWithId:tootToShow.statusId completionHandler:^(NSError * _Nonnull error) {
    if (nil == error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        sender.bezelColor = [NSColor colorNamed:@"colors/boosted"];
      });
    } else {
      NSLog(@"error: %@", error);
    }
  }];
}

- (void)reply:(NSButton *)sender {
  NSInteger row = [self.tableView rowForView:sender];
  DDHToot *toot = self.toots[row];
  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;
  NSLog(@"toot id: %@", toot.statusId);
  NSLog(@"replying to toot with id: %@", tootToShow.statusId);
  [self openTootInputReplyingToToot:tootToShow];
}

- (void)newDocument:(id)sender {
  [self openTootInputReplyingToToot:nil];
}

- (void)openTootInputReplyingToToot:(nullable DDHToot *)toot {
  DDHTootInputViewController *tootInputViewController = [[DDHTootInputViewController alloc] initWithToot:toot imageLoader:self.imageLoader relativeDateTimeFormatter:self.relativeDateTimeFormatter];
  tootInputViewController.title = @"New Toot";

  NSWindow *inputWindow = [NSWindow windowWithContentViewController:tootInputViewController];
  [inputWindow makeKeyAndOrderFront:self];
}

@end
