//
//  GoalsWidgetLiveActivity.swift
//  GoalsWidget
//
//  Created by Andrew on 6/6/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GoalsWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GoalsWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GoalsWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GoalsWidgetAttributes {
    fileprivate static var preview: GoalsWidgetAttributes {
        GoalsWidgetAttributes(name: "World")
    }
}

extension GoalsWidgetAttributes.ContentState {
    fileprivate static var smiley: GoalsWidgetAttributes.ContentState {
        GoalsWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GoalsWidgetAttributes.ContentState {
         GoalsWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GoalsWidgetAttributes.preview) {
   GoalsWidgetLiveActivity()
} contentStates: {
    GoalsWidgetAttributes.ContentState.smiley
    GoalsWidgetAttributes.ContentState.starEyes
}
