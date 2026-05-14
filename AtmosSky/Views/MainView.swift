//
//  MainView.swift
//  AtmosSky
//
//  Created by Arnau on 14/05/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        VStack() {
            Text(String(viewModel.latitude ?? 0))
            Text(String(viewModel.longitude ?? 0))
            
            Button {
                viewModel.refreshLocation()
            } label: {
                Text("Refresh")
            }


        }
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
}


#Preview {
    MainView()
}
