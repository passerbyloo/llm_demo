import UIKit

class DeliveryTableViewCell: RSTableViewCell {
  lazy var deliveryView = DeliveryView()
  let padding = Pad.small
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  func setupUI() {
    selectionStyle = .none
    contentView.addSubview(deliveryView)
    deliveryView.snp.makeConstraints { (make) in
      make.top.leading.equalToSuperview().offset(padding)
      make.trailing.equalToSuperview().offset(-padding)
      make.bottom.equalToSuperview()
    }
  }
  
  override func setContent(_ cellHolder: TableCellHolder, width: CGFloat) {
    guard let delivery = cellHolder.obj as? Delivery else { return }
    deliveryView.setContent(delivery: delivery)
  }

}
