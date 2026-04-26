//
//  ContentView.swift
//  Jahez Task
//
//  Created by Sufy on 26/04/2026.
//

import SwiftUI
import SharedUI

struct ContentView: View {

    var locator: ServiceLocator
    init(locator: ServiceLocator) {
        Self.configureAppearance()
        self.locator = locator
    }

    private static func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.brand)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.brand)]
        UINavigationBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        NavigationStack {
           MovieDetailView(viewModel: locator.makeMovieDetailViewModel(movieId: 640146))
        }
        .preferredColorScheme(.dark)
    }
}
