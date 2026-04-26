import SwiftUI
import SharedUI

struct MovieDiscoverView: View {
    @ObservedObject var viewModel: MovieDiscoverViewModel
    let detailViewModelFactory: (Int) -> MovieDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GenreFilterView(viewModel: viewModel.genreFilter)
            MovieListView(viewModel: viewModel.movieList)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .searchable(
            text: Binding(
                get: { viewModel.movieList.searchText },
                set: { viewModel.movieList.searchText = $0 }
            ),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search TMDB"
        )
        .onAppear { viewModel.load() }
        .navigationTitle("Watch New Movies")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: Int.self) { movieId in
            MovieDetailView(viewModel: detailViewModelFactory(movieId))
        }
    }
}
