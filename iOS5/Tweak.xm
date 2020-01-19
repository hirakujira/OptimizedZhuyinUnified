#import <objc/runtime.h>
#import "Tweak.h"

//============================================================================== 
static inline void setShapeX(NSArray *subtrees, int start, int end, float d, float x, float y, float w, float h) 
{
    for (int i = start; i <= end; ++i) 
    {
        [[subtrees objectAtIndex:i] setPaddedFrame:CGRectMake(x+d*(i-start),y,w,h)];
        [[subtrees objectAtIndex:i] setFrame:CGRectMake(x+d*(i-start)-1,y,w,h)];
    }
}

static inline void setShapeY(NSArray *subtrees, int start, int end, float d, float x, float y, float w, float h) 
{
    for (int i = start; i <= end; ++i) 
    {
        [[subtrees objectAtIndex:i] setPaddedFrame:CGRectMake(x,y+d*(i-start),w,h)];
        [[subtrees objectAtIndex:i] setFrame:CGRectMake(x,y+d*(i-start)-1,w,h)];
    }
}
//============================================================================== 
static inline void copySubtree(id object, int num)
{
	for (int i = 0; i <= num; ++i)
	{
		[object addObject: [[object objectAtIndex:i] copy]];
	}
}

//==============================================================================
%hook NSString 
%new 
- (BOOL)containsString:(NSString *)string 
{
	return [self rangeOfString:string].location != NSNotFound ? YES : NO;
}
%end
//==============================================================================

%hook UIKeyboardLayoutStar
- (void)setKeyboardName:(NSString*)name appearance:(UIKeyboardAppearance)appearance
{
	layout = (ZhuyinLayout)[[plistDict objectForKey:@"layout"] intValue];
	isZhuyin = [name containsString:@"Zhuyin"] && ![name containsString:@"ZhuyinDynamic"] && layout != ZhuyinLayoutNative ? YES : NO;
	%orig;
}
%end


//==============================================================================
%hook UIKBShape
%new
- (void)setKeyFrame:(CGRect)frame
{
	[self setPaddedFrame:frame];
	[self setFrame:frame];
}
%end

%hook UIKBTree 
%new
- (void)setKeyString:(NSString *)string
{
	[self setRepresentedString:string];
	[self setDisplayString:string];
}

- (NSString *)displayString
{
	NSString *result = %orig;
	
	if ([self.name isEqualToString:@"Shift-Key"])
	{
		isZhuyin == YES && shiftMod == YES ? [self setVisible:NO] : [self setVisible:YES]; //ShiftMod = NO -> 注音鍵盤的符號與數字模式
	}
	
	if (layout == ZhuyinLayoutEten && [[plistDict objectForKey:@"EtenEng"] boolValue] == YES)
	{
		if ([etenMap objectForKey:result])
		{
			return [etenMap objectForKey:result];
		}
	}

	return result;
}

