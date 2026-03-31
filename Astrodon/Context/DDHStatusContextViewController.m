//  Created by Dominik Hauser on 29.03.26.
//
//


#import "DDHStatusContextViewController.h"
#import "DDHTimelineView.h"
#import "DDHAPIClient.h"
#import "DDHToot.h"
#import "DDHContext.h"
#import "DDHImageLoader.h"
#import "NSArray+Extensions.h"
#import "DDHTootCellView.h"
#import "DDHTootView.h"
#import "DDHImageViewerViewController.h"
#import "DDHAccountViewController.h"
#import "DDHStatusContextViewController.h"
#import "DDHMediaAttachment.h"
#import "DDHAccount.h"

@interface DDHStatusContextViewController ()
@property (strong) DDHAPIClient *apiClient;
@property (strong) DDHToot *toot;
@property (strong) DDHContext *context;
@property (strong) NSRelativeDateTimeFormatter *relativeDateTimeFormatter;
@property (strong) NSTableViewDiffableDataSource *dataSource;
@property (strong) DDHImageLoader *imageLoader;
@property (strong) NSArray<NSString *> *ancestorIds;
@property (strong) NSArray<NSString *> *descendantIds;
@end

@implementation DDHStatusContextViewController

- (instancetype)initWithAPIClient:(DDHAPIClient *)apiClient toot:(DDHToot *)toot imageLoader:(DDHImageLoader *)imageLoader {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _apiClient = apiClient;
    _toot = toot;
    _imageLoader = imageLoader;

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

  self.title = [NSString stringWithFormat:@"Thread: %@", self.toot.plainContent];

  typeof(self) __weak weakSelf = self;

  _dataSource = [[NSTableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^NSView * _Nonnull(NSTableView * _Nonnull tableView, NSTableColumn * _Nonnull column, NSInteger row, NSString * _Nonnull itemId) {

    DDHToot *toot;
    NSColor *backgroundColor;
    if ([weakSelf.ancestorIds containsObject:itemId]) {
      NSUInteger index = [weakSelf.context.ancestors indexOfObjectPassingTest:^BOOL(DDHToot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.statusId isEqualToString:itemId];
      }];
      toot = weakSelf.context.ancestors[index];
      backgroundColor = [NSColor secondarySystemFillColor];
    } else if ([weakSelf.descendantIds containsObject:itemId]) {
      NSUInteger index = [weakSelf.context.descendants indexOfObjectPassingTest:^BOOL(DDHToot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.statusId isEqualToString:itemId];
      }];
      toot = weakSelf.context.descendants[index];
      backgroundColor = [NSColor secondarySystemFillColor];
    } else {
      toot = weakSelf.toot;
    }

    DDHTootCellView *tootCellView = [tableView makeViewWithIdentifier:@"DDHContextCellView" owner:self];
    if (nil == tootCellView) {
      tootCellView = [[DDHTootCellView alloc] init];
      tootCellView.identifier = @"DDHContextCellView";

      tootCellView.boostButton.target = weakSelf;
      tootCellView.boostButton.action = @selector(boost:);

      tootCellView.favoriteButton.target = weakSelf;
      tootCellView.favoriteButton.action = @selector(favorite:);

      tootCellView.replyButton.target = weakSelf;
      tootCellView.replyButton.action = @selector(reply:);

      tootCellView.tootView.clickHandler = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
          NSURL *url = (NSURL *)item;
          NSLog(@"url: %@", url);
          [NSWorkspace.sharedWorkspace openURL:url];
        } else if ([item isKindOfClass:[DDHMediaAttachment class]]) {
          DDHMediaAttachment *attachment = (DDHMediaAttachment *)item;
          DDHImageViewerViewController *imageViewController = [[DDHImageViewerViewController alloc] initWithMediaAttachment:attachment imageLoader:weakSelf.imageLoader];
          [weakSelf presentViewControllerAsModalWindow:imageViewController];
        } else if ([item isKindOfClass:[DDHAccount class]]) {
          DDHAccount *account = (DDHAccount *)item;
          DDHAccountViewController *accountViewController = [[DDHAccountViewController alloc] initWithAccount:account imageLoader:weakSelf.imageLoader];
          [weakSelf presentViewControllerAsModalWindow:accountViewController];
        } else if ([item isKindOfClass:[DDHToot class]]) {
          DDHToot *toot = (DDHToot *)item;
          DDHStatusContextViewController *statusContextViewController = [[DDHStatusContextViewController alloc] initWithAPIClient:weakSelf.apiClient toot:toot imageLoader:weakSelf.imageLoader];
          [weakSelf presentViewControllerAsModalWindow:statusContextViewController];
        }
      };

    }

    tootCellView.wantsLayer = YES;
    tootCellView.layer.backgroundColor = backgroundColor.CGColor;
    [tootCellView updateWithToot:toot imageLoader:weakSelf.imageLoader relativeDateTimeFormatter:weakSelf.relativeDateTimeFormatter];

    return tootCellView;
  }];

  [self.apiClient contextForId:self.toot.statusId completionHandler:^(DDHContext *context, NSError * _Nonnull error) {
    weakSelf.context = context;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    });
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf updateWithToot:weakSelf.toot context:context];
    });
  }];

  self.tableView.usesAutomaticRowHeights = YES;
  [self.tableView sizeLastColumnToFit];
}

- (void)updateWithToot:(DDHToot *)toot context:(DDHContext *)context {
  self.ancestorIds = [context.ancestors map:^NSString * _Nonnull (DDHToot * _Nonnull element) {
    return element.statusId;
  }];

  self.descendantIds = [context.descendants map:^NSString * _Nonnull(DDHToot * _Nonnull element) {
    return element.statusId;
  }];

  NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];

  [snapshot appendSectionsWithIdentifiers:@[@"Ancestors", @"Toot", @"Descendants"]];
  [snapshot appendItemsWithIdentifiers:self.ancestorIds intoSectionWithIdentifier:@"Ancestors"];

  [snapshot appendItemsWithIdentifiers:@[self.toot.statusId] intoSectionWithIdentifier:@"Toot"];

  [snapshot appendItemsWithIdentifiers:self.descendantIds intoSectionWithIdentifier:@"Descendants"];

  [self.dataSource applySnapshot:snapshot animatingDifferences:true];

  typeof(self) __weak weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSInteger row = [weakSelf.dataSource rowForItemIdentifier:weakSelf.toot.statusId];
    [weakSelf.tableView scrollRowToVisible:row];
  });
}

@end
