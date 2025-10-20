# PAKKT - DESIGN SYSTEM TODO

> **Goal:** Create a cohesive, aggressive, neon-infused dark design system that screams accountability

---

## 🎨 DESIGN PHILOSOPHY

**Core Principles:**
- **Dark Neobrutalism:** Hard edges, thick borders, aggressive shadows
- **Liquid Glass:** Frosted blur effects, translucent overlays
- **Neon Accents:** Electric colors that pop against pure black
- **Raw Authenticity:** BeReal-style immediacy and unpolished realness
- **Aggressive Typography:** ALL CAPS, bold weights, high contrast

**NOT:**
- ❌ Soft, gentle, pastel colors
- ❌ Rounded corners everywhere
- ❌ Corporate, polished aesthetics
- ❌ Light mode (dark only for MVP)
- ❌ Subtle, quiet design

---

## 🎯 PHASE 1: FOUNDATION

### **A. Figma Setup**

- [ ] Create Figma account (if not exists)
- [ ] Create project: "Pakkt Design System"
- [ ] Set up pages:
  - 🎨 **Foundation** (Colors, Typography, Spacing)
  - 🧩 **Components** (Buttons, Cards, Inputs)
  - 📱 **Screens** (All app screens)
  - 📐 **Layouts** (Grid system, templates)
  - 🎬 **Prototypes** (Interactive flows)

- [ ] Install Figma plugins:
  - [ ] **Stark** (Accessibility checker)
  - [ ] **Unsplash** (Stock photos for mockups)
  - [ ] **Iconify** (Icon library)
  - [ ] **Auto Layout** (Responsive design)

---

### **B. Color System**

#### 1. Foundation Colors

- [ ] Create color styles in Figma:

**Base (Background)**
```
Pure Black       #000000  ████████
Deep Gray        #0A0A0A  ████████
Charcoal         #1A1A1A  ████████
Dark Gray        #2A2A2A  ████████
Medium Gray      #3A3A3A  ████████
```

**Neon Accents (Primary)**
```
Electric Cyan    #00F0FF  ████████  (Primary actions, info, links)
Hot Magenta      #FF006E  ████████  (Danger, fines, errors)
Acid Yellow      #FFFF00  ████████  (Warnings, jail, attention)
Toxic Green      #39FF14  ████████  (Success, check-ins, streaks)
Deep Purple      #7B2CBF  ████████  (Premium, subscriptions)
Orange Fire      #FF6B35  ████████  (Streaks, achievements)
```

**Text Colors**
```
White            #FFFFFF  ████████  (Primary text)
Light Gray       #CCCCCC  ████████  (Secondary text)
Medium Gray      #888888  ████████  (Tertiary text, disabled)
```

**Semantic Colors**
```
Success          Toxic Green (#39FF14)
Error            Hot Magenta (#FF006E)
Warning          Acid Yellow (#FFFF00)
Info             Electric Cyan (#00F0FF)
Premium          Deep Purple (#7B2CBF)
```

#### 2. Gradient System

- [ ] Create gradient styles:

**Neon Gradients**
```
Cyan → Magenta   (Primary CTA backgrounds)
Yellow → Orange  (Streak/achievement highlights)
Purple → Cyan    (Premium features)
Green → Cyan     (Success states)
```

**Glass Overlays**
```
Dark Glass       rgba(26, 26, 26, 0.4) + blur(60px)
Medium Glass     rgba(26, 26, 26, 0.6) + blur(40px)
Heavy Glass      rgba(26, 26, 26, 0.8) + blur(20px)
```

#### 3. Shadow System

- [ ] Create shadow effects:

**Brutal Shadows (Hard, Offset)**
```
Small    offsetX: 4px,  offsetY: 4px,  blur: 0,   color: rgba(0, 240, 255, 0.6)
Medium   offsetX: 8px,  offsetY: 8px,  blur: 0,   color: rgba(0, 240, 255, 0.6)
Large    offsetX: 12px, offsetY: 12px, blur: 0,   color: rgba(0, 240, 255, 0.6)
```

