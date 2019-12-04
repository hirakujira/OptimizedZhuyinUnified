#import "Tweak.h"

//============================================================================== 
static inline void setShape(id object, int start, int end, float d, float x, float y, float w, float h) 
{
    for (int i = start; i <= end; ++i) 
    {
        [object[i] setPaddedFrame:CGRectMake(x+d*(i-start),y,w,h)];
        [object[i] setFrame:CGRectMake(x+d*(i-start)-1,y,w,h)];
    }
}
//============================================================================== 
static inline void copySubtree(id object, int num) 
{
    for (int i = 0; i <= num; ++i) 
    {
        [object addObject: [object[i] copy]];
    }
}
//============================================================================== 
static void moveKey(UIKBTree *keyRow, float y, float h) 
{
    float x1, x2;
    CGRect firstFrame = [((UIKBTree *)keyRow.subtrees[0]) frame];
    CGRect firstPaddedFrame= [((UIKBTree *)keyRow.subtrees[0]) paddedFrame];
    float w1 = firstFrame.size.width;
    float w2 = firstPaddedFrame.size.width;

    for (int i = 0; i < keyRow.subtrees.count ; ++i) 
    {
        CGRect keyFrame = [((UIKBTree *)keyRow.subtrees[i]) frame];
        CGRect keyPaddedFrame = [((UIKBTree *)keyRow.subtrees[i]) paddedFrame];
        x1 = keyFrame.origin.x;
        x2 = keyPaddedFrame.origin.x;
        [((UIKBTree *)keyRow.subtrees[i]) setFrame:CGRectMake(x1,y,w1,h)];
        [((UIKBTree *)keyRow.subtrees[i]) setPaddedFrame:CGRectMake(x2,y,w2,h)];
    }
}
//============================================================================== 
%group NSStringHook %hook NSString 
%new 
-(BOOL)containsString:(NSString *)string 
{
    return [self rangeOfString:string].location != NSNotFound ? YES : NO;
}
%end %end

%hook UIKeyboardLayoutStar
-(void)setKeyboardName:(NSString*)name appearance:(UIKeyboardAppearance)appearance 
{
    layout = (ZhuyinLayout)[plistDict[@"layout"] intValue];

    #ifdef __x86_64__
    layout = ZhuyinLayoutComputer;
    #endif
    
    isZhuyin = [name containsString:@"Zhuyin"] && ![name containsString:@"ZhuyinDynamic"] && layout != ZhuyinLayoutNative ? YES : NO;    
    isLandscape = ([name containsString:@"Landscape"] || [name containsString:@"Caymen"]);

    %orig;
}
- (void)showPopupVariantsForKey:(UIKBTree *)arg1 
{
    %orig;
    // for (UIKBTree *tree in arg1.subtrees)
    // {
    //     NSLog(@"%@ %d %@",tree, tree.type, tree.properties);
    //     /* code */
    // }
}
%end

//==============================================================================

%hook UIKBTree
-(NSMutableArray *)subtrees 
{
    NSMutableArray *subtree = %orig;
    // if (([self.name containsString:@"Delete"] || [subtree count] > 5) && [self.name containsString:@"List"])
    // if([subtree count] > 5 && [self.name containsString:@"List"])
        // NSLog(@"NSUInteger: %d BigTree is %@",[subtree count] ,self.name);
     
    if([self.name isEqualToString:@"Zhuyin-Letters-Keyset_Row4"]) 
    {
        if(layout == ZhuyinLayoutComputer && [subtree count] == 10) 
        {
            NSMutableDictionary* properties = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                @"，",     @"KBdisplayString",
                @"，",     @"KBrepresentedString",
                @0,        @"KBdisplayType",
                @2,        @"KBinteractionType", nil];

            UIKBTree* commaKey = [[UIKBTree alloc] initWithType:8 withName:@"OptimizedZhuyin-Comma-Key" withProperties:properties withSubtrees:nil withCache:nil];
            [subtree addObject:commaKey];
        }
    }
    else if([self.name isEqualToString:@"Zhuyin-Letters-Keyset_Row3"]) 
    {
        if([subtree count] == 10 && layout == ZhuyinLayoutCompress) 
        {
            NSMutableDictionary* propertiesComma = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                @"，",     @"KBdisplayString",
                @"，",     @"KBrepresentedString",
                @0,        @"KBdisplayType",
                @2,        @"KBinteractionType", nil];

            UIKBTree* commaKey = [[UIKBTree alloc] initWithType:8 withName:@"OptimizedZhuyin-Comma-Key" withProperties:propertiesComma withSubtrees:nil withCache:nil];
            [subtree addObject:commaKey];

            NSMutableDictionary* propertiesStop = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                @"。",     @"KBdisplayString",
                @"。",     @"KBrepresentedString",
                @0,        @"KBdisplayType",
                @2,        @"KBinteractionType", nil];

            UIKBTree* stopKey = [[UIKBTree alloc] initWithType:8 withName:@"OptimizedZhuyin-Stop-Key" withProperties:propertiesStop withSubtrees:nil withCache:nil];
            [subtree addObject:stopKey];
        }
    }
