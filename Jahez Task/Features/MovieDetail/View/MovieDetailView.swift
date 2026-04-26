import SwiftUI
import AppService
import SharedUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        StateView(state: viewModel.state, retryAction: viewModel.reload) {
            if let detail = viewModel.state.value {
                detailContent(detail)
            }
        }
        .onAppear { viewModel.load() }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Content

private extension MovieDetailView {
    func detailContent(_ detail: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                hero(detail)
                info(detail)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Hero

private extension MovieDetailView {
    func hero(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            BackdropImage(url: detail.backdropURL)
            poster(detail)
        }
    }

    func poster(_ detail: MovieDetail) -> some View {
        HStack(alignment: .bottom, spacing: 14) {
            PosterImage(url: detail.posterURL)
            titleGenres(detail)
        }
        .padding(16)
    }

    func titleGenres(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            TextLabel(detail.title, style: .title)
                .lineLimit(3)
            if !detail.genresDisplay.isEmpty {
                TextLabel(detail.genresDisplay, style: .caption)
            }
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Info

private extension MovieDetailView {
    func info(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            overview(detail.overview)
            stats(detail)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }

    @ViewBuilder
    func overview(_ text: String) -> some View {
        if !text.isEmpty {
            TextLabel(text, style: .body)
        }
    }

    func stats(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let homepage = detail.homepage, !homepage.isEmpty {
                InfoCard(title: "Homepage", value: homepage, isLink: true)
            }
            InfoCard(title: "Languages", value: detail.spokenLanguagesDisplay)
            InfoCard(title: "Status",    value: detail.status)
            InfoCard(title: "Budget",    value: detail.formattedBudget)
            InfoCard(title: "Runtime",   value: detail.formattedRuntime)
            InfoCard(title: "Revenue",   value: detail.formattedRevenue)
        }
    }
}
