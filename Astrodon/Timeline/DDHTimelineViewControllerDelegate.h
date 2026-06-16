//  Created by Dominik Hauser on 03.04.26.
//  
//


#ifndef DDHTimelineViewControllerDelegate_h
#define DDHTimelineViewControllerDelegate_h

@class NSViewController;

@protocol DDHTimelineViewControllerDelegate <NSObject>
- (void)viewController:(NSViewController *)viewController didClickItem:(id)item;
- (void)viewControllerStartedLoading:(NSViewController *)viewController;
- (void)viewControllerStoppedLoading:(NSViewController *)viewController;
@end

#endif /* DDHTimelineViewControllerDelegate_h */
