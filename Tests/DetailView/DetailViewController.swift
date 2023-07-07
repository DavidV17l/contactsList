import UIKit

protocol IDetailViewDisplayLogic: AnyObject {}

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IDetailViewDisplayLogic {
    
    // MARK: - Variables
    var interactor: IDetailViewBusinessLogic?
    var router: (NSObjectProtocol & IDetailViewRoutingLogic & IDetailViewDataPassing)?
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var selectedContact: Contact!
    var selectedSection: Section?
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameLabel.text = selectedContact.name
        numberLabel.text = selectedContact.number
        mailLabel.text = selectedContact.email
        profileImage.image = selectedContact.profileImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImage.layer.cornerRadius = profileImage.bounds.width/2
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        self.imagePickerButton.layer.cornerRadius = 5
    }
    
    // MARK: - Profile Picture Logic
    @IBAction func imagePickerClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: nil)
        profileImage.image = image
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "Error in the camera app", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        profileImage.image = image
        selectedContact.profileImage = image
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Call/Email Logic
    @IBAction func callButtonPressed(_ sender: Any) {
        callNumber(phoneNumber: numberLabel.text!)
    }
    
    @IBAction func mailButtonPressed(_ sender: Any) {
        sendMail(mailAddress: mailLabel.text!)
    }
    
    private func callNumber(phoneNumber:String) {
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    private func sendMail(mailAddress: String) {
        let mail = ("mailto:" + mailAddress)
        let mailtoUrl = URL(string: mail)!
        if UIApplication.shared.canOpenURL(mailtoUrl) {
            UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
}
