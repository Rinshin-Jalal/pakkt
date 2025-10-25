Brand Identity & Visual Design

*Last Updated: January 2025*

---

## 🎨 Brand Overview

### **Brand Essence**

```
WHAT WE ARE:
Underground accountability club for people who need real consequences

WHAT WE'RE NOT:
Another pastel productivity app for corporate girlbosses
```

### **Brand Personality**

```
AGGRESSIVE, not gentle
RAW, not polished
LOUD, not subtle
REBELLIOUS, not corporate
BROTHERHOOD, not therapy
HIGH-ENERGY, not calm
PREMIUM CHAOS, not minimalist zen
```

### **Brand Voice**

**Tone:** Direct, no-bullshit, slightly aggressive but supportive

**Examples:**

❌ **BAD (too corporate):**
"Welcome to [APP_NAME]! Let's help you achieve your goals together 🌸"

✅ **GOOD (our voice):**
"Show up or pay up. Your pack is watching."

❌ **BAD (too aggressive):**
"You're pathetic. Your friends will punish you."

✅ **GOOD (aggressive but fun):**
"Missed gym again? Your boys won't let this slide. 💀"

❌ **BAD (too casual):**
"Hey bestie! Time to check in lol"

✅ **GOOD (direct, urgent):**
"CHECK IN NOW. 5 minutes left."

---

## 🖤 Visual Identity

### **Design Philosophy: Liquid Glass**

**Think:**
- A clean, modern, and focused interface.
- Inspired by Apple's design language.
- Layered glass panels creating a sense of depth.
- Minimalist, with a single, deliberate accent color.
- Premium, polished, and intuitive.

---

## 🎨 Color Palette

### **Foundation Colors**

```
PURE BLACK
#000000
Usage: Main background, maximum contrast
Feel: Void, intensity, focus

DEEP GRAY  
#0A0A0A
Usage: Elevated surfaces, subtle depth
Feel: Shadow, mystery

CHARCOAL
#1A1A1A
Usage: Cards, containers
Feel: Structure, solidity
```

### **Primary Accent Color**

```
ELECTRIC CYAN
#00F0FF
Usage: Primary actions, interactive elements, highlights
Feel: Energy, focus, clarity
```

### **Semantic States**

For states like success, warning, and danger, the design will rely on a combination of iconography (SF Symbols) and typography, rather than a wide palette of colors. This maintains a clean, focused aesthetic. Borders and text can adopt neutral shades of white or gray.

### **Glass Effects**

```
GLASS LIGHT
rgba(255, 255, 255, 0.05)
Usage: Subtle glass fill

GLASS BORDER  
rgba(255, 255, 255, 0.15)
Usage: Glass card borders

GLASS DARK
rgba(26, 26, 26, 0.8)
Usage: Frosted dark glass

BLUR AMOUNT
40-60px backdrop filter
Usage: Glassmorphism effect
```

### **Typography Rules**

```
1. CLARITY AND ELEGANCE
   - Prioritize readability and a clean look.
   - Use strong weights (Bold, Semibold) for titles to establish hierarchy without being overwhelming.
   - Standard letter spacing is preferred for readability.

2. BODY IS PARAMOUNT
   - Never smaller than 16pt.
   - Use Regular or Medium weight for optimal reading comfort.
   - Ensure high contrast (white on dark backgrounds).
   - Generous line spacing (1.4-1.5) is key.

3. LABELS ARE FUNCTIONAL
   - Use Medium or Semibold weight for clarity.
   - Case can be UPPERCASE for short labels or Sentence case for longer ones.
   - Use the accent color for interactive labels.

4. HIERARCHY IS INTUITIVE
   - Use distinct but not jarring jumps in font size and weight.
   - Color reinforces hierarchy: accent for primary, white for secondary, gray for tertiary.

5. SPACING IS BREATHING ROOM
   - Ensure generous padding around all text elements.
   - Avoid cramped layouts to maintain a calm, focused feel.
```

---

## 🃏 Card Design System

### **Glass Cards**

