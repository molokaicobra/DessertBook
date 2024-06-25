//
//  MainMenu.swift
//  DessertBook
//
//  Created by Cobra Curtis on 6/20/24.
//

import SwiftUI

/*
 Define a struct conforming to the View protocol to create the Main Menu of the app. UI Elements contain a Button and Title Text. This also matches the System's color prefence.
 */
struct MainMenu: View {
    // main body of the view
    var body: some View {
        // Use NavigationView to provide a navigation interface within the view
        NavigationView {
            VStack {
                Spacer()
                
                // Display the main title of the application
                Text("Pocket Cookbook")
                    .font(.system(size: 24, weight: .bold)) // Set font to system font and size to 24
                    .accessibilityIdentifier("titleLabel") // Accessibility identifier for UI testing
                
                Spacer()
                
                // Create a navigation link to navigate to RecipeTableView when the button is tapped
                NavigationLink(destination: RecipeTableView()) {
                    // Button appearance. Sets the button's color, size, text, and roundness
                    //TODO: If we were addding more buttons it could be good to have a custom button style in the future
                    Text("View Desserts")
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("nextButton") // Accessibility identifier for the button
            
                Spacer()
            }
            .navigationTitle("Main Menu") // Set the navigation bar title
            .navigationBarHidden(true) // Hide the navigation bar
            .background(Color(.systemBackground)) // Set the background color to the system background color
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Provides a preview for styling and debugging
struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        // Preview the MainMenu view on an iPhone 13
        MainMenu()
            .previewDevice("iPhone 13")
        // Preview the MainMenu view on an iPad Pro (12.9-inch) (5th generation)
        MainMenu()
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
    }
}

