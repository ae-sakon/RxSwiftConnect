
import Foundation
import RxSwift
import RxCocoa
import RxSwiftConnect

class APISearch {
    static var shared = APISearch()
    let beseUrl =  "http://search.megazy.com"
    private let requester:Requester
    typealias E = CustomError; typealias O = Observable; typealias R = Result
    private func setHeader(_ token:String = "")->[String:String]?{
        let s  = Bundle.main.bundleIdentifier!
        return token.count == 0 ? ["Signature":s] : ["Signature":s,"Authorize": token]
    }
    
    private init() {
        
        requester = Requester(initBaseUrl: beseUrl,timeout: 5, isPreventPinning: false, initSessionConfig: URLSessionConfiguration.default)
    }
    func searchQuery(postData:QuerySearch)-> O<R<SearchResult,E>> {
        return requester.get(path: "JertamQueryAPI/jt/queryloc", sendParameter: postData,loading: false)
    }
    
}
