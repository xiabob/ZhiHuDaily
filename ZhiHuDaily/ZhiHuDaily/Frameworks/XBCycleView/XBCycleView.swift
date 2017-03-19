//
//  XBCycleView.swift
//  XBCycleView
//
//  Created by xiabob on 16/6/13.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit
import SnapKit

public protocol XBCycleViewDelegate: NSObjectProtocol {
    func tapImage(_ cycleView: XBCycleView, currentImage: UIImage?, currentIndex: Int)
}

open class XBCyclePageView: UIView {
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.textAlignment = .justified
        return label
    }()
    
    open var image: UIImage? {
        get {
            return imageView.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-34)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
    }
    
    open func refreshViews(with image: UIImage?, title: String?) {
        imageView.image = image
        titleLabel.text = title
    }
}

open class XBCycleView: UIView, UIScrollViewDelegate {
    //MARK: - private var

    //index
    fileprivate var currentIndex: Int = 0
    fileprivate var nextIndex: Int = 0
    
    //subviews
    fileprivate lazy var scrollView: UIScrollView = self.configScrollView()
    fileprivate lazy var currentImageView: XBCyclePageView = self.configImageView()
    fileprivate lazy var nextImageView: XBCyclePageView = self.configImageView()
    fileprivate lazy var pageControl: UIPageControl = self.configPageControl()
    fileprivate lazy var tapGesture: UITapGestureRecognizer = { [unowned self] in
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(tapImageView))
        return tap
        }()
    
    //timer
    fileprivate var timer: Timer?
    
    fileprivate var downloader = XBImageDownloader()
    
    //MARK: - public api var
    //size
    open private(set) var width: CGFloat = 0
    open private(set) var origineHeight: CGFloat = 0
    open var height: CGFloat = 0 {
        didSet {
            bounds = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
    open var y: CGFloat = 0 {
        didSet {
            frame = CGRect(x: frame.origin.x, y: y, width: width, height: height)
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            scrollView.contentSize = CGSize(width: width*3, height: 0)
            scrollView.contentOffset = CGPoint(x: width, y: 0)
            currentImageView.frame = CGRect(x: currentImageView.frame.minX, y: currentImageView.frame.minY, width: bounds.width, height: bounds.height)
            nextImageView.frame = CGRect(x: nextImageView.frame.minX, y: nextImageView.frame.minY, width: bounds.width, height: bounds.height)
            setPageControlLayout()
        }
    }
    
    open var imageModelArray = [XBCycleViewImageModel]() {
        didSet {
            updateCycleView()
            if imageModelArray.count > 0 {
                isAutoCycle = true
            }
        }
    }
    ///是否是自动循环轮播，默认为true
    open var isAutoCycle: Bool = true {
        didSet {
            if isAutoCycle {
                addTimer()
            } else {
                removeTimer()
            }
        }
    }
    
    ///自动轮播的时间间隔，默认是2s。如果设置这个参数，之前不是自动轮播，现在就变成了自动轮播
    open var autoScrollTimeInterval: TimeInterval = 2 {
        didSet { isAutoCycle = true }
    }
    
    ///默认是false，如果值为true，表示完全滚动到下一页才改变PageControl的currentPage
    open var isChangePageControlDelay = false
    
    ///处理图片点击事件的代理
    weak open var delegate: XBCycleViewDelegate?
    
    //MARK: - init cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    ///用于显示网络图片
    public init(frame: CGRect, imageUrlStringArray: [String]) {
        super.init(frame: frame)
        
        var modelArray = [XBCycleViewImageModel]()
        var model: XBCycleViewImageModel
        for item in imageUrlStringArray {
            model = XBCycleViewImageModel(imageUrlString: item)
            modelArray.append(model)
        }
        imageModelArray = modelArray

        commonInit()
    }
    
    ///用于显示本地图片
    public init(frame: CGRect, localImageArray: [UIImage]) {
        super.init(frame: frame)
        
        var modelArray = [XBCycleViewImageModel]()
        var model: XBCycleViewImageModel
        for item in localImageArray {
            model = XBCycleViewImageModel(localImage: item)
            modelArray.append(model)
        }
        imageModelArray = modelArray
        
        commonInit()
    }
    
    ///网络图片、本地图片混合显示
    public init(frame: CGRect, imageArray: [(urlString: String, localImage: UIImage)]) {
        super.init(frame: frame)
        
        var modelArray = [XBCycleViewImageModel]()
        var model: XBCycleViewImageModel
        for item in imageArray {
            model = XBCycleViewImageModel(imageUrlString: item.urlString,
                                          localImage: item.localImage)
            modelArray.append(model)
        }
        imageModelArray = modelArray

        commonInit()
    }
    
    ///使用图片Model数组初始化轮播器
    public init(frame: CGRect, imageModelArray: [XBCycleViewImageModel]) {
        super.init(frame: frame)
        
        self.imageModelArray = imageModelArray
        
        commonInit()
    }
    
    deinit {
        removeTimer()
        removeNotification()
        scrollView.removeGestureRecognizer(tapGesture)
    }
    
    fileprivate func commonInit() {
        width = frame.size.width
        height = frame.size.height
        origineHeight = height
        
        configViews()
        addNotification()
        updateCycleView()
    }
    
    //MARK: - config views
    fileprivate func configViews() {
        addSubview(scrollView)
        scrollView.addSubview(currentImageView)
        scrollView.addSubview(nextImageView)
        addSubview(pageControl)
        
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func configScrollView() -> UIScrollView {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view: UIScrollView = UIScrollView(frame: rect)
        view.contentSize = CGSize(width: width*3, height: 0)
        view.contentOffset = CGPoint(x: width, y: 0)
        view.isPagingEnabled = true
        //bounces为true时，用力快速滑动时，scrollView的contentOffset有偏差。
        view.bounces = false
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.white
        view.delegate = self
        
        return view;
    }
    
    fileprivate func configImageView() -> XBCyclePageView {
        let imageView = XBCyclePageView(frame: CGRect(x: width, y: 0, width: width, height: height))
        return imageView
    }
    
    fileprivate func configPageControl() -> UIPageControl {
        let pageControl: UIPageControl = UIPageControl()
        pageControl.currentPage = currentIndex
        pageControl.hidesForSinglePage = true
        return pageControl
    }
    
    //MARK: - set layout
    fileprivate func setPageControlLayout() {
        //pageControl
        pageControl.numberOfPages = imageModelArray.count
        pageControl.currentPage = currentIndex
        let size = pageControl.size(forNumberOfPages: pageControl.numberOfPages)
        let point = CGPoint(x: width/2 - size.width/2, y: height - size.height)
        pageControl.frame = CGRect(origin: point, size: size)
    }
    
    //MARK: - update model array and page control
    fileprivate func updateCycleView() {
        setImageModelArray()
        setPageControlLayout()
    }
    
    
    //MARK: - UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imageModelArray.count == 0 {return}
        
        let offset: CGFloat = scrollView.contentOffset.x
        if offset < width {  //right
            nextImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            nextIndex = (currentIndex - 1) < 0 ? imageModelArray.count - 1 : (currentIndex - 1)
            
            if isChangePageControlDelay == false {
                if offset <= 0.5 * width {
                    pageControl.currentPage = nextIndex
                } else {
                    pageControl.currentPage = currentIndex
                }
            }
            
            if offset <= 0 {
                nextPage()
            }
        } else if offset > width { //left
            nextImageView.frame = CGRect(x: 2*width, y: 0, width: width, height: height)
            nextIndex = (currentIndex + 1) > imageModelArray.count - 1 ? 0 : (currentIndex + 1)
            
            if isChangePageControlDelay == false {
                if offset <= 1.5 * width {
                    pageControl.currentPage = currentIndex
                } else {
                    pageControl.currentPage = nextIndex
                }
            }
            
            if offset >= 2 * width {
                nextPage()
            }
        }
        
        let model = imageModelArray[nextIndex]
        if model.localImage == nil && model.imageUrlString != nil {
            downloader.getImageWithUrl(urlString: model.imageUrlString!,
                                       completeClosure: { [unowned self](image) in
                                        if self.nextIndex ==
                                            self.imageModelArray.index(of: model) {
                                            self.nextImageView.refreshViews(with: image, title: model.title)
                                        }
                })
        } else {
            //本地图片
            nextImageView.refreshViews(with: model.localImage, title: model.title)
        }
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    //MARK: - add/remove timer
    fileprivate func addTimer() {
        if isAutoCycle && imageModelArray.count > 1 {
            if timer != nil {
                removeTimer()
            }
            
            timer = Timer.xb_scheduledTimerWithTimeInterval(autoScrollTimeInterval,
                                                              isRepeat: true,
                                                              closure: { [unowned self] in
                                                                self.autoCycle()
                })
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    fileprivate func removeTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    //MARK: - add/remove notification
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startTimer), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    fileprivate func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    //MARK: - action
    fileprivate func autoCycle() {
        scrollView.setContentOffset(CGPoint(x: 2*width, y: 0), animated: true)
    }
    
    fileprivate func nextPage() {
        currentImageView.refreshViews(with: nextImageView.image, title: imageModelArray[nextIndex].title)
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        currentIndex = nextIndex
        pageControl.currentPage = currentIndex
    }
    
    fileprivate func setImageModelArray() {
        for model in imageModelArray {
            if model.localImage == nil && model.imageUrlString != nil {
                downloader.getImageWithUrl(urlString: model.imageUrlString!,
                                           completeClosure: { [unowned self](image) in
                                            if self.currentIndex ==
                                                self.imageModelArray.index(of: model) {
                                                self.currentImageView.refreshViews(with: image, title: model.title)
                                            }
                    })
            } else {
                if currentIndex == imageModelArray.index(of: model) {
                    currentImageView.refreshViews(with: model.localImage, title: model.title)
                }
            }
        }
    }
    
    func tapImageView() {
        if let delegate = self.delegate {
            delegate.tapImage(self,
                              currentImage: currentImageView.image,
                              currentIndex: currentIndex)
        }
    }
    
    func stopTimer() {
        removeTimer()
    }
    
    func startTimer() {
        addTimer()
    }
    
    //MARK: - public api method
    
    ///修改PageControl的小圆点颜色值
    open func setPageControl(_ pageIndicatorTintColor: UIColor,
                               currentPageIndicatorTintColor: UIColor) {
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }
}

