//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 40)
        label.text = "Hello World!"
        label.textColor = .black
        label.backgroundColor = .red
        label.layer.cornerRadius = 20
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5

        view.addSubview(label)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
