//  Created by Dominik Hauser on 05.07.26.
//  
//


#ifndef DDHMainWindowControllerDelegate_h
#define DDHMainWindowControllerDelegate_h

@class NSWindowController;

@protocol DDHMainWindowControllerDelegate <NSObject>
- (void)windowController:(NSWindowController *)windowController didClickItem:(id)item;
@end

#endif /* DDHMainWindowControllerDelegate_h */
