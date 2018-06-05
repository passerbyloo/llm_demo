import UIKit
import GoogleMaps
import SnapKit

class DeliveryDetailViewController: BaseViewController {
  lazy var scrollView = UIScrollView()
  lazy var deliveryView = DeliveryView()
  lazy var mapView = GMSMapView()
  var mapManager: MapManager!
  var delivery: Delivery!
  
  init(delivery: Delivery) {
    self.delivery = delivery
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setContent()
  }
  
  private func setupUI() {
    title = "Delivery Details"
    view.backgroundColor = UIColor.white
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.edges.equalTo(self.view.safeAreaLayoutGuide)
      } else {
        make.edges.equalToSuperview()
      }
    }
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    scrollView.addSubview(stackView)
    stackView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(scrollView)
      make.leading.trailing.equalTo(view)
    }
    
    mapView.snp.makeConstraints { (make) in
      make.height.equalTo(view.height / 2)
    }
    stackView.addArrangedSubview(mapView)
    
    let wrapView = UIView()
    wrapView.addSubview(deliveryView)
    deliveryView.snp.makeConstraints { (make) in
      make.top.leading.equalToSuperview().offset(Pad.small)
      make.trailing.equalToSuperview().offset(-Pad.small)
      make.bottom.equalToSuperview()
    }
    stackView.addArrangedSubview(wrapView)
  }
  
  private func setContent() {
    LocationManager.shared.requestAuthorization()
    deliveryView.setContent(delivery: delivery)
    mapManager = MapManager(baseView: mapView)
    mapManager.addMarker(location: delivery.location.coordinate, icon: nil, title: delivery.location.address)
    mapManager.showLocation(coordinate: delivery.location.coordinate)
  }
}
