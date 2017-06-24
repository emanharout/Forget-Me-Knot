# Forget-Me-Knot

![Forget Me Knot Gallery](Readme_Assets/Forget_Me_Knot_Gallery.png?raw=true "Forget Me Knot Gallery")

## Intro

[Forget Me Knot](http://emanleet.com/portfolio/forget-me-knot/ "Forget Me Knot") is a project I completed with an 11 hour time constraint. **Server is likely no longer active**, but I put this up anyway to demonstrate clean, iterative code written with a time constraint in mind. There are a few things that can be improved, but I thought I would leave it more or less the same since it shows what I can do with a deadline.

The app conforms to Apple's recommended MVC design pattern, allowing for a nice separation of concerns. It also has a networking layer that utilizes RESTful APIs to pull grocery items and post grocery lists. The UI is built using Auto Layout and Stack Views.

## Running the Project

1. Simply download or clone the project
2. Open the Xcode project and navigate to the NetworkingConstants.swift file
3. Inside the Constants struct, there is an Http struct with a static constant named "AuthHeaderValue." Customize the string found there while conforming to the following format: "lastName_fourDigitNumber"
4. Run the application and add new grocery lists
