import UIKit

class BaseViewController: UIViewController {

  
  deinit {
    log("*****Life Cycle***** deinit🌑")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    automaticallyAdjustsScrollViewInsets = false
    log("*****Life Cycle***** viewDidLoad🌘")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    log("*****Life Cycle***** viewWillAppear🌕")
    UIApplication.shared.statusBarStyle = .lightContent
  
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    log("*****Life Cycle***** viewWillDisappear🌒")
    hideKb()
    NotificationCenter.default.removeObserver(self)
  }
  
  @IBAction func push(_ vc: UIViewController) {
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func back() {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func dismiss() {
    dismiss(animated: true, completion: nil)
  }
  
  func log(_ message: String) {
    let string = "[\(NSStringFromClass(type(of: self)))] \(message)"
    LogManager.info(string)
  }
  
  func showBlockLoading() {
  }
  
  func hideBlockLoading() {

  }
  
  func showAlert(text: String, handler: (() -> Void)? = nil) {
    let alert = UIAlertController(title: "demo", message: text, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
      handler?()
    })
    present(alert, animated: true, completion: nil)
  }
  
  func hideKb() {
    view.endEditing(true)
  }
}
