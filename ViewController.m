//
//  ViewController.m
//  seelpApp
//
//  Created by 东哥 on 8/12/2022.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define COUNTLENTH  45*60

@interface ViewController ()

@property (nonatomic , strong)NSWindow  *fullWindow;

@property (nonatomic , strong)NSTextField *promptLabel;

@property (nonatomic , assign)int  count;

@property (nonatomic , assign)int  seelpCount;

/// 状态栏显示倒计时
@property (nonatomic , strong)NSStatusItem   *statusItem;

@property (nonatomic , weak)NSButton            *button;


@end

@implementation ViewController


-(NSWindow *)fullWindow
{
    if (!_fullWindow) {
        
        _fullWindow = [[NSWindow alloc]initWithContentRect:NSScreen.mainScreen.frame styleMask:NSWindowStyleMaskFullScreen backing:NSBackingStoreBuffered defer:YES];
        _fullWindow.opaque = NO;
        _fullWindow.hasShadow = YES;
        [_fullWindow setMovableByWindowBackground:NO];
        _fullWindow.backgroundColor = [NSColor colorWithWhite:1 alpha:0.9];
        _fullWindow.level = NSScreenSaverWindowLevel;
        _fullWindow.titlebarAppearsTransparent=YES;
        _fullWindow.titleVisibility = NSWindowTitleHidden;
        [_fullWindow setStyleMask:[_fullWindow styleMask] | NSWindowStyleMaskNonactivatingPanel | NSWindowStyleMaskBorderless];
        _fullWindow.animationBehavior = CGWindowLevelForKey(NSMainMenuWindowLevel);
        _fullWindow.collectionBehavior = NSWindowCollectionBehaviorFullScreenAuxiliary | NSWindowCollectionBehaviorCanJoinAllSpaces;
        if (@available(macOS 10.14, *)) {
            _fullWindow.appearance  = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
                } else {
                    // Fallback on earlier versions
                }

    }
    return _fullWindow;
}

-(NSTextField *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[NSTextField alloc] init];
        _promptLabel.frame = CGRectMake(NSScreen.mainScreen.frame.size.width/2 - 200, NSScreen.mainScreen.frame.size.height/2 + 42, 400, 112);
        _promptLabel.stringValue = @"您已工作2小时啦\n请眺望远方";
        _promptLabel.editable = NO;//设置是否可以编辑
        _promptLabel.bordered = NO; //不显示边框
        _promptLabel.backgroundColor = [NSColor clearColor]; //控件背景色
        _promptLabel.textColor = [NSColor blackColor];  //文字颜色
        _promptLabel.alignment = NSTextAlignmentCenter; //水平显示方式
        _promptLabel.maximumNumberOfLines = 2; //最多显示行数
        _promptLabel.font = [NSFont systemFontOfSize:34];//设置字号大小
//        [_promptLabel sizeToFit];////自适应大小(改变label的宽度,使其刚刚好可以容纳字符)
    }
    return _promptLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor yellowColor].CGColor;
    
    [self creatUIforFullWindow];
    [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
    }];
    
    NSTimer *tm =  [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:tm forMode:NSRunLoopCommonModes];
//    [self becomeFullWindow];
    

}

- (void)viewDidAppear
{
    [super viewDidAppear];
//    [self becomeFullWindow];
}

-(NSString*)updateDateFormat{
    NSDate * date = [NSDate date];
            
            //设置时间输出格式：
            NSDateFormatter * df = [[NSDateFormatter alloc] init ];
            //[df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
            [df setDateFormat:@"HH:mm"];
    return  [df stringFromDate:date];
    
}

-(void)updateUI{
    
    self.count += 1;
    
    //更新状态栏时间
    if (self.count > 0 && self.count < COUNTLENTH) {
        int i = COUNTLENTH - self.count ;
        [self.statusItem setTitle:[NSString stringWithFormat:@"%02d:%02d",i/60,i%60]];
    }
    
    //中午或下班
    if (([[self updateDateFormat] isEqualToString:@"11:59"] || [[self updateDateFormat] isEqualToString:@"19:00"]) ) {
        self.promptLabel.stringValue = [[self updateDateFormat] hasSuffix:@"59"]?@"请补充能量\n下午再战哦":@"已工作一天\n明天继续加油";
        [self.button setTitle:@"知道了"];
        [self becomeFullWindow];
        return;
    }
    
    //用药时间
    if ([[self updateDateFormat] hasSuffix:@"30"] && [[[[self updateDateFormat] componentsSeparatedByString:@":"] firstObject] intValue] % 2 == 0  ) {
        self.promptLabel.stringValue = @"已持续工作2小时\n请休息缓解疲劳";
        [self.button setTitle:@"知道了"];
        [self becomeFullWindow];
        return;
    }
    
    if (self.count % (COUNTLENTH) == 0) {
        [self becomeFullWindow];
    }
    
    if (self.seelpCount >= 0) {
        self.promptLabel.stringValue = [NSString stringWithFormat:@"%d\n请眺望远方",self.seelpCount];
        if (self.seelpCount == 0) {
            [self closeFullWindow:self.button];
        }
        self.seelpCount -= 1;
    }
    
}


-(void)creatUIforFullWindow
{
    self.count = 1;
    self.seelpCount = -1;
    [self.fullWindow.contentView addSubview:self.promptLabel];
    
    NSButton *button = [[NSButton alloc]initWithFrame:NSMakeRect(NSScreen.mainScreen.frame.size.width/2 - 90/2, NSScreen.mainScreen.frame.size.height/2-80, 150, 50)];
    [button setTitle:@"跳过"];
    [button setTarget:self];
    [button setAction:@selector(closeFullWindow:)];
//    button
//    [NSButton buttonWithTitle:@"跳过" target:self action:];
    [button setBezelStyle:NSBezelStyleRegularSquare];
    [button setButtonType:NSButtonTypeMomentaryPushIn];
    [button setFont:[NSFont systemFontOfSize:30]];
    [button setBezelColor:[NSColor clearColor]];
    [self.fullWindow.contentView addSubview:button];
    self.button = button;
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: -1];

    [self.statusItem setHighlightMode:YES];
    [self.statusItem setToolTip:@"StatusItem"];
    [self.statusItem setImage: [NSImage imageNamed:@"statusIcon"]];
    [self.statusItem sendActionOn:NSEventMaskLeftMouseDown];
    [self.statusItem.button setTarget:self];
    self.statusItem.button.action = @selector(mouseClickHandler);

    
    
}

-(void)mouseClickHandler{
    if (NSApp.currentEvent.type == NSEventTypeLeftMouseDown) {

    }
}

-(void)closeFullWindow:(NSButton*)btn
{
    if ([btn.title isEqualToString:@"知道了"]) {
        [btn setTitle:@"跳过"];
    }else{
        self.count = 0;
    }
    
    if([self.fullWindow isVisible]) [self.fullWindow orderOut:self];

}

-(void)becomeFullWindow
{
    if (self.fullWindow.isVisible) [self closeFullWindow:self.button];
    if ([self.button.title isEqualToString:@"跳过"]) {
        self.seelpCount = 60;
    }

    [self.fullWindow invalidateShadow];
    [self.fullWindow makeKeyAndOrderFront:nil];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


@end
