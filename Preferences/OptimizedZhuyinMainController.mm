#import "OptimizedZhuyinMainController.h"

static int respring;

void addRespringButtonCallBack() 
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddRespringButton" object:nil];
}

@implementation OptimizedZhuyinMainController
- (instancetype)init 
{
    self = [super init];
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), &respring, CFSTR("tw.hiraku.optimizedzhuyin/updated"), NULL);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddRespringButton" object:nil];

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), &respring, (CFNotificationCallback)addRespringButtonCallBack, CFSTR("tw.hiraku.optimizedzhuyin/updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRespringButton:) name:@"AddRespringButton" object:nil];
    
    return self;
}

- (id)specifiers 
{
	if(_specifiers == nil) 
    {
		_specifiers = [self loadSpecifiersFromPlistName:@"OptimizedZhuyin" target:self];
	}
	return _specifiers;
}

- (void)openFacebook
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/hiraku.tw"]];
}

- (void)openBlog
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://hiraku.tw/2012/02/2855/"]];
}

- (void)openForum
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://iphone4.tw/forums/showthread.php?t=167707"]];
}

- (NSString *)version 
{
	return @"認同皮樂即可免費使用";
}

- (id)readPreferenceValue:(PSSpecifier *)specifier 
{
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier 
{
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (CFStringRef)CFBridgingRetain(specifier.properties[@"PostNotification"]);
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

- (void)addRespringButton:(NSNotification *)notification 
{
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"提醒"
                               message:@"要儲存設定，必須重新啟動主畫面，您要現在重新啟動主畫面嗎？"
                              delegate:self
                     cancelButtonTitle:@"稍後"
                     otherButtonTitles:@"好", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    switch (buttonIndex) 
    {
        case 1:
            [self showLoadingView];
            [self performSelector:@selector(respring) withObject:self afterDelay:2.0];
            break;
    }
}

- (void)respring 
{
	system("rm -Rf /User/Library/Caches/com.apple.keyboards/");
    system("/usr/bin/killall lsd SpringBoard");
    system("/usr/bin/killall backboardd");
}

- (void)showLoadingView 
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        
    UIView* loading = [[UIView alloc] initWithFrame:CGRectMake(window.frame.size.width/2-50, window.frame.size.height/2-50, 100, 100)];
    [loading setBackgroundColor:[UIColor blackColor]];
    [loading setAlpha:0.7];
    loading.layer.cornerRadius = 15;
        
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [spinner startAnimating];
    
    [loading addSubview:spinner];
    loading.userInteractionEnabled = NO;
    [window addSubview:loading];
}
@end