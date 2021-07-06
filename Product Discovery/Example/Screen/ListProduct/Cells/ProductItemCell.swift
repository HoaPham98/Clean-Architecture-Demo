//
//  ProductItemCell.swift
//  Demo Demo
//
//  Created by HoaPQ on 4/25/21.
//

import UIKit
import Domain
import Reusable
import Then
import Kingfisher

class ProductItemCell: UITableViewCell, Reusable {
    
    private let containerView = UIView().then {
        $0.backgroundColor = ColorUtils.white
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
    }
    private let productImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let saleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        $0.textColor = ColorUtils.tomato
    }
    private let currencyLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        $0.textColor = ColorUtils.tomato
        $0.text = Locale(identifier: "en_US").currencySymbol
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configViews()
        configConstraints()
    }
    
    private func configViews() {
        contentView.backgroundColor = ColorUtils.paleGrey
        contentView.addSubview(containerView)
        containerView.addSubviews(productImageView, titleLabel, saleLabel, currencyLabel)
    }
    
    private func configConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0))
        }
        
        productImageView.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.centerY.equalToSuperview()
            $0.top.leading.equalToSuperview().offset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.leading.equalTo(productImageView.snp.trailing).offset(12)
            $0.top.equalTo(productImageView)
        }
        
        saleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.top.equalTo(saleLabel)
            $0.leading.equalTo(saleLabel.snp.trailing).offset(1)
            $0.trailing.lessThanOrEqualToSuperview().offset(-12)
        }
    }
    
    func bind(_ viewModel: ProductItemViewModel) {
        let attr = NSMutableAttributedString(string: viewModel.product.name, attributes: [.font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: ColorUtils.darkGrey])
        viewModel.ranges.forEach {
            attr.addAttributes([.font: UIFont.boldSystemFont(ofSize: 14.0), .foregroundColor: UIColor.black], range: NSRange($0, in: viewModel.product.name))
        }
        titleLabel.attributedText = attr
        productImageView.kf.setImage(with: URL(string: viewModel.product.imageUrl), placeholder: UIImage(named: "ic_placeholder"))
        saleLabel.text = "\(viewModel.product.price)"
    }
}
