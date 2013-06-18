	//
	//  MazeView.m
	//  True3DMaze
	//
	//  Created by Terazzo on 11/12/14.
	//
#import <QuartzCore/QuartzCore.h>

#import "MazeView.h"
#import "ViewPoint.h"
#import "MazeSetting.h"
#import "Maze3D.h"
#import "MazeLayer.h"

@implementation MazeView

- (BOOL) acceptsFirstResponder 							{ return YES; }
- (void) mazeDidInitialize:			(NSNOT*)n		{

	[self becomeFirstResponder];
	self.window.acceptsMouseMovedEvents = YES;
	Maze3D *maze = (Maze3D*)n.object;

	CALayer *perspectiveLayer 	= CALayer.new;
	perspectiveLayer.frame 		= self.bounds;
	perspectiveLayer.arMASK 	= kCALayerNotSizable;
	perspectiveLayer.bgC 		= cgGREY;
	self.layer						= perspectiveLayer;
	self.wantsLayer				= YES;

	[AZNOTCENTER addObserverForName:@"MazeAppearanceSettingDidChangeNotification" object:_controller.setting queue:AZSOQ usingBlock:^(NSNOT*note) {
			NSLog(@"did recieve note! %@", note);
		//		:@[@"borderWidth", @"cornerRadius"] task:^(id obj, NSD *change) {
		[CATRANNY immediately:^{
			[self.layer.sublayers each:^(MazeLayer*m) {
				m.borderWidth = _controller.setting.borderWidth;
				m.cornerRadius = _controller.setting.cornerRadius;
				if (!m.special)	m.backgroundColor = _controller.setting.wallColor.CGColor;
				m.boundsHeight = _controller.setting.cellSize;
				m.boundsWidth = _controller.setting.cellSize;
				[m setNeedsDisplay];
			}];
		}];
	}];
	NSA *gPal = RANDOMPAL;
	void (^addLayerIfHavingWall)(MazePosition, WallDirection)= ^(MazePosition p, WallDirection d) {
		if ([maze hasWallAt:p for:d]) { MazeLayer *layer = [MazeLayer layerWithPosition:p for:d controller:_controller];
			[perspectiveLayer addSublayer:layer];

			if ([maze position:p isAroundStartFor:d]) {
				layer.backgroundColor= cgRANDOMCOLOR; layer.special = YES;
				}
			else if ([maze position:p isAroundGoalFor:d]){
				layer.backgroundColor = cgRANDOMCOLOR; layer.special =YES;
			} else layer.backgroundColor = [gPal.randomElement CGColor];
			layer.contents = NSIMG.randomMonoIcon;

		}
	};
	int i, j, k;
	for (i = 0; i <= maze.sizeX; i++) {
		for (j = 0; j <= maze.sizeY; j++) {
			for (k = 0; k <= maze.sizeZ; k++) {
				MazePosition position = makePosition(i, j, k);
				addLayerIfHavingWall(position, DIR_X);
				addLayerIfHavingWall(position, DIR_Y);
				addLayerIfHavingWall(position, DIR_Z);
			}
		}
	}
	[self updatePerspective];
}
- (void) resizeWithOldSuperviewSize:(NSSZ)old		{	[super resizeWithOldSuperviewSize:old];	[self updatePerspective];	}
- (void) updatePerspective									{

	CGFloat screenDept = AZMinDim(self.size);
	[CATRANNY immediately:^{
		CATransform3D perspectiveTransform 	= CATransform3DIdentity;
		perspectiveTransform.m34 				= 1.0f / -screenDept;
		self.layer.sublayerTransform 			= perspectiveTransform;

		[self.layer.sublayers do:^(MazeLayer *layer) {
			layer.zPosition 	= screenDept - _controller.setting.cellSize;
			layer.position 	= (NSP){self.width / 2, self.height / 2};
		}];
	}];
}

- (void)viewPointDidChange:			(NSNOT*)n		{
	[self updateViewPoint:[n.userInfo[ViewPointTransformKey]CATransform3DValue]];
}
- (void)appearanceSettingDidChange:	(NSNOT*)n		{
	[self updateAppearanceSetting:(MazeSetting*)n.object];
}
- (void)updateViewPoint:(CATransform3D)transform	{
	[self.layer sublayersBlockSkippingSelf:^(CALayer *layer) {
//		[(MazeLayer *)layer updateTransform:transform]; }];
		((MazeLayer*)layer).mazeTransform = transform;
	}];

}

