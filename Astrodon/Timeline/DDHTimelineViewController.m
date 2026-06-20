//  Created by Dominik Hauser on 17.11.22.
//  
//

#import "DDHTimelineViewController.h"
#import "DDHTimelineView.h"
#import "DDHToot.h"
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

@interface DDHTimelineViewController () <NSTableViewDelegate>
@property (strong) id<DDHTimelineViewControllerDelegate> delegate;
@property (strong) NSRelativeDateTimeFormatter *relativeDateTimeFormatter;
@property (strong) NSTableViewDiffableDataSource *dataSource;
@property (strong) NSArray<DDHToot *> *toots;
@property (strong) DDHAPIClient *apiClient;
@property (strong) DDHImageLoader *imageLoader;
@property BOOL updatingTimeline;
@property BOOL loadingBecauseScrolledNegative;
@end

@implementation DDHTimelineViewController

- (instancetype)initWithDelegate:(id<DDHTimelineViewControllerDelegate>)delegate imageLoader:(DDHImageLoader *)imageLoader apiClient:(DDHAPIClient *)apiClient {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _delegate = delegate;
    _imageLoader = imageLoader;
    _apiClient = apiClient;

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

- (NSScrollView *)scrollView {
  return self.contentView.scrollView;
}

- (void)loadView {
  self.view = [[DDHTimelineView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];

  self.scrollView.contentView.postsBoundsChangedNotifications = YES;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentViewDidChangeBounds:) name:NSViewBoundsDidChangeNotification object:self.scrollView.contentView];
}

- (void)viewDidLoad {
  [super viewDidLoad];


  self.tableView.delegate = self;

  __weak typeof(self)weakSelf = self;

  _dataSource = [[NSTableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^NSView * _Nonnull(NSTableView * _Nonnull tableView, NSTableColumn * _Nonnull column, NSInteger row, id  _Nonnull itemId) {

    DDHToot *toot = weakSelf.toots[row];

    DDHTootCellView *tootCellView = [tableView makeViewWithIdentifier:@"DDHTimelineCellView" owner:self];
    if (nil == tootCellView) {
      tootCellView = [[DDHTootCellView alloc] init];
      tootCellView.identifier = @"DDHTimelineCellView";

      tootCellView.boostButton.target = weakSelf;
      tootCellView.boostButton.action = @selector(boost:);

      tootCellView.favoriteButton.target = weakSelf;
      tootCellView.favoriteButton.action = @selector(favorite:);

      tootCellView.replyButton.target = weakSelf;
      tootCellView.replyButton.action = @selector(reply:);

      __weak typeof(self)weakSelf = self;
      tootCellView.tootView.clickHandler = ^(id item) {
        [weakSelf.delegate viewController:weakSelf didClickItem:item];
      };

    }

    [tootCellView updateWithToot:toot imageLoader:weakSelf.imageLoader relativeDateTimeFormatter:weakSelf.relativeDateTimeFormatter];

    return tootCellView;
  }];

  self.tableView.usesAutomaticRowHeights = YES;
  [self.tableView sizeLastColumnToFit];

  self.toots = @[];
}

- (void)viewWillAppear {
  [super viewWillAppear];

}

- (void)viewDidAppear {
  [super viewDidAppear];

  [self loadToots:nil withCompletionHandler:nil];
}

- (void)updateWithToots:(NSArray<DDHToot *> *)toots {
  if ([toots count] < 1) {
    return;
  }
  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
  [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
  NSMutableArray<NSString *> *tootsIds = [[NSMutableArray alloc] initWithCapacity:[toots count]];
  for (DDHToot *toot in toots) {
    [tootsIds addObject:toot.statusId];
  }
  os_log(OS_LOG_DEFAULT, "%@", tootsIds);
  [snapshot appendItemsWithIdentifiers:tootsIds];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf.dataSource applySnapshot:snapshot animatingDifferences:true];
  });
}

