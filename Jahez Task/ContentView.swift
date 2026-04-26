import SwiftUI
import SharedUI

struct ContentView: View {
    
    @StateObject private var movieDiscoverVM: MovieDiscoverViewModel
    private let makeDetailViewModel: (Int) -> MovieDetailViewModel
    
    init(locator: ServiceLocator) {
        _movieDiscoverVM = StateObject(wrappedValue: locator.makeMovieDiscoverViewModel())
        makeDetailViewModel = { locator.makeMovieDetailViewModel(movieId: $0) }
        Self.configureAppearance()
    }
    
    private static func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.brand)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.brand)]
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            MovieDiscoverView(
                viewModel: movieDiscoverVM,
                detailViewModelFactory: makeDetailViewModel
            )
        }
        .preferredColorScheme(.dark)
    }
}
