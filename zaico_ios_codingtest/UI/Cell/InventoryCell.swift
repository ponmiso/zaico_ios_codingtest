//
//  InventoryTableViewCell.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

import UIKit

class InventoryCell: UITableViewCell {
    
    let label1 = UILabel()
    let label2 = UILabel()
    
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
        // ラベル1の設定
        label1.font = UIFont.systemFont(ofSize: 16)
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        // ラベル2の設定
        label2.font = UIFont.systemFont(ofSize: 16)
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.textAlignment = .left
        label2.lineBreakMode = .byTruncatingTail
        label2.numberOfLines = 1
        
        contentView.addSubview(label1)
        contentView.addSubview(label2)
        
        // レイアウト制約
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            label2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label2.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 10),
            label2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            label1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // 右側のラベルだけ省略するようにする
        label1.setContentHuggingPriority(.required, for: .horizontal)
        label1.setContentCompressionResistancePriority(.required, for: .horizontal)
        label2.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label2.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func configure(leftText: String, rightText: String) {
        label1.text = leftText
        label2.text = rightText
    }
}
