import UIKit
import Kommunicate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func launchConversation(_ sender: Any) {
        Kommunicate.createAndShowConversation(from: self, completion: {
            error in
            if error != nil {
                print("Error while launching")
            }
        })
    }
    @IBAction func logoutAction(_ sender: Any) {
        Kommunicate.logoutUser()
        self.dismiss(animated: false, completion: nil)
    }
}