```
ANATOMY:
- Background: Semi-transparent dark (rgba(26, 26, 26, 0.8))
- Backdrop blur: 40-60px
- Border: 1.5px solid rgba(255, 255, 255, 0.15)
- Border radius: 16-24px
- Shadow: Soft, 0 8px 32px rgba(0, 0, 0, 0.4)
- Padding: 20-24px inside

VISUAL EFFECT:
- Clean, see-through, and structured.
- Creates a sense of depth and layering.
- Light appears to be captured and refracted through the edges.
- Floats elegantly above the background.

USAGE:
- Used for all primary containers: feed posts, goal cards, info panels, settings, etc.
- Border can adopt the accent color to signify an active or primary state.
```

---

## 🎯 Component Styles

### **Buttons**

**Primary Button (Filled):**
```
ANATOMY:
- Height: 50px
- Background: Electric Cyan
- Border: None
- Border radius: 25px (pill-shaped)
- Text: Black, SF Pro Text, Bold, 17pt
- State changes:
  - Hover: Slight scale up (1.02x)
  - Press: Scale down (0.98x), opacity reduces to 0.9

VISUAL EFFECT:
- Clean, clear call-to-action
- Modern and approachable
- Stands out with the accent color

USAGE:
- The most important actions on a screen (e.g., Check In, Save).
```

**Secondary Button (Glass):**
```
ANATOMY:
- Height: 50px
- Background: rgba(255, 255, 255, 0.1)
- Border: 1.5px solid rgba(255, 255, 255, 0.2)
- Backdrop blur: 30px
- Border radius: 25px (pill-shaped)
- Text: White or Electric Cyan, SF Pro Text, Semibold, 17pt

VISUAL EFFECT:
- Subtle and sophisticated.
- Complements the primary button without competing.

USAGE:
- Secondary actions (e.g., Cancel, View Details).
```

**Icon Button (Minimal):**
```
ANATOMY:
- Size: 44x44px (iOS touch target)
- Background: None
- Icon: 24x24px, colored white or Electric Cyan
- State changes: On tap, icon scales down and background shows a subtle glass highlight.

USAGE:
- Navigation bar icons, quick actions, toolbars.
```

---

### **Input Fields**

```
ANATOMY:
- Height: 50px
- Background: rgba(255, 255, 255, 0.1)
- Backdrop blur: 30px
- Border: 1.5px solid rgba(255, 255, 255, 0.2)
- Active border: 2px solid Electric Cyan
- Border radius: 12px
- Padding: 16px horizontal
- Text: White, 17pt
- Placeholder: Gray, 17pt

STATES:
- Default: Subtle glass field.
- Focus: Border becomes the accent color.
- Error: Border turns a cautionary red (one of the few exceptions to the single accent rule for usability).
```

---

### **Tags/Pills**

```
ANATOMY:
- Height: 32px
- Background: rgba(0, 240, 255, 0.15) (accent color at 15% opacity)
- Border: 1px solid rgba(0, 240, 255, 0.4)
- Border radius: 16px (fully rounded)
- Padding: 8px 16px
- Text: Electric Cyan, SF Pro Text, Bold, 13pt, UPPERCASE

VISUAL EFFECT:
- A subtle pop of color to denote status or categories.
- Clean and integrated with the glass aesthetic.

USAGE:
- Status indicators, pack badges, filter chips.
```

---

### **Progress Bars**

```
ANATOMY:
- Height: 8px
- Background: rgba(255, 255, 255, 0.1)
- Fill: Electric Cyan
- Border radius: 4px (rounded ends)
- Animation: Smooth, 0.5s ease-in-out
```

---

### **Icons & Emojis**

**Icon Style:**
```
SYSTEM ICONS (SF Symbols):
- Size: 20-28pt
- Weight: Medium or Semibold
- Color: Electric Cyan or white
- Style: Rounded when possible

EMOJI USAGE:
- Use native iOS emojis for personality.
- Should feel natural and not forced.
```

---

## 📱 Screen Layouts

### **Feed Screen (Main)**

```
LAYOUT:
┌─────────────────────────────┐
│ [≡] [APP_NAME]    [@User]   │ ← Floating glass header
├─────────────────────────────┤
│                             │
│ ┌─────────────────────────┐ │
│ │ 🔥 DAY 12   [→]         │ │ ← Streak widget (glass)
│ └─────────────────────────┘ │
│                             │
│ [Feed Cards Scroll Here]    │ ← Vertical scroll
│                             │   (standard list)
│ ┌─────────────────────────┐ │
│ │ Goal Card               │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ Goal Card               │ │
│ └─────────────────────────┘ │
│                             │
└─────────────────────────────┘
  [Goals] [Feed] [Pack] [You]  ← Glass tab bar
```

