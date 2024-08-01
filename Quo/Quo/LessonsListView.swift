//
//  LessonsListView.swift
//  Quo
//
//  Created by Calin Gavriliu on 01.08.2024.
//

import SwiftUI
import SwiftData

struct LessonsListView: View {
    
    @Query(sort: \Lesson.index) var lessons: [Lesson]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                let lessonCompletionStates = lessons.map { $0.isTestCompleted }
                let completedLessons = lessonCompletionStates.filter { $0 == true }
                let completedLessonsCount = completedLessons.count
                
                ForEach(lessons) { lesson in
                    
                    let isUnlocked = lesson.index <= completedLessonsCount + 1
                    
                    NavigationLink(destination: LessonView(lesson: lesson)) {
                        VStack(spacing: -2) {
                            
                            if isUnlocked {
                                Color.accentColor
                                    .frame(height: 8)
                            }
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Lecția \(lesson.index)")
                                        .font(.body.smallCaps())
                                    Text(lesson.title)
                                        .font(.title)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                }
                                .foregroundColor(.primary)
                                Spacer(minLength: 20)
                                
                                if !isUnlocked {
                                    Image(systemName: "lock.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 42, height: 42)
                                }
                            }
                            .padding(.vertical, 24)
                            .padding(.horizontal, 36)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.08), radius: 14, x: 6, y: 2)
                    }
                    .disabled(!isUnlocked)
                }
            }
            .padding(32)
        }
    }
}

#Preview {
    NavigationStack {
        LessonsListView()
            .modelContainer(previewContainer)
    }
}
