# Parking Lot Management App

## Overview
This project is a Parking Lot Management Application built using Flutter and Firebase. The goal of the app is to simulate a real parking lot system where users can view available slots, reserve a slot, track their parking duration, and calculate parking fees based on the time spent. The app supports real‑time updates so multiple users can interact with the system at the same time.

## Features
- User sign‑in and sign‑up using Firebase Authentication.
- A configurable number of parking slots, each with a unique slot number.
- Grid view display of all slots with different colors for available and occupied slots.
- Ability for users to reserve an available slot.
- Display of reservation details such as entry time and slot number.
- Option to release a reserved slot and automatically calculate the parking fee.
- Real‑time updates of slot status using Firebase Firestore.
- Parking history showing previous reservations, time spent, and fees paid.
- Error handling for invalid actions or network issues.

## Parking Fee Calculation
- First 10 minutes: Free  
- After 10 minutes: 100 per hour  
- Billing is rounded up to the next hour.

Example:  
If a user enters at 9:00 and exits at 10:05, the fee is 200.  
This includes 100 for the first hour (9:00–10:00) and 100 for the next hour (10:00–11:00).

## Tech Stack
- Flutter (Dart)
- Firebase Authentication
- Firebase Firestore
- Provider for state management
- Material Design components

## Project Structure


lib/
 ├── models/
 ├── providers/
 ├── screens/
   ├── widgets/
 ├── services/
 └── main.dart


## Setup Instructions

### 1. Clone the repository

git clone https://github.com/your-username/parking-lot-app.git

cd parking_lot_app

### 2. Install dependencies

flutter pub get

### 3. Configure Firebase
- Create a Firebase project.
- Enable Email/Password Authentication.
- Add Android and/or iOS apps.
- Download the required Firebase configuration files.
- Place them in the correct platform folders.

### 4. Run the application

flutter run


## Machine Task Requirements Covered
- Authentication using Firebase.
- Configurable parking slots.
- Real‑time slot updates.
- Slot reservation and release.
- Fee calculation based on time spent.
- Parking history.
- Error handling.
