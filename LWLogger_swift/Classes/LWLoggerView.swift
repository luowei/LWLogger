//
//  LWLoggerView.swift
//  LWLogger
//
//  SwiftUI view for demonstrating LWLogger usage
//

#if canImport(SwiftUI)
import SwiftUI
import CocoaLumberjack

/// A SwiftUI view that demonstrates the LWLogger functionality
@available(iOS 13.0, *)
public struct LWLoggerView: View {
    @State private var logMessage: String = ""
    @State private var zipPath: String = ""
    @State private var showingShareSheet = false

    public init() {}

    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("LWLogger Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Input field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Log Message:")
                        .font(.headline)
                    TextField("Type your message...", text: $logMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding()

                // Logging buttons
                VStack(spacing: 12) {
                    Button(action: {
                        LWLogVerbose(logMessage.isEmpty ? "Verbose log message" : logMessage)
                    }) {
                        LogButtonLabel(title: "Log Verbose", color: .gray)
                    }

                    Button(action: {
                        LWLogDebug(logMessage.isEmpty ? "Debug log message" : logMessage)
                    }) {
                        LogButtonLabel(title: "Log Debug", color: .blue)
                    }

                    Button(action: {
                        LWLogInfo(logMessage.isEmpty ? "Info log message" : logMessage)
                    }) {
                        LogButtonLabel(title: "Log Info", color: .green)
                    }

                    Button(action: {
                        LWLogWarn(logMessage.isEmpty ? "Warning log message" : logMessage)
                    }) {
                        LogButtonLabel(title: "Log Warning", color: .orange)
                    }

                    Button(action: {
                        LWLogError(logMessage.isEmpty ? "Error log message" : logMessage)
                    }) {
                        LogButtonLabel(title: "Log Error", color: .red)
                    }
                }
                .padding()

                Divider()

                // Export logs button
                Button(action: {
                    zipPath = LWLogUtil.logZipPath()
                    showingShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "arrow.down.doc.fill")
                        Text("Export Logs")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                if !zipPath.isEmpty {
                    Text("Zip created at:\n\(zipPath)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showingShareSheet) {
                if #available(iOS 14.0, *) {
                    ShareSheet(activityItems: [URL(fileURLWithPath: zipPath)])
                }
            }
        }
    }
}

/// Custom button label for log buttons
@available(iOS 13.0, *)
struct LogButtonLabel: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.body)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(8)
    }
}

/// UIKit share sheet wrapper for SwiftUI
@available(iOS 13.0, *)
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

@available(iOS 13.0, *)
struct LWLoggerView_Previews: PreviewProvider {
    static var previews: some View {
        LWLoggerView()
    }
}

#endif
