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
            
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.secondary)
            
            Button(action: {
                
                // Run the loadNewJoke function
                // The action button typically expects synchronous
                // code, which means the code runs line by line
                // when the button is pressed and nothing else can
                // run until this code is finished.
                //
                // However, getting data from a web server is
                // by it's very nature asychronous.
                // This means we don't know how long
                // it will take to fetch the information.
                //
                // The Task type allows us to run an asynchronous
                // task within a button and have the UI be updated
                // when the data is ready. Other tasks can run
                // while we wait for the data to be returned by
                // the web server.
                Task {
                    await loadNewJoke()
                }
                
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
            
            await loadNewJoke()

        }
        .navigationTitle("icanhazdadjoke?")
        .padding()
    }
    
    // MARK: Functions
    
    // This loads a new joke from the endpoint
    //
    // It is an asynchronous function, meaning the function can run
    // concurrently along with other code the app may need to run.
    //
    // NOTE: You can see this in the brief delay that happens when
    //       the app first loads.
    func loadNewJoke() async {
        
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
