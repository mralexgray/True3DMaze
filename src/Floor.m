//
//  Floor.m
//  True3DMaze2013
//
//  Created by Alex Gray on 6/18/13.
//
//

#import "Floor.h"

@implementation Floor

- (id)init	{  if (!(self = super.init)) return nil;


	CATL *tl = [CATL layerWithFrame:self.bounds];
	CAL *floorTiles = [CAL layerWithFrame:self.bounds];
	tl.arMASK = floorTiles.arMASK = CASIZEABLE;
	self.loM = AZLAYOUTMGR;1
	[self addConstraintsSuperSize];
	self.sublayers = @[tl];
	tl.sublayers = @[floorTiles];


	CATransform3D transform = CATransform3DIdentity;
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

	self.backgroundColor = GRAY2.CGColor;
	return self;
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
