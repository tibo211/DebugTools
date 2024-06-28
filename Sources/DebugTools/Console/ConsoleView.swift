//
//  ConsoleView.swift
//  
//
//  Created by Tibor Felföldy on 2024-05-01.
//

import SwiftUI

public struct ConsoleView<CustomView: View>: View {
    @ObservedObject private var store: LogStore
    private var customLogView: (any PresentableLog) -> CustomView
    @Environment(\.dismiss) private var dismiss
    
    public init(store: LogStore,
                @ViewBuilder customLogView: @escaping (any PresentableLog) -> CustomView = { _ in EmptyView() }) {
        self.store = store
        self.customLogView = customLogView
    }
    
    public var body: some View {
        NavigationView {
            AutoScrollView(store: store) {
                LazyVStack(spacing: 0) {
                    ForEach(store.filterredLogs, id: \.id) { log in
                        if let entry = log as? LogEntry {
                            LogEntryView(log: entry)
                        } else {
                            customLogView(log)
                        }
                    }
                }
            }
            .navigationTitle("Console")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark.circle") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            DebugTools.isConsolePresented = true
        }
        .onDisappear {
            DebugTools.isConsolePresented = false
        }
    }
}
