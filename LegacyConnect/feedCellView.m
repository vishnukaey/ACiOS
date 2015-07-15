//
//  feedCellView.m
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "feedCellView.h"

@implementation feedCellView
@synthesize delegate;

-  (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
       
    }
    
    return self;
}

-(void)arrangeSelfForData :(NSDictionary *)dic forWidth:(float)width_
{
    float cellMargin_x = 15, cellMargin_y = 8;
    float dp_im_hight = 60;
    float in_margin = 10;
    float favWidth = 5;
    float cellSpacing_height  = 5;
    
    UIFont *bigFont = [UIFont systemFontOfSize:15];
    UIFont *smallFont = [UIFont systemFontOfSize:12];
    
    
    
    float top_space = 0;
    
    [self setFrame:CGRectMake(0, 0,width_,0)];
    
    UIView *celSpace = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, width_+4, cellSpacing_height)];//spacing  between cells
    celSpace.layer.borderColor = [UIColor lightTextColor].CGColor;
    celSpace.layer.borderWidth = 1;
    celSpace.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:celSpace];
    
    top_space+=cellSpacing_height+cellMargin_y;
    
    NSString  *userName = [dic valueForKey:@"user_name"];
    NSString *dp_data = [dic valueForKey:@"profile_pic"];
    NSString *cause = [dic valueForKey:@"cause"];
    NSString *time_ = [dic valueForKey:@"time"];
    NSString *post_ = [dic valueForKey:@"post"];
    NSString *thanks_ = [dic valueForKey:@"thanks"];
    NSString *comments_ = [dic valueForKey:@"comments"];
    NSString *favourite_ = [dic valueForKey:@"favourite"];
    NSString *type_ = @"Created a Post";
    if ([[dic valueForKey:@"type"] intValue] == 2) {
        type_ = @"Added a Photo";
    }
    NSString *image_ = [dic valueForKey:@"image_url"];
    
    UIImageView *dp_view = [[UIImageView alloc]initWithFrame:CGRectMake(cellMargin_x, top_space, dp_im_hight, dp_im_hight)];
    [dp_view setImage:[UIImage imageNamed:@"clock.jpg"]];
    [self addSubview:dp_view];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(dp_view.frame.origin.x + dp_view.frame.size.width + cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x - dp_view.frame.size.width  - favWidth, 0)];
    [self addSubview:infoLabel];
    infoLabel.numberOfLines = 0;
    
    
    NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:@""];
    //name
    NSAttributedString *name_attr = [[NSAttributedString alloc] initWithString : userName
                                                                    attributes : @{
                                                                                   NSFontAttributeName : bigFont,
                                                                                   NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                   }];
    [attributtedString appendAttributedString:name_attr];
    
    NSAttributedString *type_attr = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@" %@\n",type_]
                                                                    attributes : @{
                                                                                   NSFontAttributeName : bigFont,
                                                                                   NSForegroundColorAttributeName : [UIColor grayColor],
                                                                                   }];
    [attributtedString appendAttributedString:type_attr];
    
    //cause
    NSAttributedString *cause_attr = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@"%@",cause]
                                                                     attributes : @{
                                                                                    NSFontAttributeName : bigFont,
                                                                                    NSForegroundColorAttributeName : [UIColor redColor],
                                                                                    }];
    [attributtedString appendAttributedString:cause_attr];
    [infoLabel setAttributedText:attributtedString];
    
    
    CGRect rect = [attributtedString boundingRectWithSize:CGSizeMake(infoLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    [infoLabel setFrame:CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y, infoLabel.frame.size.width, rect.size.height)];
    
    
    
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y + infoLabel.frame.size.height + 5, infoLabel.frame.size.width, smallFont.pointSize)];
    [self addSubview:timeView];
    
    UIImageView *clockImView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, timeView.frame.size.height, timeView.frame.size.height)];
    clockImView.image = [UIImage imageNamed:@"clock.jpg"];
    [timeView addSubview:clockImView];
    
    UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(clockImView.frame.size.width + 5, 0, timeView.frame.size.width - clockImView.frame.size.width - 5, timeView.frame.size.height)];
    time_label.font = smallFont;
    time_label.text = time_;
    time_label.textColor = [UIColor grayColor];
    [timeView addSubview:time_label];
    
    if (timeView.frame.size.height + timeView.frame.origin.y>dp_view.frame.size.height + dp_view.frame.origin.y) {
        top_space=timeView.frame.size.height + timeView.frame.origin.y + in_margin;
    }else top_space=dp_view.frame.size.height + dp_view.frame.origin.y+in_margin;
    
    
    
    UILabel *postLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x - favWidth, 0)];
    [self addSubview:postLabel];
    postLabel.numberOfLines = 0;
    
    NSMutableAttributedString * post_attributtedString = [[NSMutableAttributedString alloc] initWithString:post_ attributes : @{
                                                                                                                                NSFontAttributeName : bigFont,
                                                                                                                                NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                                                                }];
    [postLabel setAttributedText:post_attributtedString];
    
    rect = [post_attributtedString boundingRectWithSize:CGSizeMake(postLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    [postLabel setFrame:CGRectMake(postLabel.frame.origin.x, postLabel.frame.origin.y, postLabel.frame.size.width, rect.size.height)];
    
    top_space+=postLabel.frame.size.height + in_margin;
    
    if ([[dic valueForKey:@"type"] intValue] == 2)//photo
    {
        UIImageView *statusPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x, 100)];
        [statusPhoto setImage:[UIImage imageNamed:@"clock.jpg"]];
        [self addSubview:statusPhoto];
        top_space += statusPhoto.frame.size.height + in_margin;
    }else
    {
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(0, top_space, self.frame.size.width, 1)];
        [self addSubview:thinLine];
        [thinLine setBackgroundColor:[UIColor lightGrayColor]];
        top_space += thinLine.frame.size.height;
    }
    
    
    
    //bottom row
    float bot_row_hight = 40;
    float bot_IC_hight = 30;
    float bot_labe_width = 90;
    
    UIView * botRow = [[UIView alloc] initWithFrame:CGRectMake(cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x, bot_row_hight)];
    [self addSubview:botRow];
    UIImageView *likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (bot_row_hight - bot_IC_hight)/2, bot_IC_hight, bot_IC_hight)];
    [likeIcon setImage:[UIImage imageNamed:@"clock.jpg"]];
    [botRow addSubview:likeIcon];
    
    UIButton *likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bot_IC_hight, bot_row_hight)];
    likeButton.center = likeIcon.center;
    [botRow addSubview:likeButton];
    [likeButton setBackgroundColor:[UIColor purpleColor]];
    [likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(bot_row_hight + 10, (bot_row_hight - bot_IC_hight)/2, bot_IC_hight, bot_IC_hight)];
    [commentIcon setImage:[UIImage imageNamed:@"clock.jpg"]];
    [botRow addSubview:commentIcon];
    
    UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bot_IC_hight, bot_row_hight)];
    commentButton.center = commentIcon.center;
    [botRow addSubview:commentButton];
    [commentButton setBackgroundColor:[UIColor purpleColor]];
    [commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(botRow.frame.size.width - bot_labe_width, 0, bot_labe_width, botRow.frame.size.height)];
    commentsLabel.font = smallFont;
    [commentsLabel setText:[NSString stringWithFormat:@"%@ COMMENTS", comments_]];
    [botRow addSubview:commentsLabel];
    [commentsLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *thanksLabel = [[UILabel alloc] initWithFrame:CGRectMake(botRow.frame.size.width - bot_labe_width*2, 0, bot_labe_width, botRow.frame.size.height)];
    thanksLabel.font = smallFont;
    [thanksLabel setText:[NSString stringWithFormat:@"%@ THANKS", thanks_]];
    [botRow addSubview:thanksLabel];
    [thanksLabel setTextAlignment:NSTextAlignmentCenter];
    
    top_space+=botRow.frame.size.height;
    
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, top_space)];
}

-(void)likeAction
{
    [delegate feedCellActionWithType:1 andID:@""];
}

-(void)commentAction
{
    [delegate feedCellActionWithType:2 andID:@""];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
