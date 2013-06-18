	//
	//  MazeLayer.m
	//  MazeSample
	//
	//  Created by Terazzo on 11/12/14.
	//

#import "MazeLayer.h"
#import "MazeTypes.h"
#import "MazeController.h"
#import "MazeSetting.h"

@implementation MazeLayer

+ (instancetype)layerWithPosition:(MazePosition)p for:(Direction)direction controller:(MazeController *)ctr
{
	MazeLayer *layer;	if (!(layer = self.new)) return nil;
	layer.controller 			= ctr;
	layer.autoresizingMask 	= kCALayerNotSizable;
//	[layer bind:@"frame" toObject:ctr.setting withKeyPath:@"cellSize" transform:^id(id value) {
//		 return AZVrect(AZRectFromDim([value floatValue])); }];
	layer.frame = AZRectFromDim(24);
	layer.anchorPoint 		= AZPointFromDim(.5);
	layer.direction 			= direction;
	layer.mazePosition		= p;
	return layer;
}
- (CGF) PIECE_SIZE { return _controller.setting.cellSize; }

- (void) setDirection:(Direction)direction	{ _direction = direction;

	// 位置を移動
	CATransform3D transform = CATransform3DIdentity;
	// 中心を微調整
	transform = CATransform3DTranslate(transform, self.PIECE_SIZE/2, self.PIECE_SIZE/2, self.PIECE_SIZE/2);

	// 迷路全体の端からの座標に移動
	transform = CATransform3DTranslate(transform, _mazePosition.x * self.PIECE_SIZE, _mazePosition.y * self.PIECE_SIZE, _mazePosition.z * self.PIECE_SIZE);
	switch (direction) {
		case DIR_Y:
			// X軸で立てる
			transform = CATransform3DRotate(transform, 0.5f * M_PI, 1.0f, 0.0f, 0.0f);
			// 壁側に移動
			transform = CATransform3DTranslate(transform, 0.0f, 0.0f, self.PIECE_SIZE / 2);
			break;
		case DIR_X:
			// Z軸で回転
			transform = CATransform3DRotate(transform, -0.5f * M_PI, 0.0f, 0.0f, 1.0f);
			// X軸で立てる
			transform = CATransform3DRotate(transform, 0.5f * M_PI, 1.0f, 0.0f, 0.0f);
			// 壁側に移動
			transform = CATransform3DTranslate(transform, 0.0f, 0.0f, self.PIECE_SIZE / 2);
			break;
		case DIR_Z:
			// 床の位置に移動
			transform = CATransform3DTranslate(transform, 0.0f, 0.0f, -self.PIECE_SIZE / 2);
			break;
		case NODIR:
	 	case XMINUS:
		case YPLUS:
		case ZPLUS:
			transform = CATransform3DIdentity;
			break;
	}
//	_originalTransform =
	self.mazeTransform = transform;
	[self setNeedsDisplay];

}

//- (void)updateTransform:(CATransform3D)viewPointTransform;
- (void)setMazeTransform:(CATransform3D)mazeTransform
{
	_mazeTransform = CATransform3DConcat(self.transform, mazeTransform);
	self.transform = _mazeTransform;
//	_transform  =	CATransform3DConcat(self.transform, transform);


	if (self.transform.m43 > self.PIECE_SIZE / 2 - self.PIECE_SIZE) {
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
