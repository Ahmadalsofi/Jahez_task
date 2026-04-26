import SwiftUI
import SharedUI
import AppService

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        StateView(state: viewModel.state, retryAction: viewModel.reload) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(value: movie.id) {
                            MediaCard(
                                imageURL: movie.posterURL,
                                title: movie.title,
                                subtitle: movie.releaseDate
                            )
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            if movie.id == viewModel.movies.last?.id {
                                viewModel.loadNextPage()
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)

                if viewModel.isLoadingMore {
                    ProgressView().padding()
                }
            }
        }
    }
}
