//
//  MazeView.h
//  True3DMaze
//
//  Created by Terazzo on 11/12/14.
//

#import <Cocoa/Cocoa.h>
#import "MazeController.h"

@class MazeController, MazeLayer;
@interface MazeView : NSView

@property (weak) MazeLayer *hoveredLayer;
@property NSPoint mouseDownPoint; // マウスダウン位置
@property BOOL dragging;          // ドラッグ有無

@property(weak) IBOutlet MazeController *controller;
@end

@interface MazeView ()
- (void) updatePerspective;
- (void) updateViewPoint:			(CATransform3D)transform;
- (void) updateAppearanceSetting:(MazeSetting*)setting;
- (void) mazeDidInitialize:		(NSNOT*)notification;
- (void) viewPointDidChange:		(NSNOT*)notification;
@end



//    IBOutlet MazeController *controller;
