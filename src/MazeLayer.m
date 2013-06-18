	//
	//  MazeLayer.m
	//  MazeSample
	//
	//  Created by Terazzo on 11/12/14.
	//

#import "MazeLayer.h"
#import "MazeTypes.h"


@implementation MazeLayer
@synthesize originalTransform;
@synthesize special;
+ (id)layerWithPosition:(MazePosition)p for:(Direction)direction
{
	MazeLayer *layer;	if (!(layer = self.new)) return nil;
	layer.autoresizingMask = kCALayerNotSizable;
	layer.frame 				= AZRectFromDim(PIECE_SIZE);
	layer.anchorPoint 		= AZPointFromDim(.5);

		// 位置を移動
	CATransform3D transform = CATransform3DIdentity;
		// 中心を微調整
	transform = CATransform3DTranslate(transform, PIECE_SIZE/2, PIECE_SIZE/2, PIECE_SIZE/2);

		// 迷路全体の端からの座標に移動
	transform = CATransform3DTranslate(transform, p.x * PIECE_SIZE, p.y * PIECE_SIZE, p.z * PIECE_SIZE);
	switch (direction) {
		case DIR_Y:
            // X軸で立てる
			transform = CATransform3DRotate(transform, 0.5f * M_PI, 1.0f, 0.0f, 0.0f);
            // 壁側に移動
			transform = CATransform3DTranslate(transform, 0.0f, 0.0f, PIECE_SIZE / 2);
			break;
		case DIR_X:
            // Z軸で回転
			transform = CATransform3DRotate(transform, -0.5f * M_PI, 0.0f, 0.0f, 1.0f);
            // X軸で立てる
			transform = CATransform3DRotate(transform, 0.5f * M_PI, 1.0f, 0.0f, 0.0f);
            // 壁側に移動
			transform = CATransform3DTranslate(transform, 0.0f, 0.0f, PIECE_SIZE / 2);
			break;
		case DIR_Z:
            // 床の位置に移動
			transform = CATransform3DTranslate(transform, 0.0f, 0.0f, -PIECE_SIZE / 2);
			break;
		case NODIR:
	 	case XMINUS:
		case YPLUS:
		case ZPLUS:
			transform = CATransform3DIdentity;
			break;
	}
	layer.originalTransform = transform;
	[layer setNeedsDisplay];
	return layer;
}

- (void)updateTransform:(CATransform3D)viewPointTransform;
{
	self.transform =
	CATransform3DConcat(originalTransform, viewPointTransform);

	if (self.transform.m43 > PIECE_SIZE / 2 - EPS) {
		if (!self.hidden) {
			self.hidden = YES;
		}
	} else {
		if (self.hidden) {
			self.hidden = NO;
		}
	}
}
@end
