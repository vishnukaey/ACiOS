//
//  LCCauseTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/17/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCCauseTutorial.h"


@interface LCCauseTutorial ()
{
  IBOutlet UILabel *label1;
  IBOutlet UIView *view1;
}
@end

@implementation LCCauseTutorial


- (void) awakeFromNib {
  [super awakeFromNib];
  [self setLabels];
}


- (void)setLabels
{
  NSString *labelString = @"This is a CAUSE page. Use it to find\n other people who support this\nCAUSE, to learn how they HELPED\nthis Cause and to discover\nOPPORTUNITIES for you to help,\ntoo. Support CAUSES to see their\nactivity in your FEED.";
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:labelString];
  NSArray * colorWords = @[@"CAUSE", @"HELPED", @"OPPORTUNITIES", @"CAUSES", @"FEED"];
  // -- Add Font -- //
  [attributtedString addAttributes:@{
                                     NSFontAttributeName : self.font,
                                     } range:NSMakeRange(0, attributtedString.length)];
  [attributtedString addAttribute:NSForegroundColorAttributeName
                            value:self.colorFontGrey
                            range:NSMakeRange(0, labelString.length)];
  
  for(NSString *word in colorWords)
  {
    NSRange range = NSMakeRange(0, labelString.length);
    while(range.location != NSNotFound)
    {
      range = [labelString rangeOfString: word options:0 range:range];
      if(range.location != NSNotFound)
      {
        [attributtedString addAttribute:NSForegroundColorAttributeName
                                  value:self.colorFontRed
                                  range:range];
      }
    }
  }
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:self.lineSpacing];
  [attributtedString addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, labelString.length)];
  
  [label1 setAttributedText:attributtedString];
  
  view1.backgroundColor = self.colorTransparentBlack;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