- (NSMutableArray *)subtrees
{
	NSMutableArray *subtrees = %orig;

//增加按鍵到子音鍵盤
//==============================================================================
	if ([self.name isEqualToString:@"Zhuyin-Consonant-Letters-Keyset_Row1"])
	{
		if (isZhuyin == YES && subtrees.count == 8)
		{
			copySubtree(subtrees, 7);
			[[subtrees objectAtIndex:8] setKeyString:@"ˇ"];
			[[subtrees objectAtIndex:9] setKeyString:@"ˋ"];
			[[subtrees objectAtIndex:10] setKeyString:@"ˊ"];
			[[subtrees objectAtIndex:11] setKeyString:@"˙"];
			[[subtrees objectAtIndex:12] setKeyString:@"ㄚ"];
			[[subtrees objectAtIndex:13] setKeyString:@"ㄞ"];
			[[subtrees objectAtIndex:14] setKeyString:@"ㄢ"];
			[[subtrees objectAtIndex:15] setKeyString:@"ㄦ"];
		}
	}
	else if ([self.name isEqualToString:@"Zhuyin-Consonant-Letters-Keyset_Row2"])
	{
		if (isZhuyin == YES && subtrees.count == 9)
		{
			copySubtree(subtrees, 8);
			[[subtrees objectAtIndex:9] setKeyString:@"ㄛ"];
			[[subtrees objectAtIndex:10] setKeyString:@"ㄟ"];
			[[subtrees objectAtIndex:11] setKeyString:@"ㄣ"];
			[[subtrees objectAtIndex:12] setKeyString:@"ㄜ"];
			[[subtrees objectAtIndex:13] setKeyString:@"ㄠ"];
			[[subtrees objectAtIndex:14] setKeyString:@"ㄤ"];
			[[subtrees objectAtIndex:15] setKeyString:@"ㄝ"];
			[[subtrees objectAtIndex:16] setKeyString:@"ㄡ"];
			[[subtrees objectAtIndex:17] setKeyString:@"ㄥ"];
		}
	}
	else if ([self.name isEqualToString:@"Zhuyin-Consonant-Letters-Keyset_Row3"])
	{
		if (isZhuyin == YES && subtrees.count == 7)
		{
			copySubtree(subtrees, 1);
			[[subtrees objectAtIndex:7] setKeyString:@"ˉ"];
			[[subtrees objectAtIndex:8] setKeyString:@"，"];
			
			if (layout == ZhuyinLayoutCompact || layout == ZhuyinLayoutEten)
			{
				copySubtree(subtrees, 1);
				[[subtrees objectAtIndex:9] setKeyString:@"。"];
			}
		}
	}

//直向注音位置表
//==============================================================================
	else if ([self.name isEqualToString:@"4111853313_320x216_iPhone-Proportional-Eight-on-Nine-Geometry-List"])
	{	
		if (isZhuyin == YES && subtrees.count == 8)
		{
			copySubtree(subtrees, 7);
			if (layout == ZhuyinLayoutCompact)
			{
				setShapeY(subtrees,  0,  3, 43,   1, 9, 28, 39);
				setShapeY(subtrees,  4,  7, 43,  30, 9, 28, 39);

				setShapeX(subtrees,  8,  9, 29,  59, 9, 28, 39); //Additional keys
				setShapeX(subtrees, 10, 15, 29, 146, 9, 28, 39); //Additional keys
			}
			else if (layout == ZhuyinLayoutComputer)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,9,28,39)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(1,52,28,39)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(15,95,28,39)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(30,138,28,39)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(30,9,28,39)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(30,52,28,39)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(44,95,28,39)];
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(59,138,28,39)];

				setShapeX(subtrees,  8,  9, 29,  59, 9, 28, 39); //Additional keys
				setShapeX(subtrees, 10, 12, 29, 146, 9, 28, 39); //Additional keys
				setShapeX(subtrees, 13, 15, 29, 233, 9, 28, 39); //Additional keys
			}
			else if (layout == ZhuyinLayoutEten)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(117,138,28,39)]; //ㄅ
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(262,52,28,39)]; //ㄆ
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(175,138,28,39)]; //ㄇ
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(88,95,28,39)]; //ㄈ
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(59,95,28,39)]; //ㄉ
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(117,52,28,39)]; //ㄊ
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(146,138,28,39)];//ㄋ
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(233,95,28,39)];//ㄌ

				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(59,9,28,39)]; //3
				[[subtrees objectAtIndex:9] setKeyFrame:CGRectMake(88,9,28,39)]; //4
				[[subtrees objectAtIndex:10] setKeyFrame:CGRectMake(30,9,28,39)]; //2
				[[subtrees objectAtIndex:11] setKeyFrame:CGRectMake(1,9,28,39)]; //5
				[[subtrees objectAtIndex:12] setKeyFrame:CGRectMake(1,95,28,39)]; //ㄚ
				[[subtrees objectAtIndex:13] setKeyFrame:CGRectMake(204,52,28,39)]; //ㄞ
				[[subtrees objectAtIndex:14] setKeyFrame:CGRectMake(146,9,28,39)]; //ㄢ
				[[subtrees objectAtIndex:15] setKeyFrame:CGRectMake(262,9,28,39)]; //ㄦ
			}
		}

		shiftMod = YES;
	}
	else if ([self.name isEqualToString:@"3959885884_320x216_iPhone-Proportional-Nine-on-Nine-Geometry-List"])
	{
		if (isZhuyin == YES && subtrees.count == 9)
		{
			copySubtree(subtrees, 8);
			if (layout == ZhuyinLayoutCompact)
			{
				setShapeY(subtrees, 0, 2, 43,  59, 52, 28, 39);
				setShapeY(subtrees, 3, 5, 43,  88, 52, 28, 39);
				setShapeY(subtrees, 6, 8, 43, 175, 52, 28, 39);
				
				setShapeX(subtrees,  9, 11, 29, 204,  52, 28, 39); //Additional keys
				setShapeX(subtrees, 12, 14, 29, 204,  95, 28, 39); //Additional keys
				setShapeX(subtrees, 15, 17, 29, 204, 138, 28, 39); //Additional keys
			}
			else if (layout == ZhuyinLayoutComputer)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(59,52,28,39)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(73,95,28,39)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(88,138,28,39)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(88,52,28,39)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(102,95,28,39)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(117,138,28,39)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(175,52,28,39)];
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(189,95,28,39)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(204,138,28,39)];
				
				setShapeX(subtrees,  9, 11, 29, 204,  52, 28, 39); //Additional keys
				setShapeX(subtrees, 12, 14, 29, 218,  95, 28, 39); //Additional keys
				setShapeX(subtrees, 15, 17, 29, 233, 138, 28, 39); //Additional keys
			}
			else if (layout == ZhuyinLayoutEten)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(88,138,28,39)]; //ㄍ
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(204,95,28,39)]; //ㄎ
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(146,95,28,39)]; //ㄏ
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(117,95,28,39)]; //ㄐ
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(117,9,28,39)]; //ㄑ
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(59,138,28,39)]; //ㄒ
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(59,52,28,39)]; //一
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(30,138,28,39)]; //ㄨ
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(175,52,28,39)]; //ㄩ

				[[subtrees objectAtIndex:9] setKeyFrame:CGRectMake(233,52,28,39)]; //ㄛ
				[[subtrees objectAtIndex:10] setKeyFrame:CGRectMake(1,52,28,39)]; //ㄟ
				[[subtrees objectAtIndex:11] setKeyFrame:CGRectMake(175,9,28,39)]; //ㄣ
				[[subtrees objectAtIndex:12] setKeyFrame:CGRectMake(88,52,28,39)]; //ㄜ
				[[subtrees objectAtIndex:13] setKeyFrame:CGRectMake(1,138,28,39)]; //ㄠ
				[[subtrees objectAtIndex:14] setKeyFrame:CGRectMake(204,9,28,39)]; //ㄤ
				[[subtrees objectAtIndex:15] setKeyFrame:CGRectMake(30,52,28,39)]; //ㄝ
				[[subtrees objectAtIndex:16] setKeyFrame:CGRectMake(146,52,28,39)]; //ㄡ
				[[subtrees objectAtIndex:17] setKeyFrame:CGRectMake(233,9,28,39)]; //ㄥ
			}
		}		
	}
	else if ([self.name isEqualToString:@"1433863935_320x216_iPhone-Zhuyin-Seven-on-Nine-Geometry-List"])
	{
		if (isZhuyin == YES && subtrees.count == 7)
		{
			if (layout == ZhuyinLayoutCompact)
			{
				copySubtree(subtrees, 2);

				setShapeY(subtrees, 0, 3, 43, 117,  9, 28, 39);
				setShapeY(subtrees, 4, 6, 43, 146, 52, 28, 39);

				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(81,178,48,38)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(291,52,28,39)];
				[[subtrees objectAtIndex:9] setKeyFrame:CGRectMake(291,95,28,39)];
			}
			else if (layout == ZhuyinLayoutComputer)
			{
				copySubtree(subtrees, 1);
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(117,9,28,39)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(117,52,28,39)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(131,95,28,39)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(146,138,28,39)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(146,52,28,39)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(160,95,28,39)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(175,138,28,39)];

				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(81,178,48,38)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(1,138,28,39)];
			}
			else if (layout == ZhuyinLayoutEten)
			{
				copySubtree(subtrees, 2);
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(204,138,28,39)]; //ㄓ
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(233,138,28,39)]; 
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(262,138,28,39)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(175,95,28,39)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(262,95,28,39)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(291,95,28,39)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(30,95,28,39)];

				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(81,178,48,38)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(291,52,28,39)];
				[[subtrees objectAtIndex:9] setKeyFrame:CGRectMake(291,138,28,39)];
			}
		}
	}
	else if ([self.name isEqualToString:@"788749323_320x216_iPhone-Proportional-Alphabetic-Row4-Control-Key-Geometry-List"])
	{
		if (isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,178,38,38)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,178,38,38)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(131,178,38,38)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(171,178,68,38)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(241,178,78,38)];	
		}
		else //不是注音
		{	
			//還原既有的位置
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,173,38,42)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,173,38,42)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(81,173,38,42)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(121,173,118,42)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(241,173,78,42)];
		}
	}
	else if([self.name isEqualToString:@"4201734712_320x216_iPhone-Proportional-Shift-Delete-Geometry-List"])
	{
		//讀取既有的位置單元	
		if (isZhuyin == YES && shiftMod == YES)
		{
			if (layout == ZhuyinLayoutCompact)
			{
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(291,138,28,39)];
			}
			else if (layout == ZhuyinLayoutComputer)
			{
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(291,52,28,39)];
			}
			else if (layout == ZhuyinLayoutEten)
			{
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(291,9,28,39)];
			}
		}
		else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/iKeywi2.dylib"])
		{
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(279,131,40,37)];
		}
		else
		{
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(279,119,40,42)];
		}
	}

