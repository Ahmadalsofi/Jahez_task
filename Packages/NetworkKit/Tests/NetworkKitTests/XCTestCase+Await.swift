import XCTest
import Combine

extension XCTestCase {

    func waitForValue<T, E: Error>(
        _ publisher: AnyPublisher<T, E>,
        timeout: TimeInterval = 1
    ) -> T? {
        var received: T?
        let expectation = expectation(description: "value received")
        let cancellable = publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: {
                received = $0
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        return received
    }

    func waitForError<T, E: Error>(
        _ publisher: AnyPublisher<T, E>,
        timeout: TimeInterval = 1
    ) -> E? {
        var received: E?
        let expectation = expectation(description: "error received")
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    received = error
                    expectation.fulfill()
                }
            },
            receiveValue: { _ in }
        )
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        return received
    }
}
