//
//  LCCollectionViewController.h
//  LegacyConnect
//
//  Created by qbuser on 03/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LCCOLLECTIONVIEW_sizeForItemAtIndexPath \
if(indexPath.row == self.results.count){\
return [super collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath];\
}

#define LCCOLLECTIONVIEW_cellForItemAtIndexPath \
id __nextPageLoaderCell = [super collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath];\
if(__nextPageLoaderCell){\
return __nextPageLoaderCell;\
}


@interface LCCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

/*!
 * The collectionView used by the controller. The delegate and the dataSource are automatically set.
 */
@property (nonatomic) IBOutlet UICollectionView *collectionView;

/*!
 * This view is shown as the last cell of the collectionView if haveMoreData is set to YES. The height of the view is set by using the height of the frame, if the height is 0, UITableViewAutomaticDimension will be used.
 */
@property (nonatomic) IBOutlet UICollectionViewCell *nextPageLoaderCell;

/*!
 * Number of cells require before the last cell for calling startFetchingNextResults. The default value is 3.
 */
@property (nonatomic) NSUInteger nextPageLoaderOffset;

/*!
 * This view is shown when there is no results. The view is automatically added to the superview of the collectionView and have the size and position of the collectionView. The hidden property is set to YES and userInteractionEnabled to NO.
 */
@property (nonatomic) IBOutlet UIView *noResultsView;

/*!
 * This view is shown when startFetchingResults is called and there is no results. The view is automatically added to the superview of the collectionView and have the size and position of the collectionView. The hidden property is set to YES and userInteractionEnabled to NO.
 */
@property (nonatomic) IBOutlet UIView *noResultsLoadingView;

/*!
 * Data fetched by startFetchingResults and startFetchingNextResults.
 */
@property (nonatomic, readonly) NSMutableArray *results;

/*!
 * Indicate if there is more data to load. If set to YES display nextPageLoaderCell.
 */
@property (nonatomic, readonly) BOOL haveMoreData;

/*!
 * Indicate when startFetchingResults or startFetchingNextResults are working.
 */
@property (nonatomic, readonly) BOOL isLoading;

/*!
 * Size of CollectionViewCell.
 */
@property (nonatomic) CGSize collectionViewCellSize;

/*!
 * EdgeInsects for CollectionViewCell.
 */
@property (nonatomic) UIEdgeInsets collectionViewCellInsects;

/*!
 * Minimum Interitem Spacing For Section of CollectionViewCell.
 */
@property (nonatomic) CGFloat interItemSpace;

/*!
 * Reset results and haveMoreData.
 */
- (void)resetData;

/*!
 * This method is supposed to be call after a successful call to startFetchingResults. If results is empty noResultsView will be shown.
 * @param  results Data store in results.
 * @param  haveMoreData Indicate if there is more data to load.
 */
- (void)didFetchResults:(NSArray *)results haveMoreData:(BOOL)haveMoreData;

/*!
 * This method is supposed to be call after a successful call to startFetchingNextResults.
 * @param  results Data added to results.
 * @param  haveMoreData Indicate if there is more data to load.
 */
- (void)didFetchNextResults:(NSArray *)results haveMoreData:(BOOL)haveMoreData;

/*!
 * This method is supposed to be call after a failed call to startFetchingResults or startFetchingNextResults.
 */
- (void)didFailedToFetchResults;

/*!
 * This method must be call for load new data in results. You must override this method and call super at the beginning.
 * When your data is fetch call didFetchResults:haveMoreData:
 * If you failed to retrieve data call didFailedToFetchResults
 */
- (IBAction)startFetchingResults;

/*!
 * This method must be call for load more data in results. You must override this method and call super at the beginning.
 * When your data is fetch call didFetchNextResults:haveMoreData:
 * If you failed to retrieve data call didFailedToFetchResults
 */
- (IBAction)startFetchingNextResults;

/*!
 *  Show noResultsView, can be overriden if you want some animtaion. By default change the hidden property of noResultsView.
 */
- (void)showNoResultsView;

/*!
 *  Hide noResultsView, can be overriden if you want some animtaion. By default change the hidden property of noResultsView.
 */
- (void)hideNoResultsView;

/*!
 *  Show noResultsLoadingView, can be overriden if you want some animtaion. By default change the hidden property of noResultsLoadingView.
 */
- (void)showNoResultsLoadingView;

/*!
 *  Hide noResultsLoadingView, can be overriden if you want some animtaion. By default change the hidden property of noResultsLoadingView.
 */
- (void)hideNoResultsLoadingView;

/*!
 *  By defaut do nothing, can be overriden if you use a refreshControl. Call when startFetchingResults or startFetchingNextResults are finished.
 */
- (void)endRefreshing;

@end
