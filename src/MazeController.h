//
//  MazeController.h
//  True3DMaze
//
//  Created by Terazzo on 11/12/13.
//


@class  MazeView, MazeSetting, Maze3D, ViewPoint;
@interface 				MazeController : NSObject
@property(weak) IBOutlet 	NSWindow * window;
@property(weak) IBOutlet   MazeView * mazeView;
@property(weak) IBOutlet    NSPanel * settingPanel;
@property(strong)       MazeSetting * setting;
@property(strong)         ViewPoint * viewPoint;
@property(strong)            Maze3D * maze;

- (IBAction)reconstructMaze:	 (id)sender;
- (IBAction)runForSettingSheet:(id)sender;
- (IBAction)endSettingSheet:   (id)sender;

- (void)moveBack;
- (void)moveForwardOrStay;
- (void)rotateViewPoint:			(CGFloat)angleX :(CGFloat)angleY;
- (void)temporaryRotateViewPoint:(CGFloat)angleX :(CGFloat)angleY;
@end

//{   IBOutlet 		NSWindow * __weak window;
//    IBOutlet 		MazeView * __weak mazeView;
//    IBOutlet 		 NSPanel	* __weak settingPanel;
//               MazeSetting *        setting;
//                 ViewPoint *        viewPoint;
//                    Maze3D *        maze;			}
