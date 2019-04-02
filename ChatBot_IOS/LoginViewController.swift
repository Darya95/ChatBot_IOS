import UIKit
import Kommunicate

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    //@IBOutlet weak var loginAsVisitorButton: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // To avoid scrolling up multiple times when a different text field is active.
    var isKeyboardVisible = false
    var originalContentInset: UIEdgeInsets = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getStartedBtn(_ sender: AnyObject) {
        resignFields()
        let applicationId = AppDelegate.appId
        setupApplicationKey(applicationId)

        guard let userIdEntered = userName.text, !userIdEntered.isEmpty else {
            let alertMessage = "Please enter a userId. If you are trying the app for the first time then just enter a random Id"
            let alert = UIAlertController(
                title: "Kommunicate login",
                message: alertMessage,
                preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let kmUser = userWithUserId(userIdEntered, andApplicationId: applicationId)

        print("userId:: ", kmUser.userId)

        if (!((password.text?.isEmpty)!)){
            kmUser.password = password.text
        }
        registerUser(kmUser)
    }
/*
    @IBAction func loginAsVisitor(_ sender: Any) {
        resignFields()
        let applicationId = AppDelegate.appId
        setupApplicationKey(applicationId)

        let kmUser = userWithUserId(Kommunicate.randomId(), andApplicationId: applicationId)
        registerUser(kmUser)
    }
*/
    @objc func keyboardWillHide(notification: NSNotification) {

        guard isKeyboardVisible,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
        isKeyboardVisible = false
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState], animations: {
            self.scrollView.contentInset = self.originalContentInset
            self.scrollView.scrollIndicatorInsets = self.originalContentInset
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        var inset = scrollView.contentInset
        originalContentInset = inset

        // This will convert the rect. w.r.t to the current view.
        let converted = self.view.convert(frame, from: nil)
        let intersection = converted.intersection(frame)
        // This will give us the value of how much to move up.
        var bottomInset = intersection.height
        if #available(iOS 11.0, *) {
             bottomInset = bottomInset - self.view.safeAreaInsets.bottom
        }

        inset.bottom = bottomInset
        guard !isKeyboardVisible else { return }
        isKeyboardVisible = true
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState], animations: {
            self.scrollView.contentInset = inset
            self.scrollView.scrollIndicatorInsets = inset
            self.scrollView.contentOffset = CGPoint(x: 0, y: bottomInset - 60)
        })
    }

    private func setupApplicationKey(_ applicationId: String) {
        guard !applicationId.isEmpty else {
            fatalError("Please pass your AppId in the AppDelegate file.")
        }
        Kommunicate.setup(applicationId: applicationId)
    }

    private func userWithUserId(
        _ userId: String,
        andApplicationId applicationId: String) -> KMUser {
        let kmUser = KMUser()
        kmUser.userId = userId
        kmUser.applicationId = applicationId
        return kmUser
    }

    private func registerUser(_ kmUser: KMUser) {
        activityIndicator.startAnimating()
        Kommunicate.registerUser(kmUser, completion: {
            response, error in
            self.activityIndicator.stopAnimating()
            guard error == nil else {
                print("[REGISTRATION] Kommunicate user registration error: %@", error.debugDescription)
                return
            }
            print("User registration was successful: %@ \(String(describing: response?.isRegisteredSuccessfully()))")
            if let viewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "NavViewController") as? UINavigationController {
                self.present(viewController, animated:true, completion: nil)
            }
        })
    }

    private func resignFields() {
        
        userName.resignFirstResponder()
        //emailId.resignFirstResponder()
        password.resignFirstResponder()
 
    }
}