- (void)updateAppearanceSetting:(MazeSetting*)sett	{
//	CGColorRef bgColor = [setting.wallColor CGColor]; //colorWithAlphaComponent:setting.opaque
//	CGColorRef borderColor = [setting. CGColor];
}

- (void) mouseMoved:		(NSE*)e 	{	id l;

	if ((l = [self.layer hitTest:[self convertPoint:e.locationInWindow fromView:nil] forClass:MazeLayer.class])
		 && l != _hoveredLayer) {
		_hoveredLayer = l;
		[_hoveredLayer blinkLayerWithColor:RANDOMCOLOR];
	}
}
- (void) mouseDown:		(NSE*)e	{	_mouseDownPoint = e.locationInWindow; }
- (void) mouseDragged:	(NSE*)e	{

	NSSize viewSize = self.bounds.size;
	NSPoint currentPoint = [self convertPoint:e.locationInWindow fromView:nil];
	float dx = currentPoint.x - _mouseDownPoint.x;
	float dy = currentPoint.y - _mouseDownPoint.y;
	float rotateX = dx / viewSize.width;
	float rotateY = dy / viewSize.height;

	[CATRANNY immediately:^{ [_controller temporaryRotateViewPoint:M_PI * rotateX :M_PI * rotateY];	}];
	_dragging = YES;
}
- (void) mouseUp:			(NSE*)e	{

	if (_dragging) {
		NSSize viewSize 		= self.bounds.size;
		NSPoint mouseUpPoint	= [self convertPoint:e.locationInWindow fromView:nil];
		float dx 				= mouseUpPoint.x - _mouseDownPoint.x;
		float dy 				= mouseUpPoint.y - _mouseDownPoint.y;
		float rotateX 			= dx / viewSize.width;
		float rotateY	 		= dy / viewSize.height;
		[_controller rotateViewPoint:M_PI * rotateX :M_PI * rotateY];
	} else [_controller moveForwardOrStay];
	_dragging = NO;
}
- (void) keyDown:			(NSE*)e 	{  NSLog(@"INside keydown");

	if (e.modifierFlags & NSNumericPadKeyMask) { 							// arrow keys have this mask
		NSString *theArrow 	= e.charactersIgnoringModifiers;
		unichar keyChar 		= 0;
		if ( theArrow.length == 0 ) 	return;											// reject dead keys
		if ( theArrow.length == 1 )   return keyChar = [theArrow characterAtIndex:0],

		 	keyChar == NSLeftArrowFunctionKey  	? NSLog(@"left arrow" ),  	[self.controller rotateViewPoint:  1: 0] :
			keyChar == NSRightArrowFunctionKey 	? NSLog(@"right arrow"),	[self.controller rotateViewPoint:-1: 0] :
			keyChar == NSDownArrowFunctionKey	? NSLog(@"down arrow"),		[self.controller moveBack] :
			keyChar == NSUpArrowFunctionKey 	   ? NSLog(@"up arrow"),		[self.controller moveForwardOrStay] : nil;
																										//[controller rotateViewPoint:	 0: 1]; return; }
	} else if  ( e.modifierFlags & NSCommandKeyMask) {	/* handle command Key Combos */
		switch ( e.keyCode ) {
				/* quit */		case 12: /* q key */	/* switch to windowed View */	exit(0);	return;
				/* settings */	case 43: /* , key */	/* switch to settingd View */
				[self.controller runForSettingSheet:self];	return;
		}
	}
	[super keyDown:e];
}
- (void) scrollWheel:	(NSE*)e 	{	NSLog(@"user scrolled %f horizontally and %f vertically", e.deltaX, e.deltaY);
		// look up																	// lookright
	e.deltaY < -10 ? [self.controller moveForwardOrStay]	:  e.deltaX < -15 ? [self.controller rotateViewPoint:-1: 0] : nil;
}
- (void) dealloc						{	self.controller = nil;	}
@end


//外観設定変更を反映する
//外観設定変更通知を受ける
// レイヤの視点を更新する
// リサイズメソッドをオーバーライドし、リサイズ後の透視変換の設定をおこなう

// レイヤの透視変換を初期化する
// 視点の更新通知を受ける
// 可能なら一歩進む。可能でないなら視点を戻す。	// 透視変換用のレイヤ
