//
//  ScrollViewWithPaging.m
//  Mad Ballots
//
//  Created by Tunde Agboola on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewWithPaging.h"

@implementation ScrollViewWithPaging

@synthesize titleLabel;
@synthesize scrollView;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)setupUI{
    pageControl.numberOfPages = viewControllers.count;
    pageControl.currentPage = 0;
    pageControlBeingUsed = NO;
    scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*pageControl.numberOfPages, self.scrollView.frame.size.height);
    scrollView.contentOffset = CGPointMake(0, 0);
    for(int ii = 0; ii < [viewControllers count]; ii++){
        UIViewController *viewController = [viewControllers objectAtIndex:ii];
        viewController.view.frame = CGRectMake(self.scrollView.frame.size.width * ii, 0, viewController.view.frame.size.width, viewController.view.frame.size.height);
        [self.scrollView addSubview:viewController.view];

    }
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}



- (void)keyboardWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint scrollPoint = CGPointMake(scrollView.contentOffset.x,scrollView.contentOffset.y + keyboardSize.height);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification{
    CGPoint scrollPoint = CGPointMake(scrollView.contentOffset.x,0);
    [scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)changePage {
    [self changePage:self.pageControl.currentPage];
}

//- (void)refreshOverviewController {
//    UITableViewController *tableViewController = [viewControllers objectAtIndex:0];
//    [tableViewController.tableView reloadData];
//}

#pragma Mark - ScrollViewWithPaging Delegate methods
-(void)changePage:(int)page{
    self.pageControl.currentPage = page;
    pageControlBeingUsed = YES;
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * page;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
//    if(page == 0)
//        [self refreshOverviewController];
}

-(void)nextPage{
    int nextPage = self.pageControl.currentPage+1;
    if(nextPage == self.pageControl.numberOfPages)
        return;
    else
        [self changePage:nextPage];

}
-(void)previousPage{
    int nextPage = self.pageControl.currentPage-1;
    if(nextPage == -1)
        return;
    else
        [self changePage:nextPage];
    
}

-(void)firstPage{
    [self changePage:0];

}

#pragma mark - Scroll View Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if(!pageControlBeingUsed){
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(page != self.pageControl.currentPage){
            pageControlBeingUsed = YES;
            [self changePage:page];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

@end
