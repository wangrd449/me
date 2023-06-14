//
//  WindowController.m
//  seelpApp
//
//  Created by 东哥 on 15/2/2023.
//

#import "WindowController.h"

@interface WindowController ()<NSWindowDelegate>

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.delegate = self;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
   
    [self.window setFrame:NSRectFromCGRect(CGRectMake(0, 0, 0, 0)) display:YES];
//    [self.window makeKeyAndOrderFront:nil];
}

- (BOOL)windowShouldClose:(id)sender {
    
    exit(0);
    
    return YES;
    
}

@end