**DESIGN NOTES:**
- Full bleed (edge to edge).
- Background: A subtle, animated dark gradient.
- Cards: All cards are based on the refined Glass Card system.
- Scrolling: Smooth, 60fps with natural physics.

---

### **Goal Detail Screen**

```
LAYOUT:
┌─────────────────────────────┐
│ [←]              [•••]      │ ← Nav bar (glass)
│                             │
│        💪                   │ ← Emoji (72pt)
│                             │
│   MORNING GYM               │ ← Title (32pt, Bold)
│                             │
│ ┌─────────────────────────┐ │
│ │ 🔥 12 DAY STREAK        │ │ ← Glass card
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ Check-in: 7:00 AM       │ │ ← Glass card
│ │ Days: M T W T F         │ │
│ │ Pack: The Boys          │ │
│ │ Fine: $5 or 30min jail  │ │
│ └─────────────────────────┘ │
│                             │
│ [CHECK IN NOW]              │ ← Primary Button (Filled)
│                             │
└─────────────────────────────┘
```

---

## 🎭 Motion & Animation

### **Animation Principles**

```
1. FLUID & RESPONSIVE
   - Duration: 0.3-0.5s
   - Easing: ease-in-out, creating smooth transitions.
   - Animations should feel like a natural response to user input.

2. SUBTLE & PURPOSEFUL
   - Avoid jarring or overly aggressive effects.
   - Motion should guide the user and provide feedback, not distract.
   - Examples: gentle fades, subtle scaling, smooth sliding.

3. POLISHED
   - Every animation should feel high-quality and considered.
   - Strive for the level of polish seen in Apple's native apps.
```

### **Specific Animations**

**Button Press:**
```
1. User touches button.
2. Scale down to 0.98 with a haptic tap (light impact).
3. On release, scale back to 1.0 with a gentle spring.
4. Duration: 0.2s down, 0.3s up.
```

**Card Entry:**
```
1. Cards fade and slide in smoothly from the bottom.
2. Staggered by 0.05s to create a pleasant cascade effect.
3. Duration: 0.5s total.
```

**State Change:**
```
1. When a state changes (e.g., success), the relevant element might subtly pulse or the accent color may fade in.
2. Haptic feedback should match the state (e.g., success, error).
3. All transitions should be smooth and non-jarring.
```

---

## 🔊 Sound & Haptics

### **Haptic Feedback**

```
LIGHT IMPACT:
- Button taps
- Switches
- Selection changes
Usage: Frequent, subtle

MEDIUM IMPACT:  
- Check-in complete
- Card tap
- Pull to refresh
Usage: Important actions

HEAVY IMPACT:
- Fine activated
- Jail started
- Break jail
Usage: Critical moments

SUCCESS NOTIFICATION:
- Goal completed
- Streak milestone
- Payment succeeded
Usage: Positive reinforcement

WARNING NOTIFICATION:
- Timer running low
- Almost missed check-in
Usage: Attention needed

ERROR NOTIFICATION:
- Payment failed
- Check-in late
- Action blocked
Usage: Negative feedback
```

### **Sound Design**

```
OPTIONAL SOUNDS (User can disable):

CHECK-IN:
- Sound: Satisfying "ding" + cash register
- Volume: Medium
- Feel: Achievement unlocked

MISSED:
- Sound: Buzzer + descending tone
- Volume: Medium-loud
- Feel: Failure state

JAIL START:
- Sound: Prison door slam
- Volume: Loud
- Feel: Oh shit moment

JAIL TIMER:
- Sound: Ticking clock (every second)
- Volume: Quiet-medium
- Feel: Tension building

JAIL COMPLETE:
- Sound: Freedom bell + cheering
- Volume: Medium-loud
- Feel: Liberation

FINE ACTIVATED:
- Sound: Cash register + "cha-ching"
- Volume: Medium
- Feel: Money exchange

BREAK JAIL:
- Sound: Glass shatter + cash register
- Volume: Loud
- Feel: Escape
```

