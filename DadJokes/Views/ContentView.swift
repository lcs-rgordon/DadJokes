//
//  ContentView.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import SwiftUI

struct ContentView: View {
    // MARK: Stored properties
    
    // Will be replaced by live joke once closure
    // attached to the ".task" view modifier runs
    @State var currentJoke: DadJoke = DadJoke(id: "", joke: "", status: 200)
    
    var body: some View {
        VStack {
            
            Text(currentJoke.joke)
                // Ensure the joke doesn't get truncated
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                // Large text if possible
                .font(.title)
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 4)
                )
                .padding(10)
                // Show this Text view only when the current joke
                // actually has a joke in it
                .opacity(currentJoke.joke.isEmpty == false ? 1.0 : 0.0)
            
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.secondary)
            
            Button(action: {
                print("Button was pressed.")
            }, label: {
                Text("Another one!")
                    .font(.title3)
            })
                .buttonStyle(.bordered)
                .padding(.top, 10)
            
            HStack {
                Text("Favourites")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            
            List {
                Text("Which side of the chicken has more feathers? The outside.")
                Text("Why did the Clydesdale give the pony a glass of water? Because he was a little horse!")
                Text("The great thing about stationery shops is they're always in the same place...")
            }
            
            Spacer()
                        
        }
        // This will pull a new quote from the JSON
        // endpoint each time app loads
        .task {
            
            // Assemble the URL that points to the JSON endpoint
            let url = URL(string: "https://icanhazdadjoke.com/")!
            
            // Define what type of request will be sent to the URL above
            var request = URLRequest(url: url)
            // This request will accept a JSON-formatted response
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            // Start a URL session to interact with the endpoint
            let urlSession = URLSession.shared
                        
            // Try to fetch a new joke
            do {
                // Get the raw data from the endpoint
                let (data, _) = try await urlSession.data(for: request)
                
                // Attempt to decode and return the object containing
                // a new joke
                // NOTE: We decode to DadJoke.self since the endpoint
                //       returns a single JSON object
                currentJoke = try JSONDecoder().decode(DadJoke.self, from: data)
            } catch {
                print("Could not retrieve / decode JSON from endpoint.")
                print(error)
            }

        }
        .navigationTitle("icanhazdadjoke?")
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
