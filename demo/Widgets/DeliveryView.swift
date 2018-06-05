import UIKit

class DeliveryView: UIView {
  lazy var deliveryThingImageView = UIImageView()
  lazy var deliveryTaskLabel = UILabel()
  let padding = Pad.small
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    borderWidth = 1
    borderColor = UIColor.gray
    deliveryTaskLabel.numberOfLines = 0
    deliveryThingImageView.contentMode = .scaleAspectFit
    deliveryThingImageView.backgroundColor = UIColor.blue
    
    addSubview(deliveryThingImageView)
    addSubview(deliveryTaskLabel)
    deliveryTaskLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalToSuperview().offset(-padding)
      make.leading.equalTo(deliveryThingImageView.snp.trailing).offset(padding)
      
    }
    
    deliveryThingImageView.snp.makeConstraints { (make) in
      make.top.leading.equalToSuperview()
      make.height.equalTo(64)
      make.width.equalTo(64)
      make.bottom.lessThanOrEqualToSuperview()
    }
  }
  
  func setContent(delivery: Delivery) {
    deliveryTaskLabel.text = delivery.descriptions
    deliveryThingImageView.kf.setImage(with: URL(string: delivery.imageUrl))
  }
}
