# UI Behavior

- Progress button indicates availability and lock state.
- During Before/After animation, input is disabled.
- Save and reset actions require explicit confirmation where needed.
- No gallery-style historical timeline is provided by default.

## Design Theme: Emerald Wash

### Core Aesthetics
- **Philosophy**: "Sell Time, not Image". Calm, poetic, organic, and intentional.
- **Colors**:
  - Base Background (Aqua Mist): `#E8F7F5`
  - Gradient: `linear-gradient(180deg, #E8F7F5 0%, #FFF5E6 100%)` (60% alpha at bottom)
  - Surface: `#D9F1EE`
  - Text: Primary `#1C3E3A`, Secondary `#4F7470`, Caption `#7FA7A3`
  - Accent (Emerald Core): `#1DBA9D`
  - Danger (Muted Coral): `#C98B8B`
- **Animations**:
  - Before/After: 1.4s Before, 1.1s Crossfade (easeInOutSine), blur 2px -> 0px.
  - Button Tap: Scale 0.98, Brightness -4%, 120ms (No bounce, no ripple).
- **Layout & Geometry**:
  - Image Radius: 20px, Button: 18px, Card: 16px.
  - Shadow: `rgba(28, 62, 58, 0.06)`, Blur 28.
  - Typography: Noto Sans JP (JP), Inter (EN).

## Irreversible Action Confirmation
- **Reset**: Long press (3s) + "The current painting will be lost. Reset?" dialog.
- **Save**: Confirmation dialog "Save current and start new?".

## Execution Note
Operational HOW details are maintained in `skills/flutter_ui/SKILL.md`.

