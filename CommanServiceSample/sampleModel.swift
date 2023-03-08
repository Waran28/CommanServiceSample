//
//  IndividualModelView.swift
//  sampleCommanService
//
//  Created by MacBook on 2023-03-08.
//

import Foundation
class sampleModel: ObservableObject{
    @Published var programs: [Program] = []
    
    var _service: sampleService
    @Published var docDesc = ""
    
    init (service: sampleService){
        _service = service
    }
    
    func getdate(){
         
    
        
        _service.getdata(authToken: "@aCCess$321tOKeN@987") { res in
            
            switch res {
                case .success(let data):

                self.programs = data.programs
                case .failure(_):
                     DispatchQueue.main.async {
                      Functions().alert(title: "Error", message: "Something is wrong with getlessonsModule.")
                      
                     }
               }
    }
    }
    
}