**Neon Glows (Soft, No Offset)**
```
Cyan Glow        offsetX: 0,    offsetY: 0,    blur: 20px, color: rgba(0, 240, 255, 0.5)
Magenta Glow     offsetX: 0,    offsetY: 0,    blur: 20px, color: rgba(255, 0, 110, 0.5)
Green Glow       offsetX: 0,    offsetY: 0,    blur: 20px, color: rgba(57, 255, 20, 0.5)
```

#### 4. Accessibility Check

- [ ] Verify all text/background combinations meet WCAG AA:
  - [ ] White on Pure Black ✅ (21:1 ratio)
  - [ ] Electric Cyan on Pure Black ✅ (12:1 ratio)
  - [ ] Acid Yellow on Pure Black ✅ (18:1 ratio)
  - [ ] Light Gray on Dark Gray ✅ (4.5:1 minimum)

---

### **C. Typography System**

#### 1. Font Selection

- [ ] Primary Font: **SF Pro Display** (iOS native)
- [ ] System fallback: `-apple-system, BlinkMacSystemFont`

#### 2. Type Scale

- [ ] Create text styles in Figma:

**Display (Headers)**
```
H1 - Display Black
  Size: 48px, Weight: 900 (Black), Line: 52px, Letter: -1px
  Use: Screen titles, major headers

H2 - Display Bold
  Size: 36px, Weight: 800 (Extra Bold), Line: 40px, Letter: -0.5px
  Use: Section headers, card titles

H3 - Display Semibold
  Size: 28px, Weight: 700 (Bold), Line: 32px, Letter: 0px
  Use: Sub-sections, modal titles
```

**Body Text**
```
Body Large
  Size: 18px, Weight: 600 (Semibold), Line: 24px, Letter: 0px
  Use: Primary content, important text

Body Regular
  Size: 16px, Weight: 500 (Medium), Line: 22px, Letter: 0px
  Use: Standard body text, descriptions

Body Small
  Size: 14px, Weight: 400 (Regular), Line: 20px, Letter: 0px
  Use: Secondary text, captions
```

**Labels & UI**
```
Label Large (ALL CAPS)
  Size: 14px, Weight: 700 (Bold), Line: 18px, Letter: 1.5px, Transform: Uppercase
  Use: Button text, important labels

Label Small (ALL CAPS)
  Size: 12px, Weight: 600 (Semibold), Line: 16px, Letter: 1.2px, Transform: Uppercase
  Use: Tags, badges, small UI elements

Caption
  Size: 10px, Weight: 500 (Medium), Line: 14px, Letter: 0.5px
  Use: Timestamps, metadata
```

**Monospace (Numbers)**
```
Mono Large
  Size: 48px, Weight: 700 (Bold), Line: 52px, Font: SF Mono
  Use: Countdown timers, large numbers

Mono Regular
  Size: 24px, Weight: 600 (Semibold), Line: 28px, Font: SF Mono
  Use: Streak counts, stats
```

#### 3. Text Hierarchy Examples

- [ ] Design example screens showing hierarchy:
  - [ ] Feed card with title + body + caption
  - [ ] Settings screen with sections
  - [ ] Onboarding with large display text

---

### **D. Spacing & Layout**

#### 1. Spacing Scale (8pt Grid)

- [ ] Define spacing tokens:
```
XXS:  4px   (Tiny gaps, icon padding)
XS:   8px   (Small gaps, compact spacing)
S:    12px  (Default element spacing)
M:    16px  (Standard padding)
L:    24px  (Section spacing)
XL:   32px  (Major sections)
XXL:  48px  (Screen-level spacing)
XXXL: 64px  (Hero spacing)
```

- [ ] Create spacing styles in Figma (Auto Layout gaps)

#### 2. Border Radius

- [ ] Define radius tokens:
```
None:   0px    (Brutal, hard edges)
Small:  8px    (Subtle rounding)
Medium: 12px   (Cards, buttons)
Large:  16px   (Modals, sheets)
Full:   9999px (Pills, avatars)
```

#### 3. Border Width

- [ ] Define border styles:
```
Thin:   1px   (Subtle dividers)
Medium: 2px   (Standard borders)
Thick:  3px   (Neon borders, focus states)
Heavy:  4px   (Brutal emphasis)
```

#### 4. Grid System

