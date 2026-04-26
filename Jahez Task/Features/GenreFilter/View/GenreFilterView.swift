import SwiftUI
import SharedUI

struct GenreFilterView: View {
    @ObservedObject var viewModel: GenreFilterViewModel

    var body: some View {
        if !viewModel.genres.isEmpty {
            FilterBar(
                items: viewModel.genres.toFilterBarItems(),
                selectedId: viewModel.selectedGenreId,
                onSelect: viewModel.selectGenre
            )
            Divider()
        }
    }
}
