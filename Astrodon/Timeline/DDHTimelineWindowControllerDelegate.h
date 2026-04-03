//  Created by Dominik Hauser on 03.04.26.
//  
//


#ifndef DDHTimelineWindowControllerDelegate_h
#define DDHTimelineWindowControllerDelegate_h

@class NSWindowController;

@protocol DDHTimelineWindowControllerDelegate <NSObject>
- (void)windowController:(NSWindowController *)windowController didClickItem:(id)item;
@end

#endif /* DDHTimelineWindowControllerDelegate_h */
