//
//  TaskViewModel.swift
//  TMDB_Movies
//
//  Created by KsArT on 24.08.2024.
//

import Foundation

open class TaskViewModel {

    public typealias WorkTaskAsync = (() async -> Void)
    private typealias WorkTask = Task<Void, Never>

    private var tasks: [String: WorkTask] = [:]
    private let taskLock = NSLock() // Добавляем блокировку для потокобезопасности

    private var taskNext = 0
    private var taskNameNext: String {
        taskLock.withLock {
            let name = "noName\(taskNext)"
            taskNext += 1
            return name
        }
    }

    // MARK: - Запуск асинхронной задачи
    // Запуск асинхронной задачи с именем, отменой предыдущего задания
    final func launch(named taskName: String, _ operation: @escaping @Sendable WorkTaskAsync) {
        // Отмена предыдущей задачи с таким же именем
        cancelTask(named: taskName)

        // Запуск новой задачи
        let task = startTask(named: taskName, operation: operation)

        // Добавление новой задачи в словарь
        addTask(named: taskName, task: task)
    }

    // Запуск асинхронной задачи без отмены предыдущего задания
    final func launch(_ operation: @escaping @Sendable WorkTaskAsync) {
        launch(named: taskNameNext, operation)
    }

    // Отмена всех задач
    open func onCleared() {
        cancelAllTasks()
    }

    // MARK: - Приватные методы
    // Запуск задачи
    private func startTask(named taskName: String, operation: @escaping @Sendable WorkTaskAsync) -> WorkTask {
        Task { [weak self] in
            await operation()
            self?.removeTask(named: taskName)
        }
    }

    // Добавление задачи с именем
    private func addTask(named taskName: String, task: WorkTask) {
        taskLock.withLock {
            tasks[taskName] = task
        }
    }

    // Удаление задачи по имени
    private func removeTask(named taskName: String) {
        taskLock.withLock {
            _ = tasks.removeValue(forKey: taskName)
        }
    }

    // Отмена предыдущей задачи с таким же именем, если она существует
    private func cancelTask(named taskName: String) {
        taskLock.withLock {
            tasks[taskName]?.cancel()
            tasks.removeValue(forKey: taskName)
        }
    }

    // Отмена всех задач
    private func cancelAllTasks() {
        taskLock.withLock {
            guard !tasks.isEmpty else { return }

            for task in tasks.values {
                task.cancel()
            }
            tasks.removeAll()
        }
    }

    // MARK: - Деинициализация ViewModel
    // Отмена всех задач при деинициализации ViewModel
    deinit {
        onCleared()
    }
}

// MARK: - Пример запуска задачи
/*
func loadData() {
    launch {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        print("Data loaded")
    }
}
*/
