//
//  sampleView.swift
//  CommanServiceSample
//
//  Created by MacBook on 2023-03-08.
//


import SwiftUI

struct sampleView: View {
    @EnvironmentObject var user: sampleModel
    @ObservedObject var viewModel = sampleModel(service: IndividualService())
    @Environment(\.presentationMode) var presentationMode
    init( ){
       
       
//        self.viewModel = individualModelView
//        viewModel.showLoad.toggle()
        viewModel.getdate()
        
     
    }
    
    
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.onReceive(viewModel.$programs ,perform: { obj in
           print(obj)
        })
        
        
    }
}

//struct IndividualUiView_Previews: PreviewProvider {
//    static var previews: some View {
//        IndividualUiView()
//    }
//}