//直向注音位置表 
//==============================================================================
//iPhone 6 Plus
    if([self.name isEqualToString:@"902195268_414x226_iPhone-PortraitTruffle-Eleven-on-Eleven-Geometry-List"] ||
        [self.name isEqualToString:@"9481733950471963205_414x226_iPhone-PortraitTruffle-Eleven-on-Eleven-Geometry-List"] || //Row1 iOS11
        [self.name isEqualToString:@"32561_414x226_iPhone-PortraitTruffle-Eleven-on-Eleven-Geometry-List"] || //Row1 iOS12
        [self.name isEqualToString:@"44072_414x226_iPhone-PortraitTruffle-Eleven-on-Eleven-Geometry-List"]) //Row1 iOS13
    { 
        setShape(subtree,0,10,37.4,2,6,36,41);
    }
    else if([self.name isEqualToString:@"2483559833_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"] ||
            [self.name isEqualToString:@"11071898421845702287_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row 2 iOS11
            [self.name isEqualToString:@"32562_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS12
            [self.name isEqualToString:@"44073_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"]) //Row2 iOS13
    {
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            setShape(subtree,0,9,37.4,2,51,36,41);
        }
        // return subtree;
    }
    else if([self.name isEqualToString:@"1465172223_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"] ||
            [self.name isEqualToString:@"12042969042044382224_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS11
            [self.name isEqualToString:@"32563_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS12
            [self.name isEqualToString:@"44074_414x226_iPhone-PortraitTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"]) //Row3 iOS13
    {
        if (isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            copySubtree(subtree,1);
            setShape(subtree,0,9,37.4,2,95,36,41);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(376,51,36,41)];
            [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(376,95,36,41)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(375,51,36,41)];
            [(UIKBTree *)subtree[11] setFrame:CGRectMake(375,95,36,41)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            setShape(subtree,0,9,37.4,21,95,35,41);
        }
    }
    else if([self.name isEqualToString:@"1075436866_414x226_iPhone-PortraitTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"] ||
            [self.name isEqualToString:@"4768091962294745147_414x226_iPhone-PortraitTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS11
            [self.name isEqualToString:@"32564_414x226_iPhone-PortraitTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS12
            [self.name isEqualToString:@"44075_414x226_iPhone-PortraitTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row4 iOS13
     {
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];

            setShape(subtree,0,9,37.4,40,139,36,41);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(2,139,36,41)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(2,139,36,41)];
        }
    }
    else if([self.name isEqualToString:@"1380690174_414x226_iPhone-PortraitTruffle-Eleven-Delete-Geometry-List"] ||
            [self.name isEqualToString:@"18108164670186703632_414x226_iPhone-PortraitTruffle-Eleven-Delete-Geometry-List"] || //Delete iOS11
            [self.name isEqualToString:@"32566_414x226_iPhone-PortraitTruffle-Eleven-Delete-Geometry-List"] || //Delete iOS12
            [self.name isEqualToString:@"44077_414x226_iPhone-PortraitTruffle-Eleven-Delete-Geometry-List"]) //Delete iOS13
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(376,139,36,41)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(375,139,36,41)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(376,51,36,41)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(375,51,36,41)];
        }
    }
//==============================================================================
//iPhone 6 
    else if([self.name isEqualToString:@"2638737428_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"] ||
            [self.name isEqualToString:@"17369512942790770385_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS11
            [self.name isEqualToString:@"32540_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS12
            [self.name isEqualToString:@"44051_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"]) //Row2 iOS13
    {
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            setShape(subtree,0,9,34,1,49,32,38);
        }
    }
    else if([self.name isEqualToString:@"2532305676_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"] ||
            [self.name isEqualToString:@"17389980008693904166_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS11
            [self.name isEqualToString:@"32541_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS12
            [self.name isEqualToString:@"44052_375x216_iPhone-PortraitChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"]) //Row3 iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            copySubtree(subtree,1);
            setShape(subtree,0,9,34,1,91,32,38);
            
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(342,49,32,38)];
            [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(342,91,32,38)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(341,49,32,38)];
            [(UIKBTree *)subtree[11] setFrame:CGRectMake(341,91,32,38)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            setShape(subtree,0,9,34,19,91,32,38);
        }
    }
    else if([self.name isEqualToString:@"3531140261_375x216_iPhone-PortraitChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"] ||
            [self.name isEqualToString:@"8993031374934393214_375x216_iPhone-PortraitChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS11
            [self.name isEqualToString:@"32542_375x216_iPhone-PortraitChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS12
            [self.name isEqualToString:@"44053_375x216_iPhone-PortraitChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row4 iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];

            setShape(subtree,0,9,34,36,133,32,38);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(1,133,33,38)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(0,133,33,38)];
        }
    }
    else if ([self.name isEqualToString:@"3892020103_375x216_iPhone-PortraitChoco-Eleven-Delete-Geometry-List"] ||
            [self.name isEqualToString:@"10597753664089504054_375x216_iPhone-PortraitChoco-Eleven-Delete-Geometry-List"] || //Delete iOS11
            [self.name isEqualToString:@"32544_375x216_iPhone-PortraitChoco-Eleven-Delete-Geometry-List"] || //Delete iOS12
            [self.name isEqualToString:@"44055_375x216_iPhone-PortraitChoco-Eleven-Delete-Geometry-List"]) //Delete iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(341,133,33,38)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(340,133,33,38)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(341,49,33,38)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(340,49,33,38)];
        }
    }
//==============================================================================
//iPhone 5

    else if([self.name isEqualToString:@"2657651457_320x216_iPhone-Proportional-Five-Row-Ten-on-Ten-1-Geometry-List"] || //Row2 iOS 6、7
            [self.name isEqualToString:@"3630645507_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS8~10
            [self.name isEqualToString:@"5557568356688324154_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS11
            [self.name isEqualToString:@"32475_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS12
            [self.name isEqualToString:@"43986_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Two-Geometry-List"]) //Row3 iOS13
    { 
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            setShape(subtree,0,9,29,1,47,28,39);
        }
    }
    else if([self.name isEqualToString:@"2936508161_320x216_iPhone-Proportional-Five-Row-Ten-on-Ten-2-Geometry-List"] || //Row 3 iOS 6、7
            [self.name isEqualToString:@"1667699450_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS8~10
            [self.name isEqualToString:@"4517550650555612083_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS11
            [self.name isEqualToString:@"32476_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS12
            [self.name isEqualToString:@"43987_320x216_iPhone-Proportional-Five-Row-Zhuyin-Row-Three-Geometry-List"]) //Row3 iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress)
        {
            copySubtree(subtree,1);
            setShape(subtree,0,9,29,1,89,28,39);
            
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(291,47,28,39)];
            [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(291,89,28,39)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(291,47,28,39)];
            [(UIKBTree *)subtree[11] setFrame:CGRectMake(291,89,28,39)];
        }
        else if (isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            setShape(subtree,0,9,29,15,89,28,39);
        }
    }
    else if([self.name isEqualToString:@"2029842703_320x216_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row 4 iOS 6、7
            [self.name isEqualToString:@"1749525777_320x216_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS8~10
            [self.name isEqualToString:@"1548831744048594415_320x216_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS11
            [self.name isEqualToString:@"32477_320x216_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS12
            [self.name isEqualToString:@"43988_320x216_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row4 iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];

            setShape(subtree,0,9,29,30,131,28,39);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(1,131,28,39)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(1,131,28,39)];
        }
    }

    else if([self.name isEqualToString:@"728623610_320x216_iPhone-Proportional-Eleven-Delete-Geometry-List"] || //Delete iOS 6、7
            [self.name isEqualToString:@"3748539132_320x216_iPhone-Proportional-Eleven-Delete-Geometry-List"] || //Delete iOS8~10
            [self.name isEqualToString:@"18375181497296690375_320x216_iPhone-Proportional-Eleven-Delete-Geometry-List"] || //Delete iOS11
            [self.name isEqualToString:@"32479_320x216_iPhone-Proportional-Eleven-Delete-Geometry-List"] ||//Delete iOS12
            [self.name isEqualToString:@"43990_320x216_iPhone-Proportional-Eleven-Delete-Geometry-List"]) //Delete iOS13
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(291,131,28,39)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(291,131,28,39)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(291,47,28,39)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(291,47,28,39)];
        }
    }

//橫向注音位置表
//==============================================================================
//iPhone XS Max, iPhone XS, iPhone XR, iPhone SE
    else if ([self.name isEqualToString:@"32496_568x162_iPhone-Proportional-Eleven-on-Eleven-Geometry-List"] || //Row1 iOS12
            [self.name isEqualToString:@"44007_568x162_iPhone-Proportional-Eleven-on-Eleven-Geometry-List"]) //Row1 iOS13
    {

    }
    else if ([self.name isEqualToString:@"32497_568x162_iPhone-Proportional-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS12
            [self.name isEqualToString:@"44008_568x162_iPhone-Proportional-Five-Row-Zhuyin-Row-Two-Geometry-List"]) //Row2 iOS13
    {
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            setShape(subtree,0,9,51.6,1,37,50.5,29);
        }
    }
    else if ([self.name isEqualToString:@"32498_568x162_iPhone-Proportional-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS12
            [self.name isEqualToString:@"44009_568x162_iPhone-Proportional-Five-Row-Zhuyin-Row-Three-Geometry-List"]) //Row3 iOS13
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            [subtree addObject: [(UIKBTree *)subtree[1] copy]];

            setShape(subtree,0,9,51.6,1,68,50.5,29);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(517,37,50.5,29)];
            [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(517,68,50.5,29)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(516,37,51.6,29)];
            [(UIKBTree *)subtree[11] setFrame:CGRectMake(516,68,51.6,29)];
        }
        else if (isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            setShape(subtree,0,9,51.6,26,68,50.5,29);
        }
    }
    else if ([self.name isEqualToString:@"32499_568x162_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS12
            [self.name isEqualToString:@"44010_568x162_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row4 iOS13
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            
            setShape(subtree,0,9,51.6,52.6,100,50.5,29);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(1,100,50.5,29)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(0,100,50.5,29)];
        }
    }
    else if ([self.name isEqualToString:@"32501_568x162_iPhone-Proportional-Eleven-Delete-Geometry-List"] || //Delete iOS12
            [self.name isEqualToString:@"44012_568x162_iPhone-Proportional-Eleven-Delete-Geometry-List"]) //Delete iOS13
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(517,100,50.5,29)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(516,100,51.6,29)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(517,37,50.5,29)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(516,37,51.6,29)];
        }
    }
