import UIKit

protocol IDetailViewDisplayLogic: AnyObject {
    func buttonPressedCell(_ sender: UIButton)
    func callNumber(phoneNumber: String)
    func sendMail(mailAddress: String)
}

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, IDetailViewDisplayLogic, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    var interactor: IDetailViewBusinessLogic?
    var router: (NSObjectProtocol & IDetailViewRoutingLogic & IDetailViewDataPassing)?
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var imagePicker = UIImagePickerController()
    
    var selectedContact: Contact?
    var selectedSection: Section?
    
    var tableDetailCells: [Int] = [1, 2, 3, 4]
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView?.delegate = self
        detailTableView?.dataSource = self
        detailTableView?.register(DetailCell1.nib, forCellReuseIdentifier: DetailCell1.identifier)
        detailTableView?.register(DetailCell2.nib, forCellReuseIdentifier: DetailCell2.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let findType = tableDetailCells[indexPath.row]
        switch findType {
        case 1: if let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell1.identifier) as? DetailCell1 {
            cell.profileImage.image = selectedContact?.profileImage
            cell.delegate = self
            return cell
        }
        case 2: if let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell2.identifier) as? DetailCell2 {
            cell.label.text = selectedContact?.name
            cell.button.isHidden = true
            cell.delegate = self
            return cell
        }
        case 3: if let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell2.identifier) as? DetailCell2 {
            cell.label.text = selectedContact?.email
            cell.labelTitle.text = NSLocalizedString("Email", comment: "")
            cell.button.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
            cell.delegate = self
            return cell
        }
        case 4: if let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell2.identifier) as? DetailCell2 {
            cell.label.text = selectedContact?.number
            cell.labelTitle.text = NSLocalizedString("Number", comment: "")
            cell.button.setTitle(NSLocalizedString("Call", comment: ""), for: .normal)
            cell.delegate = self
            return cell
        }
        default: break }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let findHeight = tableDetailCells[indexPath.row]
        switch findHeight {
        case 1:
            return 120
        case 2, 3, 4:
            return 100
        default:
            return 70
        }
    }
    
    // MARK: - Profile Picture Logic
    func buttonPressedCell(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Take", comment: ""), style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Choose", comment: ""), style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
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
        selectedContact?.profileImage = image
        detailTableView.reloadData()
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Error", comment: "ErrorString"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OkayString"), style: .default, handler: nil))
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
        selectedContact?.profileImage = image
        detailTableView.reloadData()
        self.dismiss(animated: true)
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
    internal func callNumber(phoneNumber:String) {
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    internal func sendMail(mailAddress: String) {
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
