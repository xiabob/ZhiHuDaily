//
//  ThemeEditorView.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/12.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class ThemeEditorView: UIControl {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.text = "主编"
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var editorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 20, height: 20)
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.isUserInteractionEnabled = false
        return view
    }()
    
    fileprivate lazy var flagView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "Editor_Arrow"))
        view.sizeToFit()
        return view
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = kXBBorderColor
        return view
    }()
    
    fileprivate var editorModels = [EditorModel]()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear

        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - config view
    
    fileprivate func configViews() {
        addSubview(titleLabel)
        addSubview(editorCollectionView)
        addSubview(flagView)
        addSubview(bottomLine)
        setLayout()
    }
    
    fileprivate func setLayout() {
        titleLabel.xb_left = 12
        titleLabel.xb_centerY = xb_centerY
        
        flagView.xb_right = xb_width - 12
        flagView.xb_centerY = titleLabel.xb_centerY
        
        editorCollectionView.xb_left = titleLabel.xb_right + 12
        editorCollectionView.xb_relativeRight = flagView.xb_left - 8
        editorCollectionView.xb_height = xb_height
        editorCollectionView.xb_centerY = titleLabel.xb_centerY
        
        bottomLine.xb_left = 0
        bottomLine.xb_bottom = xb_height
        bottomLine.xb_width = xb_width
        bottomLine.xb_height = kXBBorderWidth
    }
    
    //
    func refreshViews(with editorModels: [EditorModel]) {
        self.editorModels = editorModels
        editorCollectionView.reloadData()
    }

}


//MARK : - UICollectionViewDataSource
extension ThemeEditorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        let model = editorModels[indexPath.row]
        cell.layer.yy_setImage(with: URL(string: model.avatar), placeholder: #imageLiteral(resourceName: "Field_Avatar"))
        cell.xb_setCornerRadius(10)
        return cell
    }
}