- [ ] Create layout grid in Figma:
  - [ ] **Columns:** 12-column grid (for web/iPad future)
  - [ ] **Margins:** 16px (iPhone), 24px (iPad)
  - [ ] **Gutter:** 16px
  - [ ] **Safe Area:** Respect iPhone notch and home indicator

---

## 🧩 PHASE 2: COMPONENT LIBRARY

### **A. Buttons**

#### 1. Primary Button (Neon CTA)

- [ ] Design in Figma:
  - [ ] Background: Electric Cyan (#00F0FF)
  - [ ] Text: Pure Black (#000000), Label Large (ALL CAPS)
  - [ ] Padding: 16px vertical, 32px horizontal
  - [ ] Border Radius: 12px
  - [ ] Shadow: Cyan Glow (20px blur)
  - [ ] States:
    - Default
    - Pressed (darken 10%, shadow smaller)
    - Disabled (opacity 40%, no shadow)

#### 2. Danger Button (Fines, Jail)

- [ ] Background: Hot Magenta (#FF006E)
- [ ] Text: White (#FFFFFF)
- [ ] Shadow: Magenta Glow
- [ ] Same padding/radius as Primary

#### 3. Secondary Button (Outlined)

- [ ] Background: Dark Glass (rgba(26,26,26,0.4) + blur)
- [ ] Border: 3px Electric Cyan
- [ ] Text: Electric Cyan
- [ ] No shadow (or subtle cyan glow)

#### 4. Ghost Button (Minimal)

- [ ] Background: Transparent
- [ ] Text: Light Gray (#CCCCCC)
- [ ] No border, no shadow
- [ ] Hover: Underline or light background

#### 5. Icon Button

- [ ] Size: 44×44px (iOS touch target)
- [ ] Background: Dark Glass
- [ ] Icon: White or neon color
- [ ] Border Radius: 12px or Full (circular)

- [ ] Create button component with variants in Figma
- [ ] Export states and measurements for iOS

---

### **B. Cards**

#### 1. Glass Card (Default)

- [ ] Design:
  - [ ] Background: Dark Glass (rgba(26,26,26,0.4) + blur 60px)
  - [ ] Border: 3px Electric Cyan
  - [ ] Border Radius: 16px
  - [ ] Padding: 16px
  - [ ] Shadow: Small Brutal Shadow (offset cyan)

#### 2. Pack Card

- [ ] Layout:
  - [ ] Pack avatar (60×60px, circular, left)
  - [ ] Pack name (H3, white)
  - [ ] Member count + active goals (Body Small, gray)
  - [ ] Background: Glass Card
  - [ ] Tap area: Full card

#### 3. Check-In Card (Feed Item)

- [ ] Layout:
  - [ ] User avatar (40×40px, top-left)
  - [ ] Username + time (Body Regular, white)
  - [ ] Check-in photo (square, full width, 16px margin)
  - [ ] Caption (Body Small, gray, below photo)
  - [ ] Reaction bar (emojis with counts, bottom)
  - [ ] Comment count (Body Small, gray)
  - [ ] Background: Glass Card

#### 4. Fine Card

- [ ] Layout:
  - [ ] "FINE" label (Label Large, magenta)
  - [ ] Amount (Mono Large, $XX, magenta)
  - [ ] Reason (Body Regular, white)
  - [ ] Vote buttons (Activate / Let Slide)
  - [ ] Vote count (Body Small, gray)
  - [ ] Background: Glass Card with Magenta border

#### 5. Jail Card

- [ ] Layout:
  - [ ] "JAIL" label (Label Large, yellow)
  - [ ] Timer (Mono Large, MM:SS, yellow)
  - [ ] Blocked apps list (icons, grayed)
  - [ ] Break button (small, bottom)
  - [ ] Background: Glass Card with Yellow border

- [ ] Create card components with Auto Layout
- [ ] Ensure cards work at different widths (responsive)

---

### **C. Input Fields**

#### 1. Text Field

- [ ] Design:
  - [ ] Background: Dark Glass
  - [ ] Border: 2px Medium Gray (default), 3px Electric Cyan (focus)
  - [ ] Border Radius: 12px
  - [ ] Padding: 12px
  - [ ] Text: Body Regular, White
  - [ ] Placeholder: Body Regular, Medium Gray
  - [ ] States: Default, Focus, Error (Magenta border)

#### 2. Phone Number Field

- [ ] Include country code picker (+1)
- [ ] Format: (XXX) XXX-XXXX
- [ ] Same styling as Text Field

#### 3. Text Area (Multi-line)

- [ ] Min height: 100px
- [ ] Max length indicator (e.g., "120/200")
- [ ] Same styling as Text Field

#### 4. Picker (Dropdown)

- [ ] Background: Dark Glass
- [ ] Chevron icon (right)
- [ ] Opens bottom sheet on tap
- [ ] Selected value shown in field

#### 5. Slider

- [ ] Track: 4px height, Dark Gray
- [ ] Thumb: 32×32px circle, Electric Cyan, Cyan Glow
- [ ] Filled track: Electric Cyan
- [ ] Labels: Min/max values, current value above thumb

#### 6. Toggle Switch

- [ ] Track: 52×32px rounded pill
- [ ] Thumb: 28×28px circle, white
- [ ] Off: Dark Gray track
- [ ] On: Electric Cyan track, Cyan Glow

- [ ] Create input components with interactive states
- [ ] Ensure keyboard appearance matches design (dark)

---

### **D. Navigation & Bars**

#### 1. Tab Bar (Bottom)

- [ ] Design:
  - [ ] Background: Dark Glass (heavy, 80% opacity)
  - [ ] Height: 80px (includes safe area)
  - [ ] 4 tabs: Feed, Packs, Goals, Profile
  - [ ] Icons: SF Symbols, 24×24px
  - [ ] Labels: Caption, below icons
  - [ ] Active state: Electric Cyan icon + text, Cyan Glow
  - [ ] Inactive: Medium Gray

#### 2. Navigation Bar (Top)

- [ ] Background: Dark Glass or Transparent
- [ ] Title: H3, White, centered
- [ ] Back button: Left, chevron + "Back" (optional)
- [ ] Action buttons: Right (e.g., Settings icon)
- [ ] Height: 44px + safe area

#### 3. Bottom Sheet

- [ ] Background: Charcoal (#1A1A1A)
- [ ] Border Radius: 24px (top corners only)
- [ ] Handle: 40×4px rounded gray bar, centered, 12px from top
- [ ] Padding: 24px
- [ ] Max height: 90% of screen

---

### **E. Badges & Indicators**

#### 1. Streak Badge

- [ ] Icon: 🔥 or fire SF Symbol
- [ ] Count: Mono Regular, Orange Fire
- [ ] Background: Dark Glass
- [ ] Border: 2px Orange Fire
- [ ] Border Radius: Full (pill)
- [ ] Padding: 8px horizontal, 4px vertical

#### 2. Fine Amount Badge

- [ ] "$XX" in Mono Regular, Hot Magenta
- [ ] Background: Dark Glass
- [ ] Border: 2px Hot Magenta
- [ ] Border Radius: Full

#### 3. Notification Badge (Red Dot)

- [ ] Size: 8×8px circle
- [ ] Color: Hot Magenta
- [ ] Position: Top-right of icon/avatar

#### 4. Status Indicator

- [ ] Active: Toxic Green circle (8px)
- [ ] Away: Acid Yellow circle
- [ ] Offline: Medium Gray circle

---

### **F. Media Components**

#### 1. Avatar

- [ ] Sizes:
  - Small: 32×32px
  - Medium: 40×40px
  - Large: 60×60px
  - XLarge: 100×100px

- [ ] Border Radius: Full (circular)
- [ ] Border: 2px Electric Cyan (optional, for active users)
- [ ] Fallback: Initials on gradient background

#### 2. Pack Avatar Grid (Overlapping)

- [ ] 4-5 member avatars, overlapping by 50%
- [ ] Border: 2px Pure Black (to create separation)
- [ ] "+X more" indicator if >5 members

#### 3. Check-In Photo

- [ ] Aspect Ratio: 1:1 (square)
- [ ] Border Radius: 12px
- [ ] Max width: Full card width - 32px padding
- [ ] Tap to view full-screen

---

### **G. Feedback & States**

#### 1. Loading Spinner

- [ ] Design:
  - [ ] Circular, 32×32px (small), 48×48px (large)
  - [ ] Electric Cyan color
  - [ ] Smooth rotation animation
  - [ ] Optional: Indeterminate progress bar (horizontal)

#### 2. Empty State

- [ ] Large icon (SF Symbol, 80×80px, Medium Gray)
- [ ] Title: H3, White
- [ ] Description: Body Regular, Light Gray
- [ ] CTA Button (if applicable)

#### 3. Error State

- [ ] Icon: ⚠️ or alert symbol (Hot Magenta)
- [ ] Title: H3, White
- [ ] Message: Body Regular, Light Gray
- [ ] "Try Again" button

#### 4. Success State

- [ ] Icon: ✅ or checkmark (Toxic Green)
- [ ] Title: H3, White
- [ ] Message: Body Regular, Light Gray
- [ ] Auto-dismiss after 2 seconds (optional)

#### 5. Toast Notification

- [ ] Background: Dark Glass (heavy)
- [ ] Border: 2px (color based on type: cyan/green/magenta/yellow)
- [ ] Text: Body Regular, White
- [ ] Icon: Left (based on type)
- [ ] Auto-dismiss: 3 seconds
- [ ] Position: Top, below safe area

---

### **H. Modals & Dialogs**

#### 1. Alert Dialog

- [ ] Background: Charcoal (#1A1A1A)
- [ ] Border: 3px Electric Cyan
- [ ] Border Radius: 16px
- [ ] Title: H3, White, center-aligned
- [ ] Message: Body Regular, Light Gray, center-aligned
- [ ] Buttons: Primary + Ghost, stacked vertically
- [ ] Padding: 24px

#### 2. Confirmation Dialog (Destructive)

- [ ] Same as Alert, but:
  - Border: 3px Hot Magenta
  - Primary button: Danger style
  - Used for: Delete account, leave pack, etc.

#### 3. Full-Screen Modal

- [ ] Background: Pure Black (#000000)
- [ ] Close button: Top-left or top-right (X icon)
- [ ] Content: Scrollable
- [ ] Used for: Onboarding, settings, photo viewer

---

## 📱 PHASE 3: SCREEN DESIGNS

### **A. Core Screens**

For each screen, design in Figma with all components and interactions:

#### 1. Authentication
- [ ] Splash screen (logo + neon glow animation)
- [ ] Login (phone number input)
- [ ] OTP verification (6-digit code)

#### 2. Onboarding
- [ ] Welcome (tagline + CTA)
- [ ] Create profile (username, avatar)
- [ ] Enable notifications (permission request)
- [ ] Create/join pack (two paths)
- [ ] Enable Family Controls (phone jail permission)

#### 3. Main App
- [ ] **Feed** (BeReal-style check-in feed)
  - [ ] Today's check-ins from all packs
  - [ ] Reactions and comments
  - [ ] Pull to refresh
  - [ ] Empty state (no check-ins yet)

- [ ] **Packs** (Pack list)
  - [ ] Horizontal carousel or vertical list
  - [ ] Pack detail view
  - [ ] Pack settings
  - [ ] Invite flow

- [ ] **Goals** (Goal list)
  - [ ] Goals grouped by pack
  - [ ] Create goal flow
  - [ ] Goal detail with streak
  - [ ] Check-in flow (camera, caption)

- [ ] **Profile** (User profile)
  - [ ] Avatar, username, bio
  - [ ] Stats (streak, check-ins, fines, jails)
  - [ ] Edit profile
  - [ ] Settings

#### 4. Features
- [ ] **Check-In** (Camera + submit)
  - [ ] Timer countdown (30 min window)
  - [ ] Photo capture
  - [ ] Caption input
  - [ ] Success animation

- [ ] **Fine Notification** (Modal)
  - [ ] Amount + reason
  - [ ] Vote buttons
  - [ ] Voting results

- [ ] **Phone Jail** (Full-screen takeover)
  - [ ] Large timer (center)
  - [ ] Blocked apps list
  - [ ] Pack member comments (live)
  - [ ] Break jail button (small)

- [ ] **Paywall** (Subscription)
  - [ ] Aggressive headline
  - [ ] Benefits list
  - [ ] Annual vs Weekly pricing
  - [ ] "Start Free Trial" CTA

---

### **B. Responsive Design**

- [ ] Design for multiple iPhone sizes:
  - [ ] iPhone 14 Pro Max (430×932)
  - [ ] iPhone 14 (390×844)
  - [ ] iPhone SE (375×667)

- [ ] Use Auto Layout in Figma for responsive components
- [ ] Ensure touch targets are 44×44px minimum

---

### **C. Interactive Prototype**

- [ ] Create Figma prototype with interactions:
  - [ ] Onboarding flow (tap through 5 screens)
  - [ ] Create pack → Join pack → View pack
  - [ ] Create goal → Check-in → Success
  - [ ] Fine notification → Vote → Activate
  - [ ] Phone jail → Timer countdown → Complete

- [ ] Add transitions:
  - [ ] Slide (for navigation)
  - [ ] Modal (for sheets and dialogs)
  - [ ] Fade (for state changes)

- [ ] Share prototype link with team for feedback

---

## 🎬 PHASE 4: ANIMATIONS & MOTION

### **A. Micro-Interactions**

- [ ] Button press: Scale down 95%, bounce back
- [ ] Toggle switch: Smooth slide, 0.2s ease
- [ ] Tab bar: Icon scale + color fade, 0.3s
- [ ] Card tap: Subtle scale + shadow grow
- [ ] Pull to refresh: Spinner rotation

### **B. Screen Transitions**

- [ ] Push: Slide left (0.3s ease-in-out)
- [ ] Pop: Slide right (0.3s ease-in-out)
- [ ] Modal present: Slide up (0.4s ease-out)
- [ ] Modal dismiss: Slide down (0.3s ease-in)

### **C. Feedback Animations**

- [ ] Check-in success: Confetti burst + streak badge grow
- [ ] Fine activated: Shake + magenta flash
- [ ] Jail started: Yellow flash + timer fade-in
- [ ] Streak milestone: Fire emoji pulse + orange glow

### **D. Loading States**

- [ ] Skeleton screens: Animated gray rectangles (shimmer effect)
- [ ] Progressive image loading: Blur → Sharp
- [ ] Infinite scroll: Spinner at bottom

---

## 📐 PHASE 5: DESIGN TOKENS (For Developers)

### **A. Export Design Tokens**

Create a JSON file or Swift constants for developers:

- [ ] Create `DesignTokens.json`:
  ```json
  {
    "colors": {
      "pureBlack": "#000000",
      "electricCyan": "#00F0FF",
      "hotMagenta": "#FF006E",
      // ... all colors
    },
    "spacing": {
      "xxs": 4,
      "xs": 8,
      "s": 12,
      // ... all spacing
    },
    "typography": {
      "h1": {
        "fontSize": 48,
        "fontWeight": 900,
        "lineHeight": 52,
        "letterSpacing": -1
      },
      // ... all text styles
    },
    "borderRadius": {
      "none": 0,
      "small": 8,
      // ... all radii
    }
  }
  ```

- [ ] Or create Swift constants:
  ```swift
  // PakktColors.swift
  extension Color {
    static let pureBlack = Color(hex: "#000000")
    static let electricCyan = Color(hex: "#00F0FF")
    // ... all colors
  }

  // PakktSpacing.swift
  enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    // ... all spacing
  }
  ```

---

### **B. Figma Handoff**

- [ ] Use Figma's Inspect panel for developers
- [ ] Export assets:
  - [ ] App icon (@1x, @2x, @3x)
  - [ ] SF Symbols (use system icons where possible)
  - [ ] Custom icons (if any, export as PDF vectors)
  - [ ] Illustrations (onboarding, empty states)

- [ ] Create handoff document:
  - [ ] Link to Figma file
  - [ ] Color palette reference
  - [ ] Typography specs
  - [ ] Component usage guidelines
  - [ ] Animation specifications

---

## 🖼️ PHASE 6: MARKETING ASSETS

### **A. App Store Screenshots (8 Required)**

Design vertical screenshots (1284×2778px for iPhone 14 Pro Max):

- [ ] **Screenshot 1: Main Feed**
  - Hero shot showing check-in cards
  - Reactions and comments visible
  - Text overlay: "YOUR PACK IS WATCHING"

- [ ] **Screenshot 2: Phone Jail**
  - Dramatic jail countdown timer
  - Blocked apps grayed out
  - Text overlay: "REAL CONSEQUENCES"

- [ ] **Screenshot 3: Pack View**
  - Friend grid, pack stats
  - Text overlay: "HOLD EACH OTHER ACCOUNTABLE"

- [ ] **Screenshot 4: Check-In**
  - Camera interface, timer countdown
  - Text overlay: "30 MINUTES TO CHECK IN"

- [ ] **Screenshot 5: Fine Voting**
  - Fine card with vote buttons
  - Text overlay: "YOUR BOYS WON'T LET THIS SLIDE"

- [ ] **Screenshot 6: Streak Stats**
  - Profile with streak badges
  - Text overlay: "TRACK YOUR PROGRESS"

- [ ] **Screenshot 7: Paywall**
  - Subscription options
  - Text overlay: "UNLOCK FULL PAKKT"

- [ ] **Screenshot 8: Social Proof**
  - Testimonial or usage stat
  - Text overlay: "JOIN 10,000+ PACKS"

- [ ] Add text overlays with aggressive copy (ALL CAPS, neon colors)
- [ ] Export all sizes: 6.7", 6.5", 5.5" displays

---

### **B. App Preview Video (30 seconds)**

Storyboard and design:

- [ ] **0-5s:** Show app icon + tagline "SHOW UP OR PAY UP"
- [ ] **5-10s:** Quick onboarding (create pack, add friends)
- [ ] **10-15s:** Check-in flow (goal timer, take photo, submit)
- [ ] **15-20s:** Missed goal → Fine notification → Voting
- [ ] **20-25s:** Phone jail activation (dramatic timer countdown)
- [ ] **25-30s:** Success (streak celebration) + CTA "Download now"

- [ ] Use fast cuts, aggressive music, neon transitions
- [ ] Export as .MOV file (H.264, 1080p)

---

### **C. App Icon**

- [ ] Design 1024×1024px app icon:
  - [ ] Dark background (pure black or dark gradient)
  - [ ] Pakkt logo or "P" symbol
  - [ ] Neon accent (cyan or magenta glow)
  - [ ] Keep it simple, recognizable at small sizes

- [ ] Export all required sizes for AppIcon.appiconset:
  - [ ] 20×20, 29×29, 40×40, 60×60, 76×76, 83.5×83.5, 1024×1024
  - [ ] @1x, @2x, @3x variants

---

### **D. Landing Page Assets**

- [ ] Hero image (1920×1080px)
- [ ] Product screenshots (3-4 key screens)
- [ ] Feature icons (64×64px, neon style)
- [ ] Social media graphics (Instagram, Twitter, Facebook sizes)

---

## ✅ DESIGN SYSTEM CHECKLIST

Before handing off to developers:

- [ ] All colors defined and accessible (WCAG AA)
- [ ] Typography scale complete and tested
- [ ] Spacing system consistent (8pt grid)
- [ ] All components designed with states (default, hover, active, disabled)
- [ ] Screens designed for 3 iPhone sizes
- [ ] Interactive prototype complete
- [ ] Animation specs documented
- [ ] Design tokens exported (JSON or Swift)
- [ ] App Store assets exported (screenshots, video, icon)
- [ ] Figma file organized and named clearly
- [ ] Handoff document created for developers

---

## 🎯 SUCCESS METRICS

**Design Quality:**
- All components follow dark neobrutalism + glass aesthetic
- Consistent spacing and typography across all screens
- Accessible color contrast (WCAG AA minimum)
- Smooth animations (60fps target)

**Developer Handoff:**
- Zero ambiguity in component specs
- All assets exported in correct formats
- Design tokens match Figma exactly
- Developers can implement without guesswork

**User Experience:**
- Clear visual hierarchy on all screens
- Aggressive but not overwhelming design
- Every feature creates a "shareable moment"
- Design supports viral growth (screenshot-worthy)

---

**Next Steps:**
1. Set up Figma project and foundation (colors, typography)
2. Design core components (buttons, cards, inputs)
3. Create all main screens with realistic content
4. Build interactive prototype for user testing
5. Export assets and create developer handoff document