//橫向注音位置表
//==============================================================================
	else if([self.name isEqualToString:@"1592707839_480x162_iPhone-Proportional-Eight-on-Nine-Geometry-List"])
	{	
		if(isZhuyin == YES && subtrees.count == 8)
		{
			copySubtree(subtrees, 7);
			if (layout == ZhuyinLayoutCompact)
			{
				setShapeY(subtrees, 0, 3, 32,  0, 4, 43, 30);
				setShapeY(subtrees, 4, 7, 32, 43, 4, 43, 30);

				setShapeX(subtrees,  8,  9, 44,  86, 4, 43, 30); //Additional
				setShapeX(subtrees, 10, 15, 44, 218, 4, 43, 30); //Additional
			}
			else if (layout == ZhuyinLayoutComputer)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(0,4,43,30)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(0,36,43,30)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(22,68,43,30)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(43,100,43,30)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(43,4,43,30)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(43,36,43,30)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(65,68,43,30)];
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(86,100,43,30)];

				setShapeX(subtrees,  8,  9, 44,  86, 4, 43, 30); //Additional keys
				setShapeX(subtrees, 10, 15, 44, 218, 4, 43, 30); //Additional keys
			}
			else if (layout == ZhuyinLayoutEten)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(174,100,43,30)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(394,36,43,30)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(262,100,43,30)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(130,68,43,30)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(86,68,43,30)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(174,36,43,30)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(218,100,43,30)];
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(350,68,43,30)];

				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(86,4,43,30)];
				[[subtrees objectAtIndex:9] setKeyFrame:CGRectMake(130,4,43,30)];
				[[subtrees objectAtIndex:10] setKeyFrame:CGRectMake(43,4,43,30)];
				[[subtrees objectAtIndex:11] setKeyFrame:CGRectMake(0,4,43,30)];
				[[subtrees objectAtIndex:12] setKeyFrame:CGRectMake(0,68,43,30)];
				[[subtrees objectAtIndex:13] setKeyFrame:CGRectMake(306,36,43,30)];
				[[subtrees objectAtIndex:14] setKeyFrame:CGRectMake(218,4,43,30)];
				[[subtrees objectAtIndex:15] setKeyFrame:CGRectMake(394,4,42,30)];
			}
		}

		shiftMod = YES;
	}
	else if ([self.name isEqualToString:@"2976480053_480x162_iPhone-Proportional-Nine-on-Nine-Geometry-List"])
	{
		if (isZhuyin == YES && subtrees.count == 9)
		{	
			copySubtree(subtrees, 8);
			if (layout == ZhuyinLayoutCompact)
			{
				setShapeY(subtrees, 0, 2, 32,  86, 36, 43, 30);
				setShapeY(subtrees, 3, 5, 32, 130, 36, 43, 30);
				setShapeY(subtrees, 6, 8, 32, 262, 36, 43, 30);

				setShapeX(subtrees,  9, 11, 44, 306,  36, 43, 30); //Additional
				setShapeX(subtrees, 12, 14, 44, 306,  68, 43, 30); //Additional
				setShapeX(subtrees, 15, 17, 44, 306, 100, 43, 30); //Additional
			}
			else if (layout == ZhuyinLayoutComputer)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(86,36,43,30)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(108,68,43,30)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(130,100,43,30)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(130,36,43,30)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(152,68,43,30)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(174,100,43,30)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(262,36,43,30)];
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(284,68,43,30)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(306,100,43,30)];

				setShapeX(subtrees,  9, 11, 44, 306,  36, 43, 30); //Additional keys
				setShapeX(subtrees, 12, 14, 44, 328,  68, 43, 30); //Additional keys
				setShapeX(subtrees, 15, 17, 44, 350, 100, 43, 30); //Additional keys
			}
			else if (layout == ZhuyinLayoutEten)
			{
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(130,100,43,30)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(306,68,43,30)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(218,68,43,30)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(174,68,43,30)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(174,4,43,30)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(86,100,43,30)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(86,36,43,30)];
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(43,100,43,30)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(262,36,43,30)];

				[[subtrees objectAtIndex:9] setKeyFrame:CGRectMake(350,36,43,30)];
				[[subtrees objectAtIndex:10] setKeyFrame:CGRectMake(0,36,43,30)];
				[[subtrees objectAtIndex:11] setKeyFrame:CGRectMake(262,4,43,30)];
				[[subtrees objectAtIndex:12] setKeyFrame:CGRectMake(130,36,43,30)];
				[[subtrees objectAtIndex:13] setKeyFrame:CGRectMake(0,100,43,30)];
				[[subtrees objectAtIndex:14] setKeyFrame:CGRectMake(306,4,43,30)];//ㄤ
				[[subtrees objectAtIndex:15] setKeyFrame:CGRectMake(43,36,43,30)];//ㄝ
				[[subtrees objectAtIndex:16] setKeyFrame:CGRectMake(218,36,43,30)];//ㄡ
				[[subtrees objectAtIndex:17] setKeyFrame:CGRectMake(350,4,42,30)];//ㄥ
			}
		}
	}
	else if([self.name isEqualToString:@"3271435264_480x162_iPhone-Zhuyin-Seven-on-Nine-Geometry-List"])
	{
		if (isZhuyin == YES && subtrees.count == 7)
		{	
			if (layout == ZhuyinLayoutCompact)
			{
				copySubtree(subtrees, 2);
				setShapeY(subtrees, 0, 3, 32, 174,  4, 43, 30);
				setShapeY(subtrees, 4, 6, 32, 218, 36, 43, 30);

				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(98,132,66,30)];
				setShapeY(subtrees, 8, 9, 32, 438, 36, 43, 30); //Additional
			}
			else if (layout == ZhuyinLayoutComputer)
			{	
				copySubtree(subtrees,1);
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(174,4,43,30)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(174,36,43,30)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(196,68,43,30)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(218,100,43,30)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(218,36,43,30)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(240,68,43,30)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(262,100,43,30)];
			
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(98,132,66,30)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(0,100,43,30)];		
			}
			else if (layout == ZhuyinLayoutEten)
			{	
				copySubtree(subtrees,2);
				[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(306,100,43,30)];
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(350,100,43,30)];
				[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(394,100,43,30)];
				[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(262,68,43,30)];
				[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(394,68,43,30)];
				[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(438,68,43,30)];
				[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(43,68,43,30)];
					
				[[subtrees objectAtIndex:7] setKeyFrame:CGRectMake(98,132,66,30)];
				[[subtrees objectAtIndex:8] setKeyFrame:CGRectMake(438,36,43,30)];
				[[subtrees objectAtIndex:9] setKeyFrame:CGRectMake(438,100,43,30)];
			}
		}
	}
	else if ([self.name isEqualToString:@"1008805050_480x162_iPhone-Landscape-Alphabetic-Row4-Control-Key-Geometry-List"])
	{
		copySubtree(subtrees,4);
		if (isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,132,44,30)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,132,44,30)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(170,132,44,30)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(220,132,166,30)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(386,132,92,30)];
		}	
		else
		{	
			//還原既有的位置組
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,125,44,36)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,125,44,36)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(98,125,44,36)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(146,125,236,36)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(386,125,92,36)];
		}
	}
	else if([self.name isEqualToString:@"4280335633_480x162_iPhone-Landscape-Shift-Delete-Geometry-List"])
	{	
		if (isZhuyin == YES && shiftMod == YES)
		{
			if (layout == ZhuyinLayoutCompact)
			{
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(438,100,43,30)];
			}
			else if (layout == ZhuyinLayoutComputer)
			{
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(438,36,43,30)];
			}
			else if (layout == ZhuyinLayoutEten)
			{
				[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(438,4,43,30)];
			}
		}
		else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/iKeywi2.dylib"])
		{
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(418,93,62,27)];
		}
		else
		{
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(418,85,62,36)];
		}
	}
