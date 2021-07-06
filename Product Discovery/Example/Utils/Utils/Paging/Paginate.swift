//
//  Paginate.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import RxSwift
import RxCocoa

fileprivate enum LoadingType {
    case load
    case reload
    case loadmore
}

class Paginate {

    class func getItem<Input, Item>(
        loadTrigger: Observable<Input>,
        reloadTrigger: Observable<Input>,
        errorTracker: ErrorTracker = ErrorTracker(),
        loadingTracker: ActivityIndicator = ActivityIndicator(),
        reloadingTracker: ActivityIndicator = ActivityIndicator(),
        getItem: @escaping (Input) -> Observable<Item>
    ) -> ItemResult<Item> {
        let errorTracker = ErrorTracker()
        
        let loadingType = Observable.merge(
            loadTrigger.map{(LoadingType.load, $0)},
            reloadTrigger.map{(LoadingType.reload, $0)})
        
        let itemResult = loadingType.flatMapLatest { type -> Observable<Item> in
            var activityIndicator: ActivityIndicator!
            switch type.0 {
            case .load: activityIndicator = loadingTracker
            default: activityIndicator = reloadingTracker
            }
            
            return getItem(type.1).trackActivity(activityIndicator)
                .trackError(with: errorTracker)
                .catchErrorJustComplete()
        }.share()
        
        return ItemResult(item: itemResult, error: errorTracker.asObservable(), isLoading: loadingTracker.asObservable(), isReloading: reloadingTracker.asObservable())
    }
    
    class func getPage<Input, Item>(
        loadTrigger: Observable<Input>,
        reloadTrigger: Observable<Input>,
        loadMoreTrigger: Observable<Input>,
        errorTracker: ErrorTracker = ErrorTracker(),
        loadingTracker: ActivityIndicator = ActivityIndicator(),
        reloadingTracker: ActivityIndicator = ActivityIndicator(),
        loadMoreTracker: ActivityIndicator = ActivityIndicator(),
        getItems: @escaping (Input, Int) -> Observable<PageItem<Item>>
        ) -> PageResult<Item> {
        
        
        let pageSubject = BehaviorRelay<PageItem<Item>?>(value: nil)
        
        let loadingType = Observable.merge(
            loadTrigger.map{(LoadingType.load, $0)},
            reloadTrigger.map{(LoadingType.reload, $0)})
        
        let pageItemResult = loadingType
            .flatMapLatest { type -> Observable<PageItem<Item>> in
                var activityIndicator: ActivityIndicator?
                switch type.0 {
                case .load:
                    activityIndicator = loadingTracker
                case .loadmore:
                    activityIndicator = loadMoreTracker
                case .reload:
                    activityIndicator = reloadingTracker
                }
                
                var nextPage = 1
                if type.0 == .loadmore {
                    nextPage = (pageSubject.value?.page ?? 0) + 1
                }
                
                return getItems(type.1, nextPage).map { items -> PageItem<Item> in
                    let preItems = pageSubject.value?.items ?? []
                    let _items = type.0 == .loadmore ? (preItems + items.items) : items.items
                    return PageItem<Item>(page: items.page, items: _items, hasMorePages: items.hasMorePages)

                }.trackActivity(activityIndicator!)
                .trackError(with: errorTracker)
                .catchErrorJustComplete()
            }.do(onNext: {
                pageSubject.accept($0)
            })
        
        let page = pageItemResult.withLatestFrom(pageSubject.compactMap{$0}).share()
        
        return PageResult(
            page: page,
            error: errorTracker.asObservable(),
            isLoading: loadingTracker.asObservable(),
            isReloading: reloadingTracker.asObservable(),
            isLoadingMore: loadMoreTracker.asObservable()
        )
    }
}
