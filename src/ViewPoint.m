#define VIEW_POINT_INCLUDE

#import "ViewPoint.h"
#import "Maze3D.h"
#import "MazeTypes.h"

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
- (void)mazeDidInitialize:(NSNotification*)note	{

	Maze3D *maze 	= note.object;
	self.transform = CATransform3DIdentity;		// 全体を傾かせる
	CGFloat angle 	= 0.5f * M_PI;
	self.transform = CATransform3DMakeRotation(-angle , 1.0f, 0.0f , 0.0f);
	self.position  = maze.start;
}

- (void)setPosition:(MazePosition)position
{
	CATransform3D inverted = CATransform3DInvert(self.transform);
	inverted.m41 = PIECE_SIZE / 2 + position.x * PIECE_SIZE;
	inverted.m42 = PIECE_SIZE / 2 + position.y * PIECE_SIZE;
	inverted.m43 = PIECE_SIZE / 2 + position.z * PIECE_SIZE;
	self.transform = CATransform3DInvert(inverted);
	[self notifyChanging];
}
- (MazePosition)getPosition	{	return [self getPositionForInvertedTransform:CATransform3DInvert(self.transform)];	}
- (MazePosition)getPositionForInvertedTransform:(CATransform3D)inverted	{
	return makePosition((int) floor((inverted.m41 - PIECE_SIZE / 2 + EPS) / PIECE_SIZE),
							  (int) floor((inverted.m42 - PIECE_SIZE / 2 + EPS) / PIECE_SIZE),
							  (int) floor((inverted.m43 - PIECE_SIZE / 2 + EPS) / PIECE_SIZE));
}
- (void)moveForward	{ self.transform = CATransform3DConcat(self.transform, CATransform3DMakeTranslation(0.0f, 0.0f, PIECE_SIZE)); }
- (MazePosition)getForwardPosition
{
	return [self getPositionForInvertedTransform:
			  CATransform3DInvert( CATransform3DConcat(self.transform, CATransform3DMakeTranslation(0.0f, 0.0f, PIECE_SIZE)))];
}

- (void)notifyChanging
{
	[AZNOTCENTER postNotificationName:ViewPointDidChangeNotification object:self userInfo:@{ViewPointTransformKey:AZV3d(self.transform)}];
}

- (void)moveDBack {
	self.transform =
	CATransform3DConcat(self.transform, CATransform3DMakeTranslation(0.0f, 0.0f, -PIECE_SIZE));
}


@end
