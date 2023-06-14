//
//  AppDelegate.m
//  seelpApp
//
//  Created by 东哥 on 8/12/2022.
//

#import "AppDelegate.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    

    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
//    NSStoryboard *story = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    NSWindowController *winVC =  [story instantiateControllerWithIdentifier:@"myWindowVC"];
//    [winVC.window orderOut:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return NO;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
