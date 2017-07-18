//
//  ViewController.m
//  OverlapScrollView
//
//  Created by dabao on 2017/7/18.
//  Copyright © 2017年 dabao. All rights reserved.
//

#import "ViewController.h"

#define w [UIScreen mainScreen].bounds.size.width
#define h [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *verticalScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.view addSubview:self.verticalScrollView];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, h * i, w, h)];
        
        if (i == 0) {
            view.backgroundColor = [UIColor orangeColor];
        }
        else {
            view.backgroundColor = [UIColor lightGrayColor];
        }
        
        [self.verticalScrollView addSubview:view];
    }
    
    [self.view addSubview:self.mainScrollView];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
        
        if (i == 0) {
            view.backgroundColor = [UIColor clearColor];
        }
        else {
            view.backgroundColor = [UIColor redColor];
            [self.mainScrollView addSubview:view];
        }
        
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.view addGestureRecognizer:pan];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    
    static BOOL isVertical;
    static CGPoint currentContentOff;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if(fabs(velocity.x) > fabs(velocity.y)) {
                isVertical = NO;
            } else {
                currentContentOff = self.verticalScrollView.contentOffset;
                isVertical = YES;
            }
            break;
        case UIGestureRecognizerStateChanged:
            
            if (isVertical) {
                self.verticalScrollView.contentOffset = CGPointMake(0, currentContentOff.y - translation.y);
            }
            
            break;
        case UIGestureRecognizerStateEnded:
            if (isVertical) {
                [self.verticalScrollView setContentOffset:CGPointMake(0,  h - currentContentOff.y) animated:YES];
            }
            break;
        default:
            break;
    }
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _mainScrollView.contentSize = CGSizeMake(w * 2, h);
        _mainScrollView.pagingEnabled = YES;
    }
    return _mainScrollView;
}

- (UIScrollView *)verticalScrollView
{
    if (!_verticalScrollView) {
        _verticalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        _verticalScrollView.contentSize = CGSizeMake(w, h * 2);
        _verticalScrollView.pagingEnabled = YES;
    }
    return _verticalScrollView;
}

@end