//iPhone 6 Plus
    else if([self.name isEqualToString:@"3282091293_736x162_iPhone-LandscapeTruffle-Eleven-on-Eleven-Geometry-List"] ||
            [self.name isEqualToString:@"17950672344707254440_736x162_iPhone-LandscapeTruffle-Eleven-on-Eleven-Geometry-List"] || //Row1 iOS11
            [self.name isEqualToString:@"32607_736x162_iPhone-LandscapeTruffle-Eleven-on-Eleven-Geometry-List"] || //Row1 iOS12
            [self.name isEqualToString:@"44118_736x162_iPhone-LandscapeTruffle-Eleven-on-Eleven-Geometry-List"]) //Row1 iOS13
    { 
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            if (iOS11)
            {
                setShape(subtree,0,9,53.5,74,5,52.5,29);
            }
        }
    
    }
    else if([self.name isEqualToString:@"1778981362_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"] ||
            [self.name isEqualToString:@"16530536593749521031_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"] ||  //Row2 iOS11
            [self.name isEqualToString:@"32608_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS12
            [self.name isEqualToString:@"44119_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Two-Geometry-List"]) //Row2 iOS13
    {
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            if (iOS11)
            {
                setShape(subtree,0,9,53.5,74,37,52.5,29);
            }
            else
            {
                setShape(subtree,0,9,48,104,37,47,29);
            }
        }
    }
    else if([self.name isEqualToString:@"2814370067_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"] ||
            [self.name isEqualToString:@"948057038593399820_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS11
            [self.name isEqualToString:@"32609_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS12
            [self.name isEqualToString:@"44120_736x162_iPhone-LandscapeTruffle-Five-Row-Zhuyin-Row-Three-Geometry-List"]) //Row3 iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            [subtree addObject: [(UIKBTree *)subtree[1] copy]];
            if (iOS11)
            {
                setShape(subtree,0,9,53.5,74,68,52.5,29);
                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(610,37,52.5,29)];
                [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(610,68,52.5,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(610,37,52.5,29)];
                [(UIKBTree *)subtree[11] setFrame:CGRectMake(610,68,52.5,29)];
            }
            else
            {
                setShape(subtree,0,9,48,104,68,47,29);

                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(585,37,47,29)];
                [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(585,68,47,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(584,37,47,29)];
                [(UIKBTree *)subtree[11] setFrame:CGRectMake(584,68,47,29)];
            }
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            if (iOS11)
            {
                setShape(subtree,0,9,53.5,101,68,52.5,29);
            }
        }

    }
    else if([self.name isEqualToString:@"310431278_736x162_iPhone-LandscapeTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"] ||
            [self.name isEqualToString:@"8070595148251783465_736x162_iPhone-LandscapeTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS11
            [self.name isEqualToString:@"32610_736x162_iPhone-LandscapeTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS12
            [self.name isEqualToString:@"44121_736x162_iPhone-LandscapeTruffle-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row4 iOS13
     { 
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];

            if (iOS11)
            {
                setShape(subtree,0,9,53.5,128,100,52.5,29);
                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(74,100,52.5,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(74,100,52.5,29)];
            }
            else
            {
                setShape(subtree,0,9,48,151,100,47,29);
                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(104,100,46,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(104,100,46,29)];
            }
        }
    }
    else if([self.name isEqualToString:@"3810702877_736x162_iPhone-LandscapeTruffle-Eleven-Delete-Geometry-List"] ||
            [self.name isEqualToString:@"15572770678521019785_736x162_iPhone-LandscapeTruffle-Eleven-Delete-Geometry-List"] || //Delete iOS11
            [self.name isEqualToString:@"32612_736x162_iPhone-LandscapeTruffle-Eleven-Delete-Geometry-List"] || //Delete iOS12
            [self.name isEqualToString:@"44123_736x162_iPhone-LandscapeTruffle-Eleven-Delete-Geometry-List"]) //Delete iOS13
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            if (iOS11)
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(610,100,52.5,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(610,100,52.5,29)];
            }
            else
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(585,100,47,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(584,100,47,29)];
            }
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            if (iOS11)
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(610,37,52.5,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(610,37,52.5,29)];
            }
            else
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(585,37,47,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(584,37,47,29)];
            }
        }
    }
