import UIKit
import SnapKit

class DeliveryListViewController: BaseViewController {
  lazy var tableView = RSTableView()
  var tableManager: TableDataManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Delivery List"
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.edges.equalTo(self.view.safeAreaLayoutGuide)
      } else {
        make.edges.equalToSuperview()
      }
    }
    
    tableView.registerClassCell(aClass: DeliveryTableViewCell.self)
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Pad.small, right: 0)
    tableManager = TableDataManager(tableView: tableView)
    tableManager.isPullToRefreshSupported = false
    tableManager.loadDataAtPage = { [weak self] page in
      guard let `self` = self else { return }
      self.loadData()
    }
    tableManager.setDidSelectBlock { [unowned self] (cellHolder, indexPath) in
      if let delivery = cellHolder.obj as? Delivery {
        let vc = DeliveryDetailViewController(delivery: delivery)
        self.push(vc)
      }
    }
    tableManager.reload()
  }
  
  private func loadData() {
    DataRepository.shared.getDeliveries { (deliveries, error) in
      if let error = error {
        let deliveryManagedObjects = DatabaseManager.getDeliveries()
        if deliveryManagedObjects.isEmpty {
          self.showAlert(text: error.localizedDescription) {
            self.tableManager.reload()
          }
          self.tableManager.finishLoading(isLoadedAll: true)
        }
        else {
          let deliveries = Delivery.parse(deliveryManagedObjects: deliveryManagedObjects)
          self.bindData(results: deliveries)
        }
        return
      }
      DatabaseManager.deleteAllApps()
      DatabaseManager.add(deliveries: deliveries)
      self.bindData(results: deliveries)
    }
  }
  
  private func bindData(results: [Delivery]) {
    for delivery in results {
      tableManager.addCell(delivery, cellClass: DeliveryTableViewCell.self)
    }
    tableManager.finishLoading(isLoadedAll: true)
  }
}
