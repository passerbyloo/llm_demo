import UIKit

class TableCellHolder: NSObject {
  var obj: Any?
  var cellClass: AnyClass?
  var cellClassName: String {
    var name: String = "\(cellClass!)"
    if name.contains(".") {
      name = name.components(separatedBy: ".").last!
    }
    return name
  }
  var isCellSelected = false
  var tag: Int = 0
}

class TableSectionHolder: NSObject {
  var allCells = [TableCellHolder]()
  var sectionHeaderView : UIView?
  var sectionFooterView : UIView?
  var sectionHeaderHeight : CGFloat = 0
  var sectionFooterHeight : CGFloat = 0
  var isCellsHidden = false
}

class RSTableViewCell: UITableViewCell {
  weak var manager: TableDataManager?
  var indexPath: IndexPath!
  var selectable = true
  
  class func height(_ cellHolder: TableCellHolder, width: CGFloat) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    backgroundColor = UIColor.clear
    contentView.backgroundColor = UIColor.clear
    backgroundView = UIView()
    backgroundView?.backgroundColor = UIColor.clear
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.clear
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    if selectable { contentView.alpha = highlighted ? 0.6 : 1.0 }
  }
  
  func setContent(_ cellHolder: TableCellHolder, width: CGFloat) {
    
  }
  
  func layoutForParallax(y: CGFloat) {
    
  }
}

typealias ScrollBlock = ((CGPoint) -> Void)

class TableDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
  
  weak var tableView: RSTableView!
  var logEnabled = true
  // MARK: Data
  var allSections = [TableSectionHolder]()
  // MARK: Network
  var isLoading = false
  var isLoadedAll = false
  var isPaginationSupported = true
  var isPullToRefreshSupported = true {
    didSet {
      tableView.setPullToRefresh(enabled: isPullToRefreshSupported)
    }
  }
  var currentPage = 1
  var shouldCleanAllWhenPullToRefresh = true
  // MARK: Callbacks
  var loadDataAtPage: ((Int) -> Void)?
  private var didScrollBlocks = [ScrollBlock]()
  var didScrollBlock: ScrollBlock? {
    set {
      if let newValue = newValue { didScrollBlocks.append(newValue) }
    }
    get {
      return nil
    }
  }  
  private var didSelectBlock: ((TableCellHolder, IndexPath) -> Void)?
  private var didConfigureBlock: ((TableCellHolder, IndexPath, UITableViewCell)-> Void)?
  private var didEndDisplaying: ((TableCellHolder, IndexPath, UITableViewCell)-> Void)?
  private var willDisplay: ((TableCellHolder, IndexPath, UITableViewCell)-> Void)?
  private var didReceiveCallback: ((_ cellHolder: TableCellHolder, _ indexPath: IndexPath, _ tag: String, _ extraInfo: [String: Any]) -> Void)?
  private var didViewForHeaderInSection: ((_ section: Int, _ sectionHeaderView: UIView?) -> Void)?
  /*
   tableManager.didCellButtonPressedBlock = { [weak self] cellHolder, indexPath, tag, extraInfo in
   }
   */
  private var didCellButtonPressedBlock: ((_ cellHolder: TableCellHolder, _ indexPath: IndexPath, _ tag: String, _ extraInfo: [String: Any]) -> Void)?
  
  // MARK: Init
  init(tableView: RSTableView) {
    super.init()
    self.tableView = tableView
    setup()
  }
  
  private func setup() {
    isPullToRefreshSupported = true
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadingBlock = { [weak self] in
      self?.reload()
    }
  }
  
  private func setupLoadMore() {
    tableView.loadMoreBlock = { [weak self] in
      self?.loadMore()
    }
  }
  
  // MARK: Data Handling
  func removeAll() {
    allSections.removeAll()
  }
  
  @discardableResult func addSection() -> TableSectionHolder{
    let section = TableSectionHolder()
    allSections.append(section)
    return section
  }
  
  @discardableResult func addCell(_ obj: Any, cellClass: AnyClass, section: TableSectionHolder? = nil, atFirst: Bool = false) -> TableCellHolder {
    var targetSection = section
    if (targetSection == nil) {
      targetSection = allSections.last
    }
    if (targetSection == nil) {
      targetSection = addSection()
    }
    let cell = TableCellHolder()
    cell.obj = obj
    cell.cellClass = cellClass
    if atFirst {
      targetSection?.allCells.insert(cell, at: 0)
    } else {
      targetSection?.allCells.append(cell)
    }
    return cell
  }
  
  func getCellHolder(_ index: IndexPath) -> TableCellHolder {
    let section = allSections[(index as NSIndexPath).section]
    let cell = section.allCells[(index as NSIndexPath).row]
    return cell
  }
  
  func getIndexPath(targetCell: TableCellHolder) -> IndexPath? {
    for (sectionIndex, section) in allSections.enumerated() {
      for (cellIndex, cell) in section.allCells.enumerated() {
        if cell === targetCell {
          return IndexPath(row: cellIndex, section: sectionIndex)
        }
      }
    }
    return nil
  }
  
  func removeCellHolder(target: TableCellHolder) {
    for section in allSections {
      section.allCells = section.allCells.filter({ (cellHolder) -> Bool in
        return cellHolder != target
      })
    }
  }
  
  // MARK: Delegate / Datasources
  func isFirstCell(forIndexPath indexPath: IndexPath) -> Bool {
    if indexPath.section == 0 && indexPath.row == 0 {
      return true
    }
    return false
  }
  
  func isLastCell(forIndexPath indexPath: IndexPath) -> Bool {
    if indexPath.section == allSections.count - 1 && indexPath.row == allSections[indexPath.section].allCells.count - 1 {
      return true
    }
    return false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    var parallaxY: CGFloat = 0
    if scrollView.contentOffset.y < 0 { parallaxY = scrollView.contentOffset.y }
    if let cellView = tableView.visibleCells.first as? RSTableViewCell { cellView.layoutForParallax(y: parallaxY) }
    didScrollBlocks.forEach { $0(scrollView.contentOffset) }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return allSections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let section = allSections[section]
    return section.isCellsHidden ? 0 : section.allCells.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let section = allSections[section]
    return section.sectionHeaderView == nil ? CGFloat.leastNormalMagnitude : section.sectionHeaderHeight
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    let section = allSections[section]
    return section.sectionFooterView == nil ? CGFloat.leastNormalMagnitude : section.sectionFooterHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    didViewForHeaderInSection?(section, allSections[section].sectionHeaderView)
    return allSections[section].sectionHeaderView
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return allSections[section].sectionFooterView
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = allSections[indexPath.section]
    let cellHolder = section.allCells[indexPath.row]
    let targetCellClass = cellHolder.cellClass as! RSTableViewCell.Type
    let height = targetCellClass.height(cellHolder, width: tableView.width)
    return height
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = allSections[indexPath.section]
    let cellHolder = section.allCells[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellHolder.cellClassName) as! RSTableViewCell
    cell.manager = self
    cell.indexPath = indexPath
    cell.setContent(cellHolder, width: tableView.width)
    didConfigureBlock?(cellHolder, indexPath, cell)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    didSelectBlock?(getCellHolder(indexPath), indexPath)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    didEndDisplaying?(getCellHolder(indexPath), indexPath, cell)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    willDisplay?(getCellHolder(indexPath), indexPath, cell)
  }
  
  func cellCallback(cell: RSTableViewCell, tag: String = "", extraInfo: [String: Any] = [String: Any]()) {
    let cellHolder = getCellHolder(cell.indexPath)
    didReceiveCallback?(cellHolder, cell.indexPath, tag, extraInfo)
  }
  
  func actionCalled(cell: RSTableViewCell, tag: String = "", extraInfo: [String: Any] = [String: Any]()) {
    let cellHolder = getCellHolder(cell.indexPath)
    didCellButtonPressedBlock?(cellHolder, cell.indexPath, tag, extraInfo)
  }
  
  // MARK: Data Loading Handling
  func reload() {
    if isLoading { return }
    log(message: "Reload")
    isLoading = true
    if shouldCleanAllWhenPullToRefresh {
      removeAll()
      tableView.reloadData()
    }
    tableView.showLoadingForFirstPage()
    isLoadedAll = false
    currentPage = 1
    loadDataAtPage?(currentPage)
  }
  
  func loadMore() {
    if !isPaginationSupported { return }
    if isLoadedAll { return }
    if isLoading { return }
    isLoading = true
    log(message: "Load More \(currentPage)")
    currentPage += 1
    tableView.showLoadingForOthersPage()
    loadDataAtPage?(currentPage)
  }
  
  func finishLoading(isLoadedAll: Bool) {
    tableView.hideLoading()
    self.isLoadedAll = isLoadedAll
    tableView.reloadData()
    isLoading = false
    setupLoadMore()
  }
  
  // MARK: Misc
  func scrollToBottom(animated: Bool) {
    let lastSection = allSections.count - 1
    if lastSection < 0 { return }
    let lastRow = allSections[lastSection].allCells.count - 1
    if lastRow < 0 { return }
    let index = IndexPath(row: lastRow, section: lastSection)
    tableView?.scrollToRow(at: index, at: .bottom, animated: animated)
  }
  
  // MARK: Logging
  func log(message: String) {
    if logEnabled { print("[TableDataManager] \(message)") }
  }
  
}

// MARK: Setup Block
extension TableDataManager {
  func setDidSelectBlock(_ block: ((TableCellHolder, IndexPath) -> Void)?) {
    didSelectBlock = block
  }
  
  func setDidConfigureBlock(_ block: ((TableCellHolder, IndexPath, UITableViewCell)-> Void)?) {
    didConfigureBlock = block
  }
  
  func setDidEndDisplaying(_ block: ((TableCellHolder, IndexPath, UITableViewCell)-> Void)?) {
    didEndDisplaying = block
  }
  
  func setWillDisplay(_ block: ((TableCellHolder, IndexPath, UITableViewCell)-> Void)?) {
    willDisplay = block
  }
  
  func setDidReceiveCallback(_ block: ((_ cellHolder: TableCellHolder, _ indexPath: IndexPath, _ tag: String, _ extraInfo: [String: Any]) -> Void)?) {
    didReceiveCallback = block
  }
  
  func setDidViewForHeaderInSection(_ block: ((_ section: Int, _ sectionHeaderView: UIView?) -> Void)?) {
    didViewForHeaderInSection = block
  }

  func setDidCellButtonPressedBlock(_ block: ((_ cellHolder: TableCellHolder, _ indexPath: IndexPath, _ tag: String, _ extraInfo: [String: Any]) -> Void)?) {
    didCellButtonPressedBlock = block
  }
}

