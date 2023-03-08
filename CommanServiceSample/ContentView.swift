//
//  ContentView.swift
//  CommanServiceSample
//
//  Created by MacBook on 2023-03-08.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = sampleModel(service: IndividualService())
//    @State var show = false
   
    
    var body: some View {
        ZStack{
            VStack {
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                    .onTapGesture {
                        viewModel.getdate()
                    }
            }
            .padding()
            .onReceive(viewModel.$programs ,perform: { obj in
               print("================\(obj)")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
