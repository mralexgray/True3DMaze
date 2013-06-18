//
//  ViewPoint.h
//  MazeSample
//
//  Created by Terazzo on 11/12/14.
//

#import <QuartzCore/CoreAnimation.h>
#import "MazeTypes.h"

@class  Maze3D;
@interface ViewPoint : NSObject
@property (weak) Maze3D *maze;
@property CATransform3D transform;
@property (nonatomic) MazePosition position;
@property (readonly) MazePosition forwardPosition;
//- (void)setPosition:(MazePosition)position;
//- (MazePosition)getPosition;
- (MazePosition)getPositionForInvertedTransform:(CATransform3D)inverted;
//- (MazePosition)getForwardPosition;
- (void)moveForward;
- (void)moveDBack;
@end

//{   CATransform3D transform;	}