---

## 📸 Photography & Imagery

### **Photo Style**

```
CHECK-IN PHOTOS:
- Raw, unfiltered (like BeReal).
- Authenticity > aesthetics.

PROFILE PICS:
- Circular crop.
- 1.5px border, using the accent color or a subtle white.

PACK PHOTOS:
- Optional cover image with a dark overlay for text readability.
```

### **Illustration Style**

```
IF NEEDED (minimal usage):
- Geometric, simple, and clean.
- Use the accent color sparingly against a dark background.
- Thin, consistent stroke widths.

AVOID:
- Cute characters, pastel colors, corporate stock imagery.
```

---

## 🏷️ Naming Conventions

### **Feature Names**

```
GOOD (our style):
- Phone Jail (not "App Restriction")
- Pack (not "Group" or "Team")
- Fined (not "Penalized")
- Streak (not "Consistency Score")
- Check In (not "Log Activity")
- Broke Jail (not "Early Exit")

PRINCIPLES:
- Short, punchy
- Slang-friendly
- Memorable
- Not corporate
- Slightly aggressive
```

### **UI Copy**

```
BUTTONS:
✓ CHECK IN NOW
✓ FINE HIM
✓ BREAK JAIL - $10
✓ PAY UP

✗ Complete Check-In
✗ Activate Penalty
✗ Exit Early
✗ Submit Payment

NOTIFICATIONS:
✓ Tom's in jail 💀
✓ 5 min until check-in ⏱️
✓ You missed gym 🚨
✓ Jake broke out 😂

✗ User has entered restricted mode
✗ Reminder: Check-in window closing
✗ Missed activity detected
✗ Early termination occurred

ERROR MESSAGES:
✓ Yo, that didn't work
✓ Try again?
✓ Check your connection

✗ An error occurred
✗ Please retry
✗ Network unavailable
```

---

## 🎯 Brand Applications

### **App Icon**

```
CONCEPT:
- Pure black background.
- A simple, elegant symbol in the accent color.
- Minimalist and instantly recognizable.

REQUIREMENTS:
- High contrast.
- Memorable silhouette.
- No text.
```

### **App Store Screenshots**

```
LAYOUT:
- Clean, dark background.
- Showcases the actual UI within a device frame.
- Uses clean, bold typography (SF Pro) for headlines.
- Each screenshot highlights a key feature or value proposition.

STYLE:
- Headlines use the accent color or white.
- Focus on the elegance and clarity of the app.
```

---

## 🚫 Brand Don'ts

### **What We Never Do**

```
VISUAL:
✗ Cluttered or chaotic layouts.
✗ Multiple competing accent colors.
✗ Loud, aggressive, or brutalist elements.
✗ Light mode.

VOICE:
✗ Overly corporate or formal language.
✗ Gentle, coddling, or patronizing tones.
```

---

## ✅ Brand Guidelines Quick Reference

### **The Rules**

```
1. DARK MODE ONLY
   - The UI is always on a pure black or dark gray base.

2. SINGLE ACCENT
   - Use Electric Cyan for all primary interactive elements.
   - Use sparingly to draw attention effectively.

3. LIQUID GLASS
   - All containers and surfaces are frosted glass.
   - Emphasize depth through layering, blur, and soft shadows.

4. CLEAN TYPOGRAPHY
   - Use SF Pro for its native feel and readability.
   - Establish clear hierarchy with size and weight, not loud styling.

5. FLUID MOTION
   - Animations are smooth, subtle, and responsive.
   - Motion should feel natural and polished, like native iOS.
```

---

## 🏆 Competitive Differentiation

### **How We Stand Out Visually**

```
[APP_NAME]          | DARK, CLEAN, MINIMALIST
                    | Premium 'Liquid Glass' aesthetic
                    | Single, focused accent color
                    | Feels like a native Apple utility
```

---

## 📋 Brand Checklist

Before shipping any design, ask:

```
☐ Is the layout clean and uncluttered?
☐ Does it use the single accent color effectively?
☐ Does it feel like a premium, polished, native app?
☐ Is the typography clear and readable?
☐ Are the animations smooth and subtle?
☐ Does it adhere to the 'Liquid Glass' aesthetic (blur, transparency, layers)?
```
