//
//  CurrentTopicsView.swift
//  FlashForward
//
//  Created by Fatima Kahbi on 8/19/23.
//

import SwiftUI

struct CurrentTopicsView: View {
    @EnvironmentObject var manager: TopicManager
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            NavigationStack {
                Group {
                    if manager.currentTopics.isEmpty {
                        emptyStatePrompt()
                    } else {
                        displayCurrentTopics()
                    }
                }
                .navigationTitle("Current Learning")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        presentAllTopicsButton(isPresented: $isPresented)
                    }
                }
            }
        }
    }
}

// TODO: get a nicer looking empty state
struct emptyStatePrompt: View {
    var body: some View {
        Text("Visit the Discover tab to add a new flash card set!")
            .font(.title)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct displayCurrentTopics: View {
    @EnvironmentObject var manager: TopicManager
    
    var body: some View {
        List($manager.topics) { $topic in
            NavigationLink {
                FlashCardView(topic: $topic)
            } label: {
                HStack {
                    if let emoji = topic.emoji {
                        Text("\(emoji) ")
                            .font(.title)
                    }
                    Text(topic.name)
                    Spacer()
                    // TODO: Swap for progress indicator
                    Text("\(topic.progress)/\(topic.total)")
                    
                }
            }
        }
        .environment(\.defaultMinListRowHeight, 70)
        .listStyle(.inset)
    }
}

struct presentAllTopicsButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            HStack{
                Image(systemName: "plus.circle")
                    .font(.body)
            }.padding()
        })
        .sheet(isPresented: $isPresented) {
            AllTopicsListView(isPresented: $isPresented)
        }
    }
}


struct CurrentTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var manager : TopicManager = TopicManager()
        CurrentTopicsView()
            .environmentObject(manager)
    }
}
