//
//  ListProductViewController.swift
//  Demo Demo
//
//  Created by HoaPQ on 4/24/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Domain

final class ListProductViewController: UIViewController {
    
    private let tableView = UITableView().then {
        $0.register(cellType: ProductItemCell.self)
        $0.separatorStyle = .none
    }
    
    private let refreshControl = UIRefreshControl()
    
    private let searchBar = MBTextField().then {
        $0.borderStyle = .roundedRect
        $0.leftImage = UIImage(named: "ic_search")
        $0.leftPadding = 10
        $0.attributedPlaceholder = NSAttributedString(string: "Nhập tên sản phẩm", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: ColorUtils.coolGrey])
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = ColorUtils.darkGrey
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
    }
    
    private let imageBack = UIImageView().then {
        $0.image = UIImage(named: "ic_chevron_left")
    }
    
    private let navView = UIView().then {
        $0.backgroundColor = ColorUtils.tomato
    }
    
    private let disposeBag = DisposeBag()
    var viewModel: ListProductViewModel!
    public var backAction: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        configViews()
        configConstraints()
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.inLoad.accept(())
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func configViews() {
        view.addSubviews(navView, tableView)
        navView.addSubviews(imageBack, searchBar)
        tableView.refreshControl = refreshControl
        imageBack.addTapGesture(self, action: #selector(onBack))
    }
    
    private func configConstraints() {
        navView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navView.snp.bottom)
        }
        
        imageBack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(view.safeArea.top).offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.height.equalTo(24)
        }
        
        searchBar.snp.makeConstraints {
            $0.centerY.equalTo(imageBack)
            $0.leading.equalTo(imageBack.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(32)
        }
        addGradient(to: navView, colors: [ColorUtils.tomatoTwo, ColorUtils.reddishOrange])
        addShadowToSearchBar()
    }
    
    private func addGradient(to target: UIView, colors: [UIColor]) {
        target.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = view.bounds
        target.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addShadowToSearchBar() {
        searchBar.layer.shadowColor = ColorUtils.black30.cgColor
        searchBar.layer.shadowOpacity = 1
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchBar.layer.shadowRadius = 4
    }
    
    @objc private func onBack() {
        if navigationController != nil {
            self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        self.dismiss(animated: true, completion: nil)
        backAction?()
    }
}

extension ListProductViewController {
    private func bindViewModel() {
        viewModel.outData
            .bind(to: tableView.rx.items(cellIdentifier: ProductItemCell.reuseIdentifier, cellType: ProductItemCell.self)) { row, item, cell in
                cell.bind(item)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inSelect)
            .disposed(by: disposeBag)
        
        viewModel.outLoading
            .bind(to: LoadingHUD.loadingBinder(for: self))
            .disposed(by: disposeBag)
        
        viewModel.outReloading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.outError
            .bind(to: ErrorHandler.defaultAlertBinder(controller: self))
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: viewModel.inQuery)
            .disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inReload)
            .disposed(by: disposeBag)
    }
}

extension Coordinator: ListProductCoordinatorType where Base: ListProductViewController {
    func goDetail(id: Int) -> Completable {
        let vc = UIAlertController(title: "Tap to detail", message: nil, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return present { vc }
    }
}
