//
//  HomePage.swift
//  MSConnectionLib
//
//  Created by Moha on 8/31/24.
//

import SwiftUI

struct PostPage: View {
    @StateObject private var viewModel = PostViewModel()

    var body: some View {
        VStack {
            if viewModel.data.isEmpty && viewModel.errorMessages.isEmpty {
                Text("Loading...")
            } else if !viewModel.errorMessages.isEmpty {
                List(viewModel.errorMessages, id: \.self) { errorMessage in
                    Text(errorMessage).foregroundColor(.red)
                }
            } else {
                List(viewModel.data) { model in
                    VStack(alignment: .leading) {
                        Text(model.title)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    PostPage()
}