//iPhone 6
    else if([self.name isEqualToString:@"151987975_667x162_iPhone-LandscapeChoco-Eleven-on-Eleven-Geometry-List"] ||
            [self.name isEqualToString:@"15669924788214932666_667x162_iPhone-LandscapeChoco-Eleven-on-Eleven-Geometry-List"] || //Row1 iOS11
            [self.name isEqualToString:@"32583_667x162_iPhone-LandscapeChoco-Eleven-on-Eleven-Geometry-List"] || //Row1 iOS12
            [self.name isEqualToString:@"44094_667x162_iPhone-LandscapeChoco-Eleven-on-Eleven-Geometry-List"]) //Row1 iOS13
    { 
    }
    else if([self.name isEqualToString:@"1916434208_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"] ||
            [self.name isEqualToString:@"8014139193398579750_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS11
            [self.name isEqualToString:@"32584_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"] || //Row2 iOS12
            [self.name isEqualToString:@"44095_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Two-Geometry-List"]) //Row2 iOS13
    {
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            setShape(subtree,0,9,48,70,37,47,29);
        }
    }
    else if([self.name isEqualToString:@"1615233310_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"] ||
            [self.name isEqualToString:@"2254400432844477614_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS11
            [self.name isEqualToString:@"32585_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"] || //Row3 iOS12
            [self.name isEqualToString:@"44096_667x162_iPhone-LandscapeChoco-Five-Row-Zhuyin-Row-Three-Geometry-List"]) //Row3 iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            [subtree addObject: [(UIKBTree *)subtree[1] copy]];

            setShape(subtree,0,9,48,70,68,47,29);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(550,37,46,29)];
            [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(550,68,46,29)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(549,37,47,29)];
            [(UIKBTree *)subtree[11] setFrame:CGRectMake(549,68,47,29)];
        }
        else if (isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            setShape(subtree,0,9,48,89,68,47,29);
        }
    }
    else if([self.name isEqualToString:@"3913116670_667x162_iPhone-LandscapeChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"] ||
            [self.name isEqualToString:@"364348373525446959_667x162_iPhone-LandscapeChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS11
            [self.name isEqualToString:@"32586_667x162_iPhone-LandscapeChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"] || //Row4 iOS12
            [self.name isEqualToString:@"44097_667x162_iPhone-LandscapeChoco-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row4 iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            
            setShape(subtree,0,9,48,118,100,47,29);
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(70,100,47,29)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(69,100,47,29)];
        }
    }
    else if ([self.name isEqualToString:@"2264922919_667x162_iPhone-LandscapeChoco-Eleven-Delete-Geometry-List"] ||
            [self.name isEqualToString:@"1549084266065605525_667x162_iPhone-LandscapeChoco-Eleven-Delete-Geometry-List"] || //Delete iOS11
            [self.name isEqualToString:@"32588_667x162_iPhone-LandscapeChoco-Eleven-Delete-Geometry-List"] || //Delete iOS12
            [self.name isEqualToString:@"44099_667x162_iPhone-LandscapeChoco-Eleven-Delete-Geometry-List"]) //Delete iOS13
    { 
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(550,100,47,29)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(549,100,47,29)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(550,37,47,29)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(549,37,47,29)];
        }
    }
    
