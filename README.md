Spotti Capstone Product Spec
===
# Spotti
Gym tracking application for beginners and experienced gym goers alike.

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Gym training companion app that develops dynamic routines based on selected goals, tracks progress and milestones, while also allowing you to connect with other gym-goers

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Lifestyle/Health & Fitness
- **Mobile:** Users can easily receive workouts for their current needs/wants or available equipment, accesibility especially when logging progress information
- **Story:** App provides new gym-goers effective workouts incorporating all areas that they wish to target/start with. More experienced gym goers can take advantage of the progress tracking functionality and the social component to connect with others
- **Market:** Focus on beginner gym goers though also providing features useable by experienced athlete 
- **Habit:** The average user would use this app about 45 minutes to 1.5 hours, about 3 times a week but not much outside this gym going time frame. 
- **Scope:**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login and view their profile along with various metrics
* User can select desired categories for workout
* User can view workout
* Users can edit their workouts by adding, removing exercises to them
* User can input weights/reps for each exercise and view it in a pleasant manner
* User can add other gym goers registered at the same gym as them
* User receives reminders for extended absences and incomplete workouts 

**Optional Nice-to-have Stories**

* User can like/dislike exercises
* User can view growth over time through graphs
* User can tap and hold current weight metrics to view last week's numbers and a visual indicator of whether they've grown
* Users can share their progress with their friends
* User receives weekly updates of their progress wherever it occurred


### 2. Screen Archetypes

* Login Screen
   * Users login here
* Registration screen
   * Users can create an account
* Exercise Selection
    * Users choose which body parts they want to focus on for that session
    * Users select what their goals are
* Exercise Viewing
    * Users can view and edit their workouts
    * Users can input top set information for each exercise
* Metric viewing
    * Users see all the information for each exercise
* Social Screen
    * Users can add other gym goers at the same gym as them and check their profiles


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Screen
* Profile
* Socials

**Flow Navigation** (Screen to Screen)

* Login
   * => Home Screen
  
* Registration
   * => Home Screen
* Exercise Selection
    * => None
* Exercise Viewing
    * => Home
* Metric viewing
    * => Home
    * => Profile
* Social
    * => Home
    * Profile

Complex Features:

1. Notification System with Screen Navigation

This feature focused on leveraging the notification system to deliver the user to the appropriate page based on the situation. The original goal was to generate remote notifications for users however, obstacles such as needing a paid Apple Developer account limited that. I pivoted to local notifications alone, which lacked complexity. As such, with my manager's help, I decided to include screen navigation as part of the notification system. Notifications are already deployed based on different conditions for the required tasks and as an added complexity, will take the user to the appropriate pages to accomplish a certain task. Below is the appropriate demo.

Respective PR: https://github.com/gregoriofs/Spotti/pull/7
The code to accomplish this lies in the AppDelegate.m file, lines 36-42, 49 - 55, 78 - 118 and Home ViewController.m, lines 295 - 323

Demo:

https://user-images.githubusercontent.com/74148230/182494297-2735f0a2-a61c-456a-a112-cff698e90db1.gif

2. Friend Matching Feature

This feature leveraged Mapkit and a Priority Queue implementation to find the best possible friends for a person based on friends in common, location and their gym memberships. I wanted to provide a dynamic, logical way for a gym app to match peoples so I decided to brainstorm some conditions and parameters that I believed would help; a big part of this relied upon Apple's Mapkit framework to query gyms and the user's current location to provide the best friend suggestions. I iterated over found gyms near the current user and I used the queue to sort all other users for each gym based on a given priority derived from the above factors, giving higher weight to users who share the same gym membership and sort based on that.

Respective PR: https://github.com/gregoriofs/Spotti/pull/4

Demo: 

https://user-images.githubusercontent.com/74148230/180073511-3970d8d2-0e01-42e9-a3a6-d9c25b6e2e17.gif

Progress Update Demo 7/12:

![ezgif com-gif-maker (7)](https://user-images.githubusercontent.com/74148230/178561373-bf8446ec-5702-46c4-9b9e-02e54269b70f.gif)

Progress Update Demo 7/20:

![ezgif com-gif-maker (10)](https://user-images.githubusercontent.com/74148230/180091232-da3dceec-1d7d-4c2f-ace0-75fb60b61400.gif)

Progress Update Demo 8/2: Completed Notification Complexity Feature

![ezgif com-gif-maker (13)](https://user-images.githubusercontent.com/74148230/182494648-9089e1fb-1dcc-4048-9f6f-5af82254b81d.gif)

