# Current Sprint: Implementation Sprint 2

## Sprint Goal
Build the client-side experience (Flutter UI) and integrate monetization/ad services based on the "Emerald Wash" design and finalized backend.

## In-scope Items
1. **Flutter Base**: Initialize Flutter project with "Emerald Wash" theme (colors, fonts).
2. **Main Screen**: Implement the Before/After daily progression view with crossfade.
3. **Navigation**: Implement Save Slots view and Settings (notifications).
4. **Monetization**: Integrate Google Mobile Ads (AdMob) for reward tickets.
5. **Purchases**: Integrate RevenueCat for Patron/Creator pack SKUs.

## Out-of-scope Items
- Complex social features or historical gallery beyond save slots.
- Advanced AI parameter tuning (parameters locked from Sprint 1).

## Ordered Delivery Sequence
1. **App Architecture Setup**
   - Flutter initialization + BLoC/Provider for state management.
2. **"Emerald Wash" UI Implementation**
   - Background watercolor shader, 1.4s/1.1s animations, and Typography.
3. **API Integration**
   - Connect to backend `/user/init` and `/progress` with Firebase Auth.
4. **Ad/Purchase Logic**
   - AdMob reward callback and RevenueCat entitlement mapping.
5. **Phase 2 Validation**
   - Run TEST-FR-003 and TEST-FR-006.