//iPhone 4
    else if([self.name isEqualToString:@"1892494589_480x162_iPhone-Proportional-Five-Row-Ten-on-Ten-1-Geometry-List"]) //Row2 
    {
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer)) 
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(1,37,42,29)];
            [(UIKBTree *)subtree[1] setPaddedFrame:CGRectMake(44,37,43,29)];
            [(UIKBTree *)subtree[2] setPaddedFrame:CGRectMake(88,37,42,29)];
            [(UIKBTree *)subtree[3] setPaddedFrame:CGRectMake(131,37,43,29)];
            [(UIKBTree *)subtree[4] setPaddedFrame:CGRectMake(175,37,43,29)];
            [(UIKBTree *)subtree[5] setPaddedFrame:CGRectMake(219,37,42,29)];
            [(UIKBTree *)subtree[6] setPaddedFrame:CGRectMake(262,37,43,29)];
            [(UIKBTree *)subtree[7] setPaddedFrame:CGRectMake(306,37,43,29)];
            [(UIKBTree *)subtree[8] setPaddedFrame:CGRectMake(350,37,42,29)];
            [(UIKBTree *)subtree[9] setPaddedFrame:CGRectMake(393,37,43,29)];

            [(UIKBTree *)subtree[0] setFrame:CGRectMake(1,37,42,29)];
            [(UIKBTree *)subtree[1] setFrame:CGRectMake(44,37,43,29)];
            [(UIKBTree *)subtree[2] setFrame:CGRectMake(88,37,42,29)];
            [(UIKBTree *)subtree[3] setFrame:CGRectMake(131,37,43,29)];
            [(UIKBTree *)subtree[4] setFrame:CGRectMake(175,37,43,29)];
            [(UIKBTree *)subtree[5] setFrame:CGRectMake(219,37,42,29)];
            [(UIKBTree *)subtree[6] setFrame:CGRectMake(262,37,43,29)];
            [(UIKBTree *)subtree[7] setFrame:CGRectMake(306,37,43,29)];
            [(UIKBTree *)subtree[8] setFrame:CGRectMake(350,37,42,29)];
            [(UIKBTree *)subtree[9] setFrame:CGRectMake(393,37,43,29)];
        }
    }
    else if([self.name isEqualToString:@"1209170427_480x162_iPhone-Proportional-Five-Row-Ten-on-Ten-2-Geometry-List"]) //Row 3
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress)
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(1,68,42,29)];
            [(UIKBTree *)subtree[1] setPaddedFrame:CGRectMake(44,68,43,29)];
            [(UIKBTree *)subtree[2] setPaddedFrame:CGRectMake(88,68,42,29)];
            [(UIKBTree *)subtree[3] setPaddedFrame:CGRectMake(131,68,43,29)];
            [(UIKBTree *)subtree[4] setPaddedFrame:CGRectMake(175,68,43,29)];
            [(UIKBTree *)subtree[5] setPaddedFrame:CGRectMake(219,68,42,29)];
            [(UIKBTree *)subtree[6] setPaddedFrame:CGRectMake(262,68,43,29)];
            [(UIKBTree *)subtree[7] setPaddedFrame:CGRectMake(306,68,43,29)];
            [(UIKBTree *)subtree[8] setPaddedFrame:CGRectMake(350,68,42,29)];
            [(UIKBTree *)subtree[9] setPaddedFrame:CGRectMake(393,68,43,29)];

            [(UIKBTree *)subtree[0] setFrame:CGRectMake(1,68,42,29)];
            [(UIKBTree *)subtree[1] setFrame:CGRectMake(44,68,43,29)];
            [(UIKBTree *)subtree[2] setFrame:CGRectMake(88,68,42,29)];
            [(UIKBTree *)subtree[3] setFrame:CGRectMake(131,68,43,29)];
            [(UIKBTree *)subtree[4] setFrame:CGRectMake(175,68,43,29)];
            [(UIKBTree *)subtree[5] setFrame:CGRectMake(219,68,42,29)];
            [(UIKBTree *)subtree[6] setFrame:CGRectMake(262,68,43,29)];
            [(UIKBTree *)subtree[7] setFrame:CGRectMake(306,68,43,29)];
            [(UIKBTree *)subtree[8] setFrame:CGRectMake(350,68,42,29)];
            [(UIKBTree *)subtree[9] setFrame:CGRectMake(393,68,43,29)];

            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            [subtree addObject: [(UIKBTree *)subtree[1] copy]];
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(437,37,42,29)];
            [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(437,68,42,29)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(437,37,42,29)];
            [(UIKBTree *)subtree[11] setFrame:CGRectMake(437,68,42,29)];
        }
    }
    else if([self.name isEqualToString:@"1009229979_480x162_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row 4
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];

            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(44,100,43,29)];
            [(UIKBTree *)subtree[1] setPaddedFrame:CGRectMake(88,100,42,29)];
            [(UIKBTree *)subtree[2] setPaddedFrame:CGRectMake(131,100,43,29)];
            [(UIKBTree *)subtree[3] setPaddedFrame:CGRectMake(175,100,43,29)];
            [(UIKBTree *)subtree[4] setPaddedFrame:CGRectMake(219,100,42,29)];
            [(UIKBTree *)subtree[5] setPaddedFrame:CGRectMake(262,100,43,29)];
            [(UIKBTree *)subtree[6] setPaddedFrame:CGRectMake(306,100,43,29)];
            [(UIKBTree *)subtree[7] setPaddedFrame:CGRectMake(350,100,42,29)];
            [(UIKBTree *)subtree[8] setPaddedFrame:CGRectMake(393,100,43,29)];
            [(UIKBTree *)subtree[9] setPaddedFrame:CGRectMake(437,100,43,29)];
            [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(1,100,42,29)];

            [(UIKBTree *)subtree[0] setFrame:CGRectMake(44,100,43,29)];
            [(UIKBTree *)subtree[1] setFrame:CGRectMake(88,100,42,29)];
            [(UIKBTree *)subtree[2] setFrame:CGRectMake(131,100,43,29)];
            [(UIKBTree *)subtree[3] setFrame:CGRectMake(175,100,43,29)];
            [(UIKBTree *)subtree[4] setFrame:CGRectMake(219,100,42,29)];
            [(UIKBTree *)subtree[5] setFrame:CGRectMake(262,100,43,29)];
            [(UIKBTree *)subtree[6] setFrame:CGRectMake(306,100,43,29)];
            [(UIKBTree *)subtree[7] setFrame:CGRectMake(350,100,42,29)];
            [(UIKBTree *)subtree[8] setFrame:CGRectMake(393,100,43,29)];
            [(UIKBTree *)subtree[9] setFrame:CGRectMake(437,100,43,29)];
            [(UIKBTree *)subtree[10] setFrame:CGRectMake(1,100,42,29)];
            //NSLog(@"sub tree %@",subtree[10]);
        }
    }
    else if([self.name isEqualToString:@"1080426452_480x162_iPhone-Proportional-Eleven-Delete-Geometry-List"])
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress)
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(437,100,42,29)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(437,100,42,29)];
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(437,37,42,29)];
            [(UIKBTree *)subtree[0] setFrame:CGRectMake(437,37,42,29)];
        }
    }
