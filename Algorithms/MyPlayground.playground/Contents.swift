import UIKit
import XCPlayground

var str0 = "Hello, playground"
var genres = [
    "conscious hip hop",
    "nc hip hop",
    "pop rap",
    "rap"
]

for x in genres{
    print(x)
    if(genres.contains(x)){
        print("*")
    }
}

var str = "Hello, playground"

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
XCPShowView(identifier: "Container View", view: containerView)




let rectangle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
rectangle.center = containerView.center
rectangle.layer.cornerRadius = 5.0




let tf:UITextField = UITextField(frame: containerView.bounds)
tf.textColor = UIColor.white;
tf.text = "this is text"
tf.textAlignment = NSTextAlignment.center;

let gradientMaskLayer:CAGradientLayer = CAGradientLayer()
gradientMaskLayer.frame = containerView.bounds
gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor, UIColor.red.cgColor, UIColor.clear.cgColor ]
gradientMaskLayer.startPoint = CGPoint(x: 0.1, y: 0.0)
gradientMaskLayer.endPoint = CGPoint(x: 0.55, y: 0.0)

containerView.addSubview(tf)

tf.layer.mask = gradientMaskLayer;
//containerView.layer.insertSublayer(gradientMaskLayer, atIndex: 0);
