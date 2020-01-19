#import <Preferences/Preferences.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static int respring;

void addRespringButtonCallBack () 
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddRespringButton" object:nil];
}

@interface OptimizedZhuyinMainController: PSListController
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if ([alertView.message isEqualToString:@"要儲存設定，必須重新啟動主畫面，您要現在重新啟動主畫面嗎？"] && buttonIndex == 1)
    {
        [self showLoadingView];
        [self performSelector:@selector(respring) withObject:self afterDelay:2.0];
    }
    else if ([alertView.message isEqualToString:@"此動作將會重置您的鍵盤字典，使得字詞學習功能回到原廠狀態 \n (但不影響使用者字典功能)"] && buttonIndex == 1)
    {
        system("rm -Rf /User/Library/Keyboard/completion-learning-zh-Hant.dictionary/");
        system("rm -Rf /User/Library/Keyboard/PhraseLearning_zh_Hant_zhuyin.dictionary/");

        UIAlertView *alert = 
        [[UIAlertView alloc] initWithTitle:@"提醒" 
                                   message:@"已經修復鍵盤字典" 
                                  delegate:self 
                         cancelButtonTitle:@"確定"
                         otherButtonTitles:nil];
        [alert show];
    }
}

- (void)facebookURL:(id)param
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/hiraku.tw/"]];
}

- (void)blogURL:(id)param
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://hiraku.tw/"]];
}

- (void)forumURL:(id)param
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://iphone4.tw/forums/showthread.php?t=167707"]];
}

- (NSString *)version
{
    return @"認同皮樂即可免費使用";
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

- (void)cleanDictionary
{
	UIAlertView *alert = 
    [[UIAlertView alloc] initWithTitle:@"提醒" 
                               message:@"此動作將會重置您的鍵盤字典，使得字詞學習功能回到原廠狀態 \n (但不影響使用者字典功能)" 
                              delegate:self 
                     cancelButtonTitle:@"取消" 
                     otherButtonTitles:@"確定", nil];
    [alert show];
}

- (void)respring 
{
    system("rm -Rf /User/Library/Caches/com.apple.keyboards/");
    system("/usr/bin/killall lsd SpringBoard");
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