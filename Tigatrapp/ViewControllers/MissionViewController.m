//
//  MissionViewController.m
//  Tigatrapp
//
//  Created by jordi on 20/7/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import "MissionViewController.h"
#import "HelpViewController.h"
#import "LocalText.h"
#import "Report.h"
#import "RestApi.h"
#import "UserReports.h"

@interface MissionViewController ()

@end

@implementation MissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LocalText with:@"header_title"];

    NSString *lang = [LocalText currentLoc];
    
    NSString *title = ([lang isEqualToString:@"ca"]? _mission[@"short_description_catalan"] :
                      ([lang isEqualToString:@"es"]? _mission[@"short_description_spanish"] :
                       _mission[@"short_description_english"]));
    NSString *text = ([lang isEqualToString:@"ca"]? _mission[@"long_description_catalan"] :
                          ([lang isEqualToString:@"es"]? _mission[@"long_description_spanish"] :
                           _mission[@"long_description_english"]));
    
    self.view.backgroundColor = C_GRAY;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = C_GRAY;
    
    /*
    NSString *urlString = _mission[@"url"];
    if (urlString.length > 10) {
        _goWebButton.hidden = NO;
    } else {
        _goWebButton.hidden = YES;
    }
*/
    
    float width = self.view.frame.size.width;
    float y = 20.0;
    
    NSString *helpText = ([lang isEqualToString:@"ca"]? _mission[@"help_text_catalan"] :
                      ([lang isEqualToString:@"es"]? _mission[@"help_text_spanish"] :
                       _mission[@"help_text_english"]));
    
    float titleWidth = (helpText.length > 0? width-40-30 : width-40);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,y,titleWidth,100)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0];
    [titleLabel sizeToFit];
    [self.scrollView addSubview:titleLabel];
    if (helpText.length > 0) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20+titleWidth
                                                                      ,y
                                                                      ,30.0
                                                                      ,30.0)];
        [button setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }

    y = y+titleLabel.frame.size.height+20.0;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,y,width-40.0,100)];
    detailLabel.numberOfLines = 0;
    detailLabel.text = text;
    detailLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
    [detailLabel sizeToFit];
    [self.scrollView addSubview:detailLabel];
    y = y+detailLabel.frame.size.height+20.0;
 
    
    
    NSString *urlString = _mission[@"url"];
    if (urlString.length > 10) {
        UIButton *webButton = [[UIButton alloc] initWithFrame:CGRectMake(20
                                                                         ,y
                                                                         ,width-40.0
                                                                         ,58)];
        [webButton setBackgroundColor:C_YELLOW];
        [webButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [webButton setTitle:[LocalText with:@"mission_button_left_url"] forState:UIControlStateNormal];
        [webButton addTarget:self action:@selector(pressGoWeb:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:webButton];
        y = y+webButton.frame.size.height+10.0;

    }
    
    
    NSArray *items = _mission[@"items"];
    // defineixo tag com 
    // numero num pregunta*100 + numero resposta
    
    int numQuestion = 0;
    
    for (NSDictionary *item in items) {

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.0, y-5, width-15, 1)];
        [line setBackgroundColor:C_GRAYLINE];
        [_scrollView addSubview:line];

        
        NSString *question = ([lang isEqualToString:@"ca"]? item[@"question_catalan"] :
                           ([lang isEqualToString:@"es"]? item[@"question_spanish"] :
                            item[@"question_english"]));
        
        NSString *helpText = ([lang isEqualToString:@"ca"]? item[@"help_text_catalan"] :
                              ([lang isEqualToString:@"es"]? item[@"help_text_spanish"] :
                               item[@"help_text_english"]));
        
        float titleWidth = (helpText.length > 0? width-40-30 : width-40);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,y+4,titleWidth,100)];
        titleLabel.numberOfLines = 0;
        titleLabel.text = question;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        [titleLabel sizeToFit];
        [self.scrollView addSubview:titleLabel];
        
        if (helpText.length > 0) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20+titleWidth
                                                                          ,y
                                                                          ,30.0
                                                                          ,30.0)];
            [button setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
            [button setTag: 100+numQuestion];
            [button addTarget:self action:@selector(pressInfoOption:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
        }
        
        
        
        y = y+titleLabel.frame.size.height+10.0;
        
        NSString *jsonString = ([lang isEqualToString:@"ca"]? item[@"answer_choices_catalan"] :
                              ([lang isEqualToString:@"es"]? item[@"answer_choices_spanish"] :
                               item[@"answer_choices_english"]));
        NSError *herror;
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *optionsArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror];
        
        int numAnswer = 0;
        for (NSString *string in optionsArray) {

            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20
                                                                             ,y
                                                                             ,30.0
                                                                             ,30.0)];
            [button setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
            [button setSelected:NO];
            [button setTag: 1000+numQuestion*100 + numAnswer];
            [button addTarget:self action:@selector(pressOption:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,y+4,width-65,100)];
            titleLabel.numberOfLines = 0;
            titleLabel.text = string;
            titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
            [titleLabel sizeToFit];
            [self.scrollView addSubview:titleLabel];
            
            y = y + MAX(titleLabel.frame.size.height,button.frame.size.height) +1.0;
            
            numAnswer++;
        }
        y = y+10;
        numQuestion++;
        
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.0, y-5, width-15, 1)];
    [line setBackgroundColor:C_GRAYLINE];
    [_scrollView addSubview:line];

    y = y+10;
    
    /*
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(20
                                                                     ,y
                                                                     ,width-40.0
                                                                     ,60)];
    [doneButton setBackgroundColor:C_YELLOW];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(pressDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:doneButton];
    y = y+doneButton.frame.size.height+10.0;

    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20
                                                                     ,y
                                                                     ,width-40.0
                                                                     ,60)];
    [deleteButton setBackgroundColor:C_YELLOW];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(pressDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:deleteButton];
    y = y+deleteButton.frame.size.height+10.0;
     
     */

    [_scrollView setContentSize:CGSizeMake(width, y+30)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uiactions

-(IBAction)pressMoreInfo:(id)sender {
    
    NSString *lang = [LocalText currentLoc];
    NSString *text = ([lang isEqualToString:@"ca"]? _mission[@"help_text_catalan"] :
                          ([lang isEqualToString:@"es"]? _mission[@"help_text_spanish"] :
                           _mission[@"help_text_english"]));
    
    [self performSegueWithIdentifier:@"helpSegue" sender:text];
}

-(IBAction)pressGoWeb:(id)sender {
    NSString *urlString = _mission[@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
     
-(IBAction)pressDone:(id)sender {
    
    // preparar crida
    NSString *lang = [LocalText currentLoc];
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    
    NSArray *items = _mission[@"items"];
    // defineixo tag com
    // numero num pregunta*100 + numero resposta
    
    int numQuestion = 0;
    BOOL surveyCompleted = YES;
    
    for (NSDictionary *item in items) {

        NSString *question = ([lang isEqualToString:@"ca"]? item[@"question_catalan"] :
                              ([lang isEqualToString:@"es"]? item[@"question_spanish"] :
                               item[@"question_english"]));
        
        int answer = -1;
        for (UIView *view in _scrollView.subviews) {
            if (view.tag >= 1000+numQuestion*100 && view.tag<1000+numQuestion*100+100) {
                UIButton *b = (UIButton *)view;
                if (b.isSelected) {
                    answer = (int)b.tag - 1000 - 100*numQuestion;
                }
                
            }
        }
        if (answer == -1) {
            surveyCompleted = NO;
            break;
        } else {
            NSString *jsonString = ([lang isEqualToString:@"ca"]? item[@"answer_choices_catalan"] :
                                    ([lang isEqualToString:@"es"]? item[@"answer_choices_spanish"] :
                                     item[@"answer_choices_english"]));
            NSError *herror;
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *optionsArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror];
            [answers addObject:@{@"question": question,
                                 @"answer": optionsArray[answer]}];
        }
        numQuestion++;
    }
    
    if (surveyCompleted) {
        
        // OMPLIR UN REPORT I CAP A BARRACA

        
        [[RestApi sharedInstance].missionsArray removeObject:_mission];
        [[RestApi sharedInstance].ackMissionsArray addObject:_mission];
        [[RestApi sharedInstance]  saveAckMissionsToUserDefaults];
        
        if (items.count > 0) {
            Report *report = [[Report alloc] initWithDictionary:nil];
            report.type = @"mission";
            report.mission = _mission[@"id"];
            report.responses = answers;
            
            [[UserReports sharedInstance] addReport:report];
            //NSLog(@"insertant MISSIO versio %d %@" ,[report.versionNumber intValue],[report dictionaryIncludingImages:NO]);
            
        }

        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[LocalText with:@"header_title"]
                                                        message:[LocalText with:@"task_complete_checklist"]
                                                       delegate:self
                                              cancelButtonTitle:[LocalText with:@"ok"]
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    
    
}

-(IBAction)pressCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)pressOption:(UIButton *)button {
    
    int question = floor( (button.tag-1000) / 100);
    
    for (UIView *v in _scrollView.subviews) {
        if (floor((v.tag - 1000)/100) == question) {
            UIButton *b = (UIButton *)v;
            [b setSelected:NO];
        }
    }
    [button setSelected: YES];
}

-(IBAction)pressInfoOption:(UIButton *)button {
    
    NSString *lang = [LocalText currentLoc];
    int question = (int) button.tag - 100;
    NSArray *items = _mission[@"items"];
    NSDictionary *item = items[question];
    NSString *helpText = ([lang isEqualToString:@"ca"]? item[@"help_text_catalan"] :
                          ([lang isEqualToString:@"es"]? item[@"help_text_spanish"] :
                           item[@"help_text_english"]));
    [self performSegueWithIdentifier:@"helpSegue" sender:helpText];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"helpSegue"]) {
        HelpViewController *vc = [segue destinationViewController];
        vc.urlString = nil;
        vc.htmlString = (NSString *)sender;
    }
}


@end
