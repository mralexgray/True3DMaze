//
//  MazeController.m
//  True3DMaze
//
//  Created by Terazzo on 11/12/13.
//
#import <QuartzCore/CoreAnimation.h>

#import "MazeController.h"
#import "ViewPoint.h"
#import "MazeView.h"
#import "MazeLayer.h"
#import "ViewPoint.h"
#import "Maze3D.h"
#import "MazeSetting.h"

@interface MazeController(Private)
- (void) coodinateObjects;
- (void) constructMaze;
- (void) notifyViewPointChanged:(CATransform3D)transform;
@end


@implementation MazeController

- (id)init				{ return self = [super init] ? _viewPoint = ViewPoint.new, _maze = Maze3D.new, _setting = MazeSetting.new, self : nil;	}
- (void)awakeFromNib	{    [self coodinateObjects];    [_window makeKeyAndOrderFront:self];	}
- (void)coodinateObjects						{
    // wires models/views
    [AZNOTCENTER addObserver:_mazeView selector:@selector(mazeDidInitialize:)
             name:Maze3DDidInitializeNotification object:_maze];
    [AZNOTCENTER addObserver:_viewPoint selector:@selector(mazeDidInitialize:)
            name:Maze3DDidInitializeNotification object:_maze];
    [AZNOTCENTER addObserver:_mazeView selector:@selector(viewPointDidChange:)
             name:ViewPointDidChangeNotification object:_viewPoint];
    // initialize
    [self constructMaze];
}
- (IBAction)reconstructMaze:(id)sender		{    [self constructMaze];	}
- (void)constructMaze							{
   [_maze constructMaze:_setting.mazeSizeX :_setting.mazeSizeY :_setting.mazeSizeZ controller:self];
	[NSNotificationCenter postNotificationName:MazeAppearanceChanged object:_setting userInfo:nil];
}

-  (IBA) runForSettingSheet:(id)sender		{
	[AZSHAREDAPP beginSheet:_settingPanel modalForWindow:_window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}
-  (IBA) endSettingSheet:	 (id)sender		{
    [AZSHAREDAPP endSheet:_settingPanel returnCode:NSAlertDefaultReturn];
}
- (void) sheetDidEnd:(NSWindow*)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo	{
    [_settingPanel orderOut:self];
}
- (void) moveBack																		{										// Advance if possible
																//		DockPosition position = [viewPoint getForwardDPosition];
																//	if ([dock hasWallAt:position for:DDIR_NONE] || setting.throughWalls == NSOnState) {
	[_viewPoint moveDBack];
	[self notifyViewPointChanged:_viewPoint.transform];
}
- (void) moveForwardOrStay															{
    MazePosition position = _viewPoint.forwardPosition;
    if ([_maze hasWallAt:position for:DIR_NONE] || _setting.throughWalls == NSOnState) {
        [_viewPoint moveForward];
    }
    [self notifyViewPointChanged:_viewPoint.transform];

    if ([_maze isAtGoal:_viewPoint.position]) {
        NSRunAlertPanel(@"Clear", @"Congrats!!", @"More", nil, nil);
        [self constructMaze];
    }
}
- (void) rotateViewPoint:			 (CGFloat)angleX :(CGFloat)angleY	{
    // 90度単位で丸める
    if (_setting.freeRotation != NSOnState) {
        angleX = M_PI * floor(angleX * 2 / M_PI + 0.5f) / 2;
        angleY = M_PI * floor(angleY * 2 / M_PI + 0.5f) / 2;
    }
    CATransform3D transform = _viewPoint.transform;
    transform = CATransform3DConcat(transform, 
                                    CATransform3DMakeRotation(angleX, 0.0f, -1.0f, 0.0f));
    transform = CATransform3DConcat(transform, 
                                    CATransform3DMakeRotation(angleY, 1.0f, 0.0f, 0.0f));
    
    _viewPoint.transform = transform;
    [self notifyViewPointChanged:transform];
}
- (void) temporaryRotateViewPoint:(CGFloat)angleX :(CGFloat)angleY	{
    CATransform3D transform = _viewPoint.transform;
    transform = CATransform3DConcat(transform, 
                        CATransform3DMakeRotation(angleX, 0.0f, -1.0f, 0.0f));
    transform = CATransform3DConcat(transform, 
                        CATransform3DMakeRotation(angleY, 1.0f, 0.0f, 0.0f));
    [self notifyViewPointChanged:transform];
}
- (void) notifyViewPointChanged:  (CATransform3D)transform				{
    
    [AZNOTCENTER postNotificationName:ViewPointDidChangeNotification object:_viewPoint userInfo:@{ViewPointTransformKey:AZV3d(transform)}];
}
@end

// [addObserver:mazeView selector:@selector(appearanceSettingDidChange:) name:MazeAppearanceSettingDidChangeNotification object:setting];
//- (void)windowWillClose:(NSNotification *)notification	{  [self autorelease];	}
// 迷路を再作成
// 設定シートを表示
// 設定シートを隠す
// 可能なら前進
