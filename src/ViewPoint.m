#define VIEW_POINT_INCLUDE

#import "ViewPoint.h"
#import "Maze3D.h"
#import "MazeTypes.h"
#import "MazeController.h"
#import "MazeSetting.h"

@interface ViewPoint(Private)
- (void)notifyChanging;
@end
@implementation ViewPoint
static BOOL hasInitialized = NO;
+ (void)initialize
{
	if (!hasInitialized) {
		ViewPointDidChangeNotification = @"ViewPointDidChangeNotification";
		ViewPointTransformKey = @"ViewPointTransformKey";
		hasInitialized = YES;
	}
}
- (void)mazeDidInitialize:(NSNotification*)note	{ NSLog(@"note: %@", note);

	_maze 			= note.object;
	self.transform = CATransform3DIdentity;		// 全体を傾かせる
	CGFloat angle 	= 0.5f * M_PI;
	self.transform = CATransform3DMakeRotation(-angle , 1.0f, 0.0f , 0.0f);
	self.position  = _maze.start;
}

- (void)setPosition:(MazePosition)position
{
	CGF PIECE_SIZE = _maze.controller.setting.cellSize;
	LOG_EXPR(PIECE_SIZE);
	CATransform3D inverted = CATransform3DInvert(self.transform);
	inverted.m41 = PIECE_SIZE / 2 + position.x * PIECE_SIZE;
	inverted.m42 = PIECE_SIZE / 2 + position.y * PIECE_SIZE;
	inverted.m43 = PIECE_SIZE / 2 + position.z * PIECE_SIZE;
	_transform = CATransform3DInvert(inverted);
	[self notifyChanging];
}
- (MazePosition)position	{	return [self getPositionForInvertedTransform:CATransform3DInvert(_transform)];	}

- (MazePosition)getPositionForInvertedTransform:(CATransform3D)inverted	{
	
	CGF PIECE_SIZE = _maze.controller.setting.cellSize;
	return makePosition((int) floor((inverted.m41 - PIECE_SIZE / 2 + EPS) / PIECE_SIZE),
							  (int) floor((inverted.m42 - PIECE_SIZE / 2 + EPS) / PIECE_SIZE),
							  (int) floor((inverted.m43 - PIECE_SIZE / 2 + EPS) / PIECE_SIZE));
}
- (void)moveForward	{ self.transform = CATransform3DConcat(self.transform,
																				CATransform3DMakeTranslation(0.0f, 0.0f, _maze.controller.setting.cellSize)); }
- (MazePosition)forwardPosition
{
	return [self getPositionForInvertedTransform:
			  CATransform3DInvert( CATransform3DConcat(self.transform, CATransform3DMakeTranslation(0.0f,0.0f,_maze.controller.setting.cellSize)))];
}

- (void)notifyChanging
{
	[AZNOTCENTER postNotificationName:ViewPointDidChangeNotification object:self userInfo:@{ViewPointTransformKey:AZV3d(self.transform)}];
}

- (void)moveDBack {
	self.transform =
	CATransform3DConcat(self.transform, CATransform3DMakeTranslation(0.0f, 0.0f, -_maze.controller.setting.cellSize));
	[self notifyChanging];
}


@end
