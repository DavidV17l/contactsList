import UIKit
import Alamofire

protocol IClientBusinessLogic {
    func initializeClient()
}

protocol IClientDataStore {}

class ClientInteractor: IClientBusinessLogic, IClientDataStore {
    weak var viewController: IClientDisplayLogic?
    
    let url: String = "https://cat-fact.herokuapp.com/facts/"
    
    init (viewController: IClientDisplayLogic?) {
        self.viewController = viewController
    }
    
    internal func initializeClient() {
        AF.request(url, method: .get)
            .responseDecodable(of: [CatFact].self, queue: .main, decoder: JSONDecoder()) { response in
                switch response.result {
                case let .success(data):
                    self.viewController?.factsList.append(contentsOf: data)
                    self.viewController?.initCompleted()
                case let .failure(error):
                    print(error)
                }
            }
    }
}