// MARK: - Actions
- (void)loadToots:(id)sender withCompletionHandler:(void(^)(void))completionHandler {
  NSString *code = [DDHKeychain loadStringForKey:codeKeychainName];
  if (code.length < 1) {
    [self presentViewControllerAsSheet:[DDHServerInputViewController new]];
  } else {

    if (self.updatingTimeline) {
      return;
    }

    self.updatingTimeline = YES;

    __weak typeof(self)weakSelf = self;
    DDHToot *firstToot = self.toots.firstObject;
    [self.apiClient homeTimelineSinceToot:firstToot completionHander:^(NSArray<DDHToot *> * _Nonnull toots, NSError * _Nonnull error) {

      if (completionHandler) {
        completionHandler();
      }

      if ([toots count] > 0) {
        NSLog(@"error: %@", error);
        if ([weakSelf.toots count] > 0) {
          // Add fetched toots at the beginning of the existing toots.
          weakSelf.toots = [toots arrayByAddingObjectsFromArray:weakSelf.toots];
        } else {
          weakSelf.toots = toots;
        }
        [weakSelf updateWithToots:weakSelf.toots];
      }
      weakSelf.updatingTimeline = NO;
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
  [self.apiClient boostStatusWithId:toot.tootToShow.statusId completionHandler:^(NSError * _Nonnull error) {
    if (nil == error) {
      toot.tootToShow.reblogged = YES;
      dispatch_async(dispatch_get_main_queue(), ^{
        sender.bezelColor = [NSColor colorNamed:@"colors/boosted"];
      });
    } else {
      NSLog(@"error: %@", error);
    }
  }];
}

- (void)favorite:(NSButton *)sender {
  NSInteger row = [self.tableView rowForView:sender];
  DDHToot *toot = self.toots[row];
  [self.apiClient favoriteStatusWithId:toot.tootToShow.statusId completionHandler:^(NSError * _Nonnull error) {
    if (nil == error) {
      toot.tootToShow.favourited = YES;
      dispatch_async(dispatch_get_main_queue(), ^{
        sender.bezelColor = [NSColor colorNamed:@"colors/boosted"];
        sender.image = [NSImage imageWithSystemSymbolName:@"star.fill" accessibilityDescription:@"favorite filled"];
      });
    } else {
      NSLog(@"error: %@", error);
    }
  }];
}

- (void)reply:(NSButton *)sender {
  NSInteger row = [self.tableView rowForView:sender];
  DDHToot *toot = self.toots[row];
//  DDHToot *tootToShow = [toot isBoost] ? toot.boostedToot : toot;
//  NSLog(@"toot id: %@", toot.statusId);
//  NSLog(@"replying to toot with id: %@", tootToShow.statusId);
  [self openTootInputReplyingToToot:toot.tootToShow];
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

// MARK: - Notification observer
- (void)contentViewDidChangeBounds:(NSNotification *)notification {
  NSView *documentView = self.scrollView.documentView;
  NSClipView *clipView = self.scrollView.contentView;

  if (clipView.bounds.origin.y + clipView.bounds.size.height > documentView.bounds.size.height) {
    if (self.toots.count < 1) {
      return;
    }
    os_log(OS_LOG_DEFAULT, "load more");

    if (self.updatingTimeline) {
      return;
    }

    [self.delegate viewControllerStartedLoading:self];

    self.updatingTimeline = YES;
    __weak typeof(self)weakSelf = self;
    DDHToot *lastToot = self.toots.lastObject;
    [self.apiClient homeTimelineBeforeToot:lastToot completionHander:^(NSArray<DDHToot *> * _Nonnull toots, NSError * _Nonnull error) {
      NSLog(@"error: %@", error);

      [self.delegate viewControllerStoppedLoading:self];

      if ([weakSelf.toots count] > 0) {
        // Add fetched toots at the beginning of the existing toots.
        weakSelf.toots = [weakSelf.toots arrayByAddingObjectsFromArray:toots];
      } else {
        weakSelf.toots = toots;
      }
      [weakSelf updateWithToots:weakSelf.toots];
      weakSelf.updatingTimeline = NO;
    }];
  } else if (clipView.bounds.origin.y < 0) {
    if (self.loadingBecauseScrolledNegative) {
      return;
    }
    self.loadingBecauseScrolledNegative = YES;
    [self loadToots:nil withCompletionHandler:^{}];
  } else {
    self.loadingBecauseScrolledNegative = NO;
  }
}

@end
