//
//  MenuCell.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/8.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

protocol MenuCellDelegate: NSObjectProtocol {
    func onFlagButtonClicked(in cell: MenuCell, isSubscribed: Bool)
}

class MenuCell: UITableViewCell {
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = kMenuGrayWhiteTextColor
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var flagView: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(flagButtonClicked), for: .touchUpInside)
        return view
    }()
    
    var themeModel: ThemeModel!
    weak var delegate: MenuCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configViews() {
        selectionStyle = .none
        backgroundColor = kMenuBackgroundColor
    }
    
    func flagButtonClicked() {
        delegate?.onFlagButtonClicked(in: self, isSubscribed: themeModel.isSubscribed)
    }
}
