# ParkAndPickk – Client Workflow Summary

## How App Works (Implemented Features)

This summary describes only the features and flows that are currently implemented in your app, based on your project files and requirements.

---

### 1. Getting Started: QR Code & Landing Page
- Customers scan a QR code and land on a welcoming page with a message (“Votre meilleur moment de la journée est ici !”).
- Download buttons for iOS and Android are available.

### 2. Home Map & Station Discovery
- All Park&Pick stations are visible on the home page.
- The nearest station is highlighted.
- Customers can:
	- Get directions to a station (Google/Apple Maps), or
	- Start an order.

### 3. Choosing How to Order
- Customers have two options:
	- **Order in-app:** Browse and order coffee, subscriptions, or coffee packs (ground/beans) directly in the app.
	- **Order for delivery:** Use deep links to DoorDash or Uber Eats for home delivery (product selection and payment happen on those platforms, not in the app).

### 4. In-App Ordering Flow
- Customers select products, manage their basket (“Mon Panier”), and choose a pickup station.
- Payment is handled in-app.
- After ordering, the order appears as a single entry in the order history, with all details.

### 5. Fulfillment: Pickup or Delivery
- Customers pick up their order at the station (for in-app orders).
- If ordered through Uber Eats/DoorDash, delivery is handled outside the app.

---

## Changes Made

### 1. UI/UX Updates
- **Font:** Updated to Roboto for a modern and consistent look.
- **Font Colors:** Simplified and unified across the app for a cleaner look. The new color scheme includes:
  - Rouge (#E0002A)
  - Blanc
  - Noir
- **Button Names:** The "Cart" button is now labeled "Mon Panier" to align with the app’s language.
- **Favorites Tab:** Removed entirely to streamline navigation.
- **Overflow Fixes:** Adjusted layouts (e.g., station info cards) to prevent content overflow.



---

This workflow summary only includes features that are live in your app. For any new features or changes, this document can be updated.

_Last updated: December 27, 2025_