//==============================================================================
	else if ([self.name isEqualToString:@"Chinese-Numbers-And-Punctuation-Keyset_Row2"] ||
			[self.name isEqualToString:@"Wildcat-Chinese-Second-Alternate-Keyset_Row1"]	||
			[self.name isEqualToString:@"QWERTY-Japanese-First-Alternate-Keyset_Row1"])
	{
		shiftMod = NO;
	}
/*
else if([self.name isEqualToString:@"iPhone-Email-Numbers-And-Punctuation-Alternate_Row1"])
	{
	}*/
//Twitter介面控制行修正
//==============================================================================
	else if ([self.name isEqualToString:@"17239267_320x216_iPhone-Portrait-Pinyin-Twitter-Row4-Control-Key-Geometry-List"]) //注音
	{
		if (isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,178,38,38)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,178,38,38)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(129,178,30,38)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(151,178,44,38)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(197,178,30,38)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(229,178,30,38)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(261,178,58,38)];	
		}
		else
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,173,38,42)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(40,173,38,42)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(81,173,38,42)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(120,173,54,42)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(176,173,30,42)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(208,173,30,42)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(241,173,78,42)];
		}
	}
	else if ([self.name isEqualToString:@"1221015627_320x216_iPhone-Portrait-Twitter-Row4-Control-Key-Geometry-List"]) //英文
	{
		[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,173,38,42)];
		[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,173,38,42)];
		[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(81,173,38,42)];
		[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(121,173,118,42)];
		[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(240,173,38,42)];
		[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(280,173,38,42)];
	}

	else if ([self.name isEqualToString:@"1289652454_480x162_iPhone-Landscape-Twitter-Return-Row4-Control-Key-Geometry-List"]) //注音
	{
		if(isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,132,44,30)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,132,44,30)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(166,132,44,30)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(206,132,80,30)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(290,132,44,30)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(338,132,44,30)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(386,132,92,30)];
		}
		else
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,125,44,36)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,125,44,36)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(98,125,68,36)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(170,125,116,36)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(290,125,44,36)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(338,125,44,36)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(386,125,92,36)];
		}
	}	
	else if ([self.name isEqualToString:@"2011074580_480x162_iPhone-Landscape-Twitter-Row4-Control-Key-Geometry-List"]) //英文
	{
		[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,125,44,36)];
		[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,125,44,36)];
		[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(98,125,44,36)];
		[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(146,125,236,36)];
		[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(386,125,44,36)];
		[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(434,125,44,36)];
	}

//Email介面控制行修正
//==============================================================================
	else if ([self.name isEqualToString:@"2116359154_320x216_iPhone-Portrait-Pinyin-Email-Row4-Control-Key-Geometry-List"]) //注音
	{
		if (isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,178,38,38)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,178,38,38)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(129,178,30,38)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(151,178,44,38)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(197,178,30,38)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(229,178,30,38)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(261,178,58,38)];
		}
		else if (isZhuyin == YES && shiftMod == NO)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,173,38,42)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,173,38,42)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(81,173,38,42)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(121,173,38,42)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(161,173,38,42)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(201,173,38,42)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(241,173,78,42)];
		}
		else if (isZhuyin == NO)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,173,38,42)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,173,38,42)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(81,173,38,42)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(121,173,38,42)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(161,173,38,42)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(201,173,38,42)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(241,173,78,42)];
		}
	}
	else if ([self.name isEqualToString:@"2684152554_480x162_iPhone-Landscape-Email-Row4-Control-Key-Geometry-List"])
	{
		if (isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,132,44,30)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,132,44,30)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(166,132,44,30)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(206,132,80,30)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(290,132,44,30)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(338,132,44,30)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(386,132,92,30)];
		}
		else if (isZhuyin == YES && shiftMod == NO)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,125,44,36)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,125,44,36)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(98,125,44,36)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(146,125,116,36)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(266,125,56,36)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(326,125,56,36)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(386,125,92,36)];
		}
		else if (isZhuyin == NO)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,125,44,36)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,125,44,36)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(98,125,44,36)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(146,125,116,36)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(266,125,56,36)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(326,125,56,36)];
			[[subtrees objectAtIndex:6] setKeyFrame:CGRectMake(386,125,92,36)];				
		}
	}

//URL控制行修正
//==============================================================================
	else if ([self.name isEqualToString:@"1837064189_320x216_iPhone-Portrait-URL-Row4-Control-Key-Geometry-List"])
	{
		if (isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,178,38,38)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,178,38,38)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(129,178,35,38)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(166,178,35,38)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(203,178,35,38)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(241,178,78,38)];
		}
		else
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(1,173,38,42)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(41,173,38,42)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(81,173,52,42)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(134,173,52,42)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(187,173,53,42)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(241,173,78,42)];
		}
	}
	else if ([self.name isEqualToString:@"3485314843_480x162_iPhone-Landscape-URL-Row4-Control-Key-Geometry-List"])
	{	
		
		if (isZhuyin == YES && shiftMod == YES)
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,132,44,30)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,132,44,30)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(168,132,67,30)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(239,132,67,30)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(310,132,67,30)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(388,132,92,30)];
		}
		else
		{
			[[subtrees objectAtIndex:0] setKeyFrame:CGRectMake(2,125,44,36)];
			[[subtrees objectAtIndex:1] setKeyFrame:CGRectMake(50,125,44,36)];
			[[subtrees objectAtIndex:2] setKeyFrame:CGRectMake(98,125,92,36)];
			[[subtrees objectAtIndex:3] setKeyFrame:CGRectMake(194,125,92,36)];
			[[subtrees objectAtIndex:4] setKeyFrame:CGRectMake(290,125,92,36)];
			[[subtrees objectAtIndex:5] setKeyFrame:CGRectMake(386,125,92,36)];
		}
	}

