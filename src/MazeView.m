	//
	//  MazeView.m
	//  True3DMaze
	//
	//  Created by Terazzo on 11/12/14.
	//
#import <QuartzCore/CoreAnimation.h>

#import "MazeView.h"
#import "ViewPoint.h"
#import "MazeSetting.h"
#import "MazeController.h"
#import "MazeLayer.h"
#import "Maze3D.h"

@interface MazeView(Private)
- (void)updatePerspective;
- (void)updateViewPoint:(CATransform3D)transform;
- (void)updateAppearanceSetting:(MazeSetting *)setting;
- (void)mazeDidInitialize:(NSNotification *)notification;
- (void)viewPointDidChange:(NSNotification *)notification;
@end
@implementation MazeView
- (BOOL) acceptsFirstResponder { return YES; }
- (void)mazeDidInitialize:(NSNotification *)notification
{
	[self becomeFirstResponder];
	Maze3D *maze = (Maze3D *)notification.object;

		// 透視変換用のレイヤ
	CALayer *perspectiveLayer 	= CALayer.new;
	perspectiveLayer.frame 		= self.bounds;
	perspectiveLayer.arMASK 	= kCALayerNotSizable;
	perspectiveLayer.bgC 		= cgGREY;
	self.layer						= perspectiveLayer;
	self.wantsLayer				= YES;
		// 壁
	[AZNOTCENTER addObserverForName:@"MazeAppearanceSettingDidChangeNotification" object:_controller.setting queue:AZSOQ  usingBlock:^(NSNotification *note) {
			NSLog(@"did recieve note! %@", note);
		//		:@[@"borderWidth", @"cornerRadius"] task:^(id obj, NSD *change) {
		[CATRANNY immediately:^{
			[self.layer.sublayers each:^(MazeLayer*m) {
				m.borderWidth = _controller.setting.borderWidth;
				m.cornerRadius = _controller.setting.cornerRadius;
				if (!m.special)
				m.backgroundColor = _controller.setting.wallColor.CGColor;
				[m setNeedsDisplay];
			}];
		}];
	}];
	NSA *gPal = RANDOMPAL;
	void (^addLayerIfHavingWall)(MazePosition, WallDirection)= ^(MazePosition p, WallDirection d) {
		if ([maze hasWallAt:p for:d]) { MazeLayer *layer =[MazeLayer layerWithPosition:p for:d];
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

	// リサイズメソッドをオーバーライドし、リサイズ後の透視変換の設定をおこなう
- (void)resizeWithOldSuperviewSize:(NSSize)oldBoundsSize	{
	[super resizeWithOldSuperviewSize:oldBoundsSize];
	[self updatePerspective];
}

	// レイヤの透視変換を初期化する
- (void)updatePerspective	{

	CGFloat screenDept = AZMinDim(self.size);
	[CATRANNY immediately:^{
		CATransform3D perspectiveTransform = CATransform3DIdentity;
		perspectiveTransform.m34 = 1.0f / -screenDept;
		self.layer.sublayerTransform = perspectiveTransform;

		[self.layer.sublayers do:^(MazeLayer *layer) {
			layer.zPosition 	= screenDept - PIECE_SIZE;
			layer.position 	= (NSP){self.width / 2, self.height / 2};
		}];
	}];
}

	// 視点の更新通知を受ける
- (void)viewPointDidChange:(NSNotification *)n	{
	[self updateViewPoint:[n.userInfo[ViewPointTransformKey]CATransform3DValue]];
}
	// レイヤの視点を更新する
- (void)updateViewPoint:(CATransform3D)transform	{
	[self.layer sublayersBlockSkippingSelf:^(CALayer *layer) {
		[(MazeLayer *)layer updateTransform:transform]; }];
}
	//外観設定変更通知を受ける
- (void)appearanceSettingDidChange:(NSNotification *)n	{
//	[self updateAppearanceSetting:(MazeSetting*)n.object];
}

	//外観設定変更を反映する
//- (void)updateAppearanceSetting:(MazeSetting *)setting{
//	CGColorRef bgColor = [setting.wallColor CGColor]; //colorWithAlphaComponent:setting.opaque
//	CGColorRef borderColor = [setting. CGColor];
//}

- (void)mouseDown:(NSEvent *)theEvent
{
	mouseDownPoint = theEvent.locationInWindow;
	id l = [self.layer hitTest:[self convertPoint:theEvent.locationInWindow fromView:nil]];
	if (l) [l blinkLayerWithColor:RANDOMCOLOR];
}

- (void)mouseDragged:(NSEvent*)theEvent
{
	NSSize viewSize = self.bounds.size;
	NSPoint currentPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
	float dx = currentPoint.x - mouseDownPoint.x;
	float dy = currentPoint.y - mouseDownPoint.y;
	float rotateX = dx / viewSize.width;
	float rotateY = dy / viewSize.height;

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

	[self.controller temporaryRotateViewPoint:M_PI * rotateX :M_PI * rotateY];

	[CATransaction commit];

	dragging = YES;
}
- (void)mouseUp:(NSEvent *)theEvent
{
	if (dragging) {
		NSSize viewSize 			= self.bounds.size;
		NSPoint mouseUpPoint	 = [self convertPoint:theEvent.locationInWindow fromView:nil];
		float dx = mouseUpPoint.x - mouseDownPoint.x;
		float dy = mouseUpPoint.y - mouseDownPoint.y;
		float rotateX = dx / viewSize.width;
		float rotateY = dy / viewSize.height;

		[self.controller rotateViewPoint:M_PI * rotateX :M_PI * rotateY];
	} else {
			// 可能なら一歩進む。可能でないなら視点を戻す。
		[self.controller moveForwardOrStay];
	}

	dragging = NO;
}

- (void)keyDown:(NSEvent *)theEvent {  NSLog(@"INside keydown");
	if ([theEvent modifierFlags] & NSNumericPadKeyMask) { 							// arrow keys have this mask
		NSString *theArrow = [theEvent charactersIgnoringModifiers];
		unichar keyChar = 0;
		if ( [theArrow length] == 0 ) 	return;										// reject dead keys
		if ( [theArrow length] == 1 ) {	keyChar = [theArrow characterAtIndex:0];

			if ( keyChar == NSLeftArrowFunctionKey  ) { NSLog(@"left arrow");	[self.controller rotateViewPoint: 1: 0]; return; }
			if ( keyChar == NSRightArrowFunctionKey 	) { NSLog(@"right arrow");	[self.controller rotateViewPoint:-1: 0];	return;	}
			if ( keyChar == NSDownArrowFunctionKey 	) { NSLog(@"down arrow"); 	[self.controller moveBack];  return; }
				//[controller rotateViewPoint:	 0: 1]; return; }
			if ( keyChar == NSUpArrowFunctionKey 	) {	NSLog(@"up arrow");		[self.controller moveForwardOrStay];	    return;	}
		}
	} else if  ( [theEvent modifierFlags] & NSCommandKeyMask) {	/* handle command Key Combos */
		switch ( [theEvent keyCode] ) {
				/* quit */		case 12: /* q key */	/* switch to windowed View */	exit(0);	return;
				/* settings */	case 43: /* , key */	/* switch to settingd View */
				[self.controller runForSettingSheet:self];	return;
		}
	}
	[super keyDown:theEvent];
}
- (void) scrollWheel:(NSEvent *)theEvent {
	NSLog(@"user scrolled %f horizontally and %f vertically", [theEvent deltaX], [theEvent deltaY]);
		// look up																	// lookright
	[theEvent deltaY] < -10 ? [self.controller moveForwardOrStay]	:  [theEvent deltaX] < -15 ? [self.controller rotateViewPoint:-1: 0] : nil;
}


- (void)dealloc
{
	self.controller = nil;
}
@end


