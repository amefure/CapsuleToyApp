//
//  AppError.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/09.
//

protocol AppError: Error {
    var title: String { get }
    var message: String { get }
}