//==============================================================================
//iPhone 5
    else if([self.name isEqualToString:@"5025152533619999113_568x162_iPhone-Proportional-Eleven-on-Eleven-Geometry-List"]) //Row1 iOS11
    {
    }
    else if([self.name isEqualToString:@"669203205_568x162_iPhone-Proportional-Five-Row-Ten-on-Ten-1-Geometry-List"] ||
            [self.name isEqualToString:@"4803681197627595025_568x162_iPhone-Proportional-Five-Row-Zhuyin-Row-Two-Geometry-List"]) //Row2 iOS11
    {
        if(isZhuyin == YES && (layout == ZhuyinLayoutCompress || layout == ZhuyinLayoutComputer))
        {
            if (iOS11)
            {
                setShape(subtree,0,9,51.5,1,37,50.5,29);
            }
            else
            {
                setShape(subtree,0,9,48,21,37,47,29);
            }
        }
    }
    else if([self.name isEqualToString:@"3243476474_568x162_iPhone-Proportional-Five-Row-Ten-on-Ten-2-Geometry-List"] ||
            [self.name isEqualToString:@"4438399755679006270_568x162_iPhone-Proportional-Five-Row-Zhuyin-Row-Three-Geometry-List"]) //Row3 iOS11
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress)
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            [subtree addObject: [(UIKBTree *)subtree[1] copy]];

            if (iOS11)
            {
                setShape(subtree,0,9,51.5,1,68,50.5,29);

                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(516,37,50.5,29)];
                [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(516,68,50.5,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(516,37,50.5,29)];
                [(UIKBTree *)subtree[11] setFrame:CGRectMake(516,68,50.5,29)];
            }
            else
            {
                setShape(subtree,0,9,48,21,68,47,29);
                
                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(500,37,47,29)];
                [(UIKBTree *)subtree[11] setPaddedFrame:CGRectMake(500,68,47,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(500,37,47,29)];
                [(UIKBTree *)subtree[11] setFrame:CGRectMake(500,68,47,29)];
            }
        }
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            if (iOS11)
            {
                setShape(subtree,0,9,51.5,27,68,50.5,29);
            }
        }
    }
    else if([self.name isEqualToString:@"1730179876_568x162_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"] ||
            [self.name isEqualToString:@"1916203488763040914_568x162_iPhone-Proportional-Left-Aligned-Ten-on-Eleven-Geometry-List"]) //Row4 iOS11
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutComputer)
        {
            [subtree addObject: [(UIKBTree *)subtree[0] copy]];
            if (iOS11)
            {
                setShape(subtree,0,9,51.5,52,100,50.5,29);
                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(1,100,50.5,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(1,100,50.5,29)];
            }
            else
            {
                setShape(subtree,0,9,48,68,100,47,29);
                [(UIKBTree *)subtree[10] setPaddedFrame:CGRectMake(21,100,46,29)];
                [(UIKBTree *)subtree[10] setFrame:CGRectMake(21,100,46,29)];
            }
        }
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) {
            if (iOS11)
            {
                setShape(subtree,0,9,51.5,1,100,50.5,29);
            }
        }
    }
    else if([self.name isEqualToString:@"3237044538_568x162_iPhone-Proportional-Eleven-Delete-Geometry-List"] ||
            [self.name isEqualToString:@"7457953364702574698_568x162_iPhone-Proportional-Eleven-Delete-Geometry-List"]) //Delete iOS11
    {
        if(isZhuyin == YES && layout == ZhuyinLayoutCompress) {
            if (iOS11)
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(516,100,50.5,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(516,100,50.5,29)];
            }
            else
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(500,100,47,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(500,100,47,29)];
            }
        }
        else if(isZhuyin == YES && layout == ZhuyinLayoutComputer) {
            if (iOS11)
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(516,37,50.5,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(516,37,50.5,29)];
            }
            else
            {
                [(UIKBTree *)subtree[0] setPaddedFrame:CGRectMake(500,37,47,29)];
                [(UIKBTree *)subtree[0] setFrame:CGRectMake(500,37,47,29)];
            }                
        }
    }
    return subtree;
}

 //讀取鍵盤內容用，需要時再打開
