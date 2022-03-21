//
//  HomePageCollectionViewCell.swift
//  HomePageCollectionViewCell
//
//  Created by 陳韋綸 on 2022/3/19.
//

import UIKit

class HomePageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomePageCollectionViewCell"
    
//    var select: Bool = false
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(wordLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wordLabel.frame = bounds
    }
    
    func configure(word: String, select: Bool) {
        wordLabel.text = word
        if select {
            wordLabel.textColor = .systemRed
        }
        else {
            wordLabel.textColor = .label
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
