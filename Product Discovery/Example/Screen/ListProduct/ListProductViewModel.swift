//
//  ListProductViewModel.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import RxSwift
import RxCocoa
import Domain

public protocol ListProductCoordinatorType {
    func goDetail(id: Int) -> Completable
}

public class ListProductViewModel {
    public let inLoad = PublishRelay<Void>()
    public let inReload = PublishRelay<Void>()
    public let inQuery = PublishRelay<String>()
    public let inSelect = PublishRelay<Int>()
    
    public let outData: Observable<[ProductItemViewModel]>
    public let outLoading: Observable<Bool>
    public let outReloading: Observable<Bool>
    public let outError: Observable<DemoError>
    
    private let disposeBag = DisposeBag()
    
    public init(networkServiceProvider: NetworkServiceProviderType, coordinator: ListProductCoordinatorType) {
        let productService = networkServiceProvider.makeProductService()
        let searchService = networkServiceProvider.makeSearchService()
        let fullProducts = PublishRelay<[ProductItem]>()
        let filtedData = PublishRelay<[ProductItemViewModel]>()
        let loadingTracker = ActivityIndicator()
        
        let result = Paginate.getItem(loadTrigger: inLoad.asObservable(), reloadTrigger: inReload.asObservable(), loadingTracker: loadingTracker) {
            productService.getListProduct().asObservable()
        }
        result.item
            .do(onNext: {
                filtedData.accept($0.map { ProductItemViewModel(product: $0, ranges: []) })
            })
            .bind(to: fullProducts)
            .disposed(by: disposeBag)
        
        inSelect.withLatestFrom(filtedData) { $1[$0] }
            .flatMapLatest {
                coordinator.goDetail(id: $0.product.id).catchErrorJustComplete()
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        // Empty query
        inQuery.filter { $0.trimmingCharacters(in: .whitespaces).isEmpty }
            .withLatestFrom(fullProducts)
            .map { $0.map { ProductItemViewModel(product: $0, ranges: []) } }
            .bind(to: filtedData)
            .disposed(by: disposeBag)
        
        // Not empty query
        inQuery.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .withLatestFrom(fullProducts) { (query: $0, list: $1) }
            .flatMapLatest { data -> Observable<[ProductItemViewModel]> in
                return searchService.search(data.query, in: data.list.map { $0.name })
                    .map { results -> [ProductItemViewModel] in
                        results.map { ProductItemViewModel(product: data.list[$0.index], ranges: $0.ranges) }
                    }
                    .trackActivity(loadingTracker)
                    .catchErrorJustComplete()
            }
            .bind(to: filtedData)
            .disposed(by: disposeBag)
        
        outData = filtedData.asObservable()
        outLoading = result.isLoading
        outReloading = result.isReloading
        outError = result.error.map { $0.asDemoError() }
    }
}
