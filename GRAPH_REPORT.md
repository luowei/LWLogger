# Graph Report - /Users/luowei/projects/libs/LWLogger  (2026-05-04)

## Corpus Check
- Corpus is ~8,400 words - fits in a single context window. You may not need a graph.

## Summary
- 86 nodes · 102 edges · 9 communities detected
- Extraction: 75% EXTRACTED · 25% INFERRED · 0% AMBIGUOUS · INFERRED: 26 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]

## God Nodes (most connected - your core abstractions)
1. `LWLogUtil` - 11 edges
2. `LWLoggerExample` - 9 edges
3. `LWLogInfo()` - 9 edges
4. `LWLog()` - 7 edges
5. `LWAppDelegate` - 7 edges
6. `LWLogError()` - 6 edges
7. `ExampleAppDelegate` - 5 edges
8. `LWLogUtil` - 5 edges
9. `LWJSONLogFormatter` - 4 edges
10. `ShareSheet` - 4 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities (14 total, 2 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.18
Nodes (7): App, LWLog(), ExampleApp, ExampleAppDelegate, LWLoggerExample, UIApplicationDelegate, UIResponder

### Community 1 - "Community 1"
Cohesion: 0.27
Nodes (5): LWLogDebug(), LWLogError(), LWLogInfo(), LWLogVerbose(), LWLogWarn()

### Community 3 - "Community 3"
Cohesion: 0.18
Nodes (7): DDLogFlag, Logged, LWJSONLogFormatter, LWLogUtil, -initLogConfig, DDLogFormatter, NSObject

### Community 4 - "Community 4"
Cohesion: 0.2
Nodes (7): LogButtonLabel, LWLoggerView, LWLoggerView_Previews, ShareSheet, PreviewProvider, UIViewControllerRepresentable, View

### Community 5 - "Community 5"
Cohesion: 0.25
Nodes (7): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 6 - "Community 6"
Cohesion: 0.4
Nodes (4): Tests, -setUp, -tearDown, -testExample

### Community 7 - "Community 7"
Cohesion: 0.4
Nodes (4): LWViewController, -logSend, -shareWithFilePath, -viewDidLoad

## Knowledge Gaps
- **14 isolated node(s):** `DDLogFlag`, `-initLogConfig`, `-setUp`, `-tearDown`, `-testExample` (+9 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LWLogUtil` connect `Community 2` to `Community 1`, `Community 3`?**
  _High betweenness centrality (0.165) - this node is a cross-community bridge._
- **Why does `LWLogInfo()` connect `Community 1` to `Community 0`, `Community 2`?**
  _High betweenness centrality (0.110) - this node is a cross-community bridge._
- **Why does `LWLoggerExample` connect `Community 0` to `Community 1`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Are the 8 inferred relationships involving `LWLogInfo()` (e.g. with `.clearAllLogs()` and `.log()`) actually correct?**
  _`LWLogInfo()` has 8 INFERRED edges - model-reasoned connections that need verification._
- **Are the 6 inferred relationships involving `LWLog()` (e.g. with `.setup()` and `.loggingWithVariables()`) actually correct?**
  _`LWLog()` has 6 INFERRED edges - model-reasoned connections that need verification._
- **What connects `DDLogFlag`, `-initLogConfig`, `-setUp` to the rest of the system?**
  _14 weakly-connected nodes found - possible documentation gaps or missing edges._