// -(NSMutableDictionary *)properties
// {
//     NSMutableDictionary* myproperties = %orig;
//     if([self.name isEqualToString:@"Chinese-Traditional-Ideographic-Full-Stop"])
//     // if ([[self displayString] isEqualToString:@"。"])
//         NSLog (@"properties is :%@",myproperties);

//     // Chinese-Traditional-Ideographic-Full-Stop/Key: 7 properties + 0 subtrees",
//  //               "<UIKBTree: 0x131d2f7b0> - Chinese-Traditional-Fullwidth-Comma/Key: 8 properties + 0 subtrees",
//  //               "<UIKBTree: 0x131d2d2c0> - Chinese-Traditional-Ideographic-Comma/Key: 7 properties + 0 subtrees",
//     return myproperties;
// }

%end


%group GSpringBoard %hook SpringBoard 

- (void)applicationDidFinishLaunching:(id)application
{
    %orig;

    // Clear the keyboard cache to prevent old images from interfering
    // NOTE: This should only be necessary upon first install, though it is
    //       conceivable that cached files from Safe Mode could later cause
    //       issues.
    Class $UIKeyboardCache = objc_getClass("UIKeyboardCache");
    if ($UIKeyboardCache != nil) {
        UIKeyboardCache *cache = [%c(UIKeyboardCache) sharedInstance];
        CPBitmapStore *_store = MSHookIvar<id>(cache, "_store");
        // FIXME: Consider using purge method for older firmware as well.
        if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0) 
        {
            [_store removeImagesInGroups:[_store allGroups]];
        } 
        else 
        {
            [_store purge];
        }
    }

    NSFileManager *fileManager = [[NSFileManager alloc] init];
     if(![fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.plist"]) { 
         NSMutableDictionary* zhuyinSettings = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@1, @"layout",nil];
         [zhuyinSettings writeToFile:@"/var/mobile/Library/Preferences/tw.hiraku.optimizedzhuyin.plist" atomically:YES];
     }
}

%end %end
//==============================================================================
%group GKeyboardCache %hook UIKeyboardCache

- (void)displayView:(id)view withKey:(id)key fromLayout:(id)layout {
    [[view layer] _display];
}

%end %end
//==============================================================================
%ctor {
    %init;

    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier isEqualToString:@"com.apple.springboard"]) {
        %init(GSpringBoard);
    }

    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0) {
        %init(NSStringHook);
    }

    if (objc_getClass("UIKeyboardCache") != nil)
        // Include additional hooks for iOS 4.2.1+
        %init(GKeyboardCache);
}
