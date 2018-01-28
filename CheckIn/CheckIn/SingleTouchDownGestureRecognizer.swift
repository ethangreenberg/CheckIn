import UIKit.UIGestureRecognizerSubclass

class SingleTouchDownGestureRecognizer: UITapGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            print("aaa")
        } else {
            print("bbb")
        }
    }
}
