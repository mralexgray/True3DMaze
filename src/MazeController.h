//
//  MazeController.h
//  True3DMaze
//
//  Created by Terazzo on 11/12/13.
//

@class MazeView, ViewPoint, Maze3D, MazeSetting;
@interface 				MazeController : NSObject
@property(weak) IBOutlet 	NSWindow * window;
@property(weak) IBOutlet   MazeView * mazeView;
@property(weak) IBOutlet    NSPanel * settingPanel;
@property(strong)       MazeSetting * setting;
@property(strong)         ViewPoint * viewPoint;
@property(strong)            Maze3D * maze;

- (IBAction)reconstructMaze:	 (id)sender;
- (IBAction)endSettingSheet:   (id)sender;
- (IBAction)runForSettingSheet:(id)sender;

- (void) moveBack;
- (void) moveForwardOrStay;
- (void) rotateViewPoint:			 (CGF)angleX :(CGF)angleY;
- (void) temporaryRotateViewPoint:(CGF)angleX :(CGF)angleY;
@end

//{   IBOutlet 		NSWindow * __weak window;
//    IBOutlet 		MazeView * __weak mazeView;
//    IBOutlet 		 NSPanel	* __weak settingPanel;
//               MazeSetting *        setting;
//                 ViewPoint *        viewPoint;
//                    Maze3D *        maze;			}