//==============================================================================
	else if ([self.name isEqualToString:@"Portrait-Zhuyin-Vowel-Letters-Keylayout"])
	{
		if (isZhuyin == YES)
		{
			[subtrees removeAllObjects];
		}
	}
	return subtrees;
}

- (BOOL)boolForProperty:(NSString *)property
{
	BOOL propertyControl = %orig;
	//NSLog(@"property is %@ and %d",property,propertyControl);
	if ([property isEqualToString:@"shift-after"] && 
		[self.name hasPrefix:@"Zhuyin-Letter"] &&
		isZhuyin == YES)
	{
		return NO;
	}
	return propertyControl;	
}
%end
//==============================================================================
%group GSpringBoard %hook SpringBoard 
- (void)applicationDidFinishLaunching:(id)application
{
    %orig;

    // Clear the keyboard cache to prevent old images from interfering
    // NOTE: This should only be necessary upon first install, though it is
    //       conceivable that cached files from Safe Mode could later cause
    //       issues.
    Class $UIKeyboardCache = objc_getClass("UIKeyboardCache");
    if ($UIKeyboardCache != nil) 
    {
        UIKeyboardCache *cache = [%c(UIKeyboardCache) sharedInstance];
        CPBitmapStore *_store = MSHookIvar<id>(cache, "_store");
        // FIXME: Consider using purge method for older firmware as well.
        [_store removeImagesInGroups:[_store allGroups]];
    }

    NSFileManager *fileManager = [[NSFileManager alloc] init];
     if (![fileManager fileExistsAtPath:SETTINGS_PATH]) { 
         NSMutableDictionary* zhuyinSettings = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], @"layout", NO, @"EtenEng", nil];
         [zhuyinSettings writeToFile:SETTINGS_PATH atomically:YES];
     }
}

%end %end
//==============================================================================
%group GKeyboardCache %hook UIKeyboardCache
- (void)displayView:(id)view withKey:(id)key fromLayout:(id)layout 
{
    [[view layer] _display];
}
%end %end
//==============================================================================
%ctor
{
	%init;

	if (objc_getClass("UIKeyboardCache") != nil)
    {
        %init(GKeyboardCache); // Include additional hooks for iOS 4.2.1+
    }

	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier isEqualToString:@"com.apple.springboard"]) 
    {
        %init(GSpringBoard);
    }
}