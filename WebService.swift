//
//  WebService.swift
//  Manthan Vanani
//
//  Created by Manthan Vanani on 28/02/21.
//

import Foundation
import Alamofire

struct FileUploadStructure{
    var fileName : String? = UUID().uuidString
    var fileData : Data?
    var fileURL : String?
    var uuid : String?
    var MimeType : String?
    var key : String
}

class WebService : NSObject{
    
    static let shared : WebService = WebService()
    
    override init() {
        super.init()
    }
    
    func getAPI(url : String, result : @escaping(Data?, Error?)->Void){
        guard let url = URL(string: url) else { return }
        print("URL : ", url)
        AF.request(url, method: .get, headers: HTTPHeaders([String : String]())).response { response in
            result(response.data, response.error)
        }
    }
    
    func postAPI(url : String, parameters : [String:Any]?, result : @escaping(Data?, Error?)->Void){
        guard let url = URL(string: url) else { return }
        print("------------------------")
        print("URL", url)
        print("Parameters", parameters)
        AF.request(url, method: .post, parameters: parameters, headers: HTTPHeaders([String : String]())).response { response in
            result(response.data, response.error)
        }
    }
    
    func putAPI(url : String, parameters : [String:Any]?, result : @escaping(Data?, Error?)->Void){
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .put, parameters: parameters, headers: HTTPHeaders([String : String]())).response { response in
            result(response.data, response.error)
        }
    }
    
    func postAPIMultiPart(url : String, parameters : [String:Any]?, files : [FileUploadStructure]?, result : @escaping(Data?, Error?)->Void){
        guard let url = URL(string: url) else { return }
        
        AF.upload(multipartFormData: { multipart in
            if let files = files {
                files.forEach { file in
                    if let filename = file.fileName, let fileURL = file.fileURL, let mimeType = file.MimeType{
                        if let url = URL(string: fileURL){
                            do{
                                let data = try Data(contentsOf: url)
                                let key = file.key
                                multipart.append(data, withName: key, fileName: filename, mimeType: mimeType)
                            }catch let error{
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                if let parameters = parameters{
                    parameters.forEach { (key,value) in
                        if let value = (value as? String)?.data(using: String.Encoding.utf8){
                            multipart.append(value, withName: key, fileName: nil, mimeType: nil)
                        }
                    }
                }
            }
        }, to: url, method: .post, headers: nil).response { response in
            result(response.data, response.error)
        }
    }
    
    func putAPIMultiPart(url : String, parameters : [String:Any]?, files : [FileUploadStructure]?, result : @escaping(Data?, Error?)->Void){
        guard let url = URL(string: url) else { return }
        print(files, parameters)
        AF.upload(multipartFormData: { multipart in
            if let files = files {
                files.forEach { file in
                    if let filename = file.fileName, let fileURL = file.fileURL, let mimeType = file.MimeType{
                        if let url = URL(string: fileURL){
                            do{
                                let data = try Data(contentsOf: url)
                                let key = file.key
                                multipart.append(data, withName: key, fileName: filename, mimeType: mimeType)
                            }catch let error{
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                if let parameters = parameters{
                    parameters.forEach { (key,value) in
                        if let value = (value as? String)?.data(using: String.Encoding.utf8){
                            multipart.append(value, withName: key, fileName: nil, mimeType: nil)
                        }
                    }
                }
            }
        }, to: url, method: .post, headers: nil).response { response in
            result(response.data, response.error)
        }
    }
    
}


extension WebService : URLSessionDataDelegate{
    
}
