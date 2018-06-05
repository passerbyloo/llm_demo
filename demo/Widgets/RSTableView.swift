import UIKit

class RSTableView: UITableView {
  
  // MARK: Callbacks
  var reloadingBlock: (() -> Void)?
  var loadMoreBlock: (() -> Void)?
  
  private var contentOffsetContext: UInt8 = 1
  var pullToRefreshControl: UIRefreshControl!
  var loadingView: UIActivityIndicatorView!
  var bgView = UIImageView()
  
  deinit {
    removeObserver(self, forKeyPath: "contentOffset")
  }
  
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override func awakeFromNib() {
    setup()
  }
  
  func setup() {
    if #available(iOS 11.0, *) {
      contentInsetAdjustmentBehavior = .never
    }
    keyboardDismissMode = .interactive
    backgroundColor = UIColor.clear
    separatorStyle = .none
    estimatedRowHeight = 44
    bgView.contentMode = .scaleAspectFill
    addSubview(bgView)
    alwaysBounceVertical = true
    showsVerticalScrollIndicator = false
    pullToRefreshControl = UIRefreshControl()
    pullToRefreshControl.tintColor = UIColor.darkGray
    pullToRefreshControl.addTarget(self, action: #selector(reloadTriggered), for: .valueChanged)
    loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    addSubview(loadingView)
    addObserver(self, forKeyPath: "contentOffset", options: .new, context: &contentOffsetContext)
    hideLoading()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    sendSubview(toBack: bgView)
    bgView.frame = bounds
    loadingView.frame = CGRect(x: bounds.width.half - 20, y: contentOffset.y + bounds.height.half - 20, width: 40, height: 40)
  }
  
  func setPullToRefresh(enabled: Bool) {
    pullToRefreshControl.removeFromSuperview()
    if enabled {
      addSubview(pullToRefreshControl)
    }
  }
  
  func showLoadingForFirstPage() {
    if !pullToRefreshControl.isRefreshing {
      loadingView.isHidden = false
      loadingView.startAnimating()
    }
  }
  
  func showLoadingForOthersPage() {
    showLoadingForFirstPage()
  }
  
  func hideLoading() {
    loadingView.isHidden = true
    loadingView.stopAnimating()
    pullToRefreshControl.endRefreshing()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if context == &contentOffsetContext {
      let offsetForLastCell = contentSize.height - height + contentInset.top + contentInset.bottom
      if (contentOffset.y - offsetForLastCell) >= 0 {
        loadMoreTriggered()
      }
    }
  }
  
  @objc fileprivate func reloadTriggered() {
    reloadingBlock?()
  }
  
  @objc fileprivate func loadMoreTriggered() {
    loadMoreBlock?()
  }
}
