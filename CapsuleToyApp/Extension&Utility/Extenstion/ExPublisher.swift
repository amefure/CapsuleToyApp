//
//  ExPublisher.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/30.
//

import Combine

extension Publisher {
    /// `receiveValue`を省略できる`sink`
    func sink(receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void)) -> AnyCancellable {
        self.sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }
}

typealias DeferredFuture<Output, Failure: Error> = Deferred<Future<Output, Failure>>

/// `Future`を`Deferred`でラップ
/// `Future`はインスタンスか時点で値が流れてしまうため`Deferred`でラップして購読時に値が流れるようにする
func deferredFuture<Output, Failure>(
    _ attemptToFulfill: @escaping (@escaping Future<Output, Failure>.Promise) -> Void
) -> DeferredFuture<Output, Failure> {
    Deferred { Future(attemptToFulfill) }
}
