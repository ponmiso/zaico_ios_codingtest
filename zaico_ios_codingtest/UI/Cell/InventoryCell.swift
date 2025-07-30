//
//  InventoryTableViewCell.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

import UIKit

class InventoryCell: UITableViewCell {
    
    let leftText = UILabel()
    let rightText = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 左ラベルの設定
        leftText.font = UIFont.systemFont(ofSize: 16)
        leftText.translatesAutoresizingMaskIntoConstraints = false
        
        // 右ラベルの設定
        rightText.font = UIFont.systemFont(ofSize: 16)
        rightText.translatesAutoresizingMaskIntoConstraints = false
        rightText.textAlignment = .left
        rightText.lineBreakMode = .byTruncatingTail
        rightText.numberOfLines = 1
        
        contentView.addSubview(leftText)
        contentView.addSubview(rightText)
        
        // レイアウト制約
        NSLayoutConstraint.activate([
            leftText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            rightText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightText.leadingAnchor.constraint(equalTo: leftText.trailingAnchor, constant: 10),
            rightText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            leftText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            rightText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // 右側のラベルだけ省略するようにする
        leftText.setContentHuggingPriority(.required, for: .horizontal)
        leftText.setContentCompressionResistancePriority(.required, for: .horizontal)
        rightText.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightText.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func configure(leftText: String, rightText: String) {
        self.leftText.text = leftText
        self.rightText.text = rightText
    }
}
