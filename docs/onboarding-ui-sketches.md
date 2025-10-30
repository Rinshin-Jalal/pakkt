# Pakkt Onboarding UI Sketches & Guide
**27-Step Flow Design Specifications**

## Design System

### Typography
- **Headers:** System Bold, 28-32pt, tracking +2.0
- **Subheaders:** System Semibold, 20-24pt
- **Body:** System Regular/Medium, 16-17pt
- **Labels:** System Bold, 11-14pt, uppercase, tracking +1.0

### Colors
- **Primary:** System Blue (#007AFF)
- **Success:** Green (#34C759)
- **Warning:** Orange (#FF9500)
- **Error:** Red (#FF3B30)
- **Text Primary:** .primary (adaptive)
- **Text Secondary:** .secondary (adaptive)
- **Background:** .systemBackground (adaptive)

### Spacing
- **Section padding:** 24px horizontal, 40-60px vertical
- **Element spacing:** 12-24px between elements
- **Button height:** 56px minimum tap target
- **Corner radius:** 14-30px (14 for inputs, 30 for cards)

### Animations
- **Fade in:** 0.4s ease-out
- **Slide up:** 0.5s spring animation
- **Button press:** 0.2s scale(0.95)
- **Transitions:** Use .spring() for all view transitions

---

## ACT 1: HOOK (Steps 1-2)

### Step 1: WelcomeToPacktView
**Purpose:** Intrigue, not negativity. Set up the problem without being depressing.

```
┌─────────────────────────────┐
│                             │
│         [Pakkt Logo]        │ ← Animated fade-in
│                             │
│                             │
│    THERE'S A REASON         │ ← Header (32pt bold)
│    YOU KEEP FAILING         │    tracking +2.0
│                             │
│                             │
│  "You've tried willpower.   │ ← Body (17pt)
│   You've tried apps.        │    .secondary color
│   There's a better way."    │    centered
│                             │
│                             │
│                             │
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │    LET'S FIND OUT       │ │ ← Button (glass effect)
│ │         →               │ │    56px height
│ └─────────────────────────┘ │    Full width - 48px
│                             │
└─────────────────────────────┘
```

**Animations:**
- Logo fades in: 0-0.3s
- Header slides up: 0.3-0.8s
- Body fades in: 0.8-1.2s
- Button slides up: 1.2-1.5s

**Interactions:**
- Button: Scale to 0.95 on press, haptic light
- Auto-advance after 3s if no interaction (optional)

---

### Step 2: WhatIsPackView
**Purpose:** Simple explanation of pack concept. Educational but brief.

```
┌─────────────────────────────┐
│                             │
│      WHAT IS A PACK?        │ ← Header (28pt bold)
│                             │
│                             │
│  ┌───────────────────────┐  │
│  │   [Icon: 3-10 people] │  │ ← Visual card
│  │                       │  │    Glass effect
│  │   YOUR CREW           │  │    120px height
│  │   3-10 people who     │  │
│  │   hold you accountable│  │
│  └───────────────────────┘  │
│           +                 │
│  ┌───────────────────────┐  │
│  │   [Icon: Target]      │  │
│  │                       │  │
│  │   YOUR GOAL           │  │
│  │   The one thing you   │  │
│  │   keep failing at     │  │
│  └───────────────────────┘  │
│           +                 │
│  ┌───────────────────────┐  │
│  │   [Icon: ⚡️Stakes]    │  │
│  │                       │  │
│  │   REAL CONSEQUENCES   │  │
│  │   Cash fines. Phone   │  │
│  │   jail. Pack votes.   │  │
│  └───────────────────────┘  │
│           =                 │
│       SUCCESS ✨            │
│                             │
│ ┌─────────────────────────┐ │
│ │       CONTINUE →        │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Animations:**
- Cards cascade in: Each 0.2s apart
- "+" symbols fade in between cards
- "= SUCCESS" emphasizes with pulse

**Key Message:** Pack = Crew + Goal + Stakes

---

## ACT 2: PAIN (Steps 3-9)

### Step 3: GoalFailureInputView
**Purpose:** First personal question. Capture their goal with suggestions.

```
┌─────────────────────────────┐
│                             │
│                             │
│      LET'S GET REAL         │ ← Small header (20pt)
│                             │
│   What's the ONE goal       │ ← Big question (24pt)
│   you keep failing at?      │    semibold
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ Enter goal name...      │ │ ← Text field
│  └─────────────────────────┘ │    Auto-focus
│                             │    Glass effect
│                             │
│   SUGGESTIONS:              │ ← Label (11pt caps)
│                             │
│  ┌───────────────┐          │
│  │ 🏋️ Gym        │          │ ← Suggestion pills
│  │ (always skip) │          │    Tappable
│  └───────────────┘          │    2 columns
│  ┌───────────────┐          │
│  │ 📚 Study      │          │
│  │ (procrastinate)│         │
│  └───────────────┘          │
│  ┌───────────────┐          │
│  │ ⏰ Wake up    │          │
│  │ (hit snooze)  │          │
│  └───────────────┘          │
│  ┌───────────────┐          │
│  │ 🚫 No drinking│          │
│  │ (weekends fail)│         │
│  └───────────────┘          │
│                             │
│ ┌─────────────────────────┐ │
│ │      CONTINUE →         │ │ ← Disabled until
│ └─────────────────────────┘ │    text entered
└─────────────────────────────┘
```

**Interactions:**
- Tapping suggestion fills text field
- Text field has focus state
- Continue button: opacity 0.5 when disabled
- Keyboard dismisses on continue

---

### Step 4: WhyWillpowerFailsView (BREATHING STEP)
**Purpose:** Educational visual. No input required. Shows brain science.

```
┌─────────────────────────────┐
│                             │
│   YOUR BRAIN IS DESIGNED    │ ← Header (28pt)
│   TO AVOID PAIN             │
│                             │
│                             │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │    [Brain Diagram]    │  │ ← Animated visual
│  │                       │  │    180px height
│  │   Comfort Zone ⭕️    │  │    Shows brain
│  │   ←  🧠  →           │  │    seeking comfort
│  │   Willpower ❌        │  │
│  │   (depletes in 2hrs)  │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
│                             │
│  Motivation fades.          │ ← Body text
│  Excuses appear.            │    centered
│  You rationalize quitting.  │    .secondary
│                             │
│  That's why you need        │
│  EXTERNAL consequences.     │ ← Bold
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │    I GET IT NOW →       │ │ ← Just continue
│ └─────────────────────────┘ │    No input
└─────────────────────────────┘
```

**Animations:**
- Brain diagram animates: arrows pointing away from goal
- Text fades in paragraph by paragraph
- "EXTERNAL consequences" pulses once

---

### Step 5: FailurePatternView
**Purpose:** Quantify the pattern. Make them admit repetition.

```
┌─────────────────────────────┐
│                             │
│                             │
│   How many times have       │ ← Question (24pt)
│   you tried and quit?       │
│                             │
│                             │
│      [15 times]             │ ← Big number (48pt)
│                             │    Animated
│  ┌─────────────────────────┐ │
│  │    ○───────●────○       │ │ ← Slider
│  │    2        15      20+ │ │    Large touch
│  └─────────────────────────┘ │    target
│                             │
│                             │
│  That's 15 times you've     │ ← Dynamic text
│  disappointed yourself.     │    uses slider #
│                             │
│  It's not your fault—       │ ← Empathy
│  it's your method.          │    then pivot
│                             │
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │    UNFORTUNATELY →      │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Interactions:**
- Slider updates number in real-time
- Haptic feedback on slider movement
- Text updates dynamically with count
- Number pulses when slider released

---

### Step 6: FailedApproachesVisualView (BREATHING STEP)
**Purpose:** Show graveyard of failed methods. Visual storytelling.

```
┌─────────────────────────────┐
│                             │
│  YOU'VE TRIED EVERYTHING    │ ← Header
│                             │
│                             │
│  ┌──────────────┐           │
│  │ 📱 Tracking  │ ❌        │ ← Graveyard cards
│  │    Apps      │           │    Each with X
│  └──────────────┘           │    Glass effect
│       ⚰️                     │    RIP symbol
│                             │
│  ┌──────────────┐           │
│  │ 💪 Motivation│ ❌        │
│  │   Videos     │           │
│  └──────────────┘           │
│       ⚰️                     │
│                             │
│  ┌──────────────┐           │
│  │ 🏋️ Gym Buddy │ ❌        │
│  │ (flaked)     │           │
│  └──────────────┘           │
│       ⚰️                     │
│                             │
│  ┌──────────────┐           │
│  │ 💳 Paid      │ ❌        │
│  │   Programs   │           │
│  └──────────────┘           │
│       ⚰️                     │
│                             │
│  They all failed because    │ ← Key message
│  there were NO REAL STAKES. │    Bold stakes
│                             │
│ ┌─────────────────────────┐ │
│ │       EXACTLY →         │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Animations:**
- Cards fall in one by one with ❌ stamp
- Gravestones appear below
- Final message emphasizes

---

### Step 7: WhatYouveTriedView
**Purpose:** Personalize the graveyard. Which ones have THEY tried?

```
┌─────────────────────────────┐
│                             │
│  Which of these have        │ ← Question
│  YOU tried?                 │
│                             │
│  (Select all that apply)    │ ← Instruction
│                             │
│                             │
│  ☑️ Tracking apps           │ ← Checkboxes
│     (Streaks, HabitNow...)  │    Multi-select
│                             │    Glass cards
│  ☐  Motivation videos       │
│     (Tony Robbins, etc.)    │
│                             │
│  ☐  Gym buddy / Partner     │
│     (they flaked)           │
│                             │
│  ☐  Paid programs           │
│     ($99-500 wasted)        │
│                             │
│  ☐  Pure willpower          │
│     ("This time I mean it") │
│                             │
│  ☐  Rewards system          │
│     (treating yourself)     │
│                             │
│                             │
│  All of these failed        │ ← Appears after
│  because there was no       │    selections
│  REAL accountability.       │
│                             │
│ ┌─────────────────────────┐ │
│ │    SO WHAT WORKS? →     │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Interactions:**
- Tap anywhere on card to toggle
- Checkmark animates in
- Can select multiple
- Bottom text appears after 1+ selection

---

### Step 8: EmotionalImpactView
**Purpose:** Emotional admission. How does failure feel?

```
┌─────────────────────────────┐
│                             │
│                             │
│   Be honest with yourself.  │ ← Softer intro
│                             │
│   How does it feel when     │ ← Question (24pt)
│   you fail again?           │
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │                         │ │
│  │  [Text Area]            │ │ ← Text area
│  │                         │ │    140px height
│  │  Type your answer...    │ │    Placeholder
│  │                         │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│   OR CHOOSE:                │
│                             │
│  ┌──────────────┐           │
│  │ 😞 Ashamed   │           │ ← Emotion pills
│  └──────────────┘           │    Tappable
│  ┌──────────────┐           │    Fills text
│  │ 😤 Frustrated│           │
│  └──────────────┘           │
│  ┌──────────────┐           │
│  │ 😔 Disappointed│         │
│  └──────────────┘           │
│  ┌──────────────┐           │
│  │ 😣 Like a failure│       │
│  └──────────────┘           │
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │    CONTINUE →           │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Interactions:**
- Text area auto-focuses
- Tapping emotion pill fills text area with that emotion
- Can type custom or use pills
- Continue enabled after input

---

### Step 9: SuccessVisionView
**Purpose:** Flip to positive. Paint the transformation.

```
┌─────────────────────────────┐
│                             │
│   Now imagine...            │ ← Dreamy intro
│                             │
│   What would ACTUALLY       │ ← Question (24pt)
│   change if you succeeded?  │
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │                         │ │
│  │  [Text Area]            │ │ ← Text area
│  │                         │ │    140px height
│  │  Describe your          │ │
│  │  transformation...      │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│   EXAMPLES:                 │
│                             │
│  • More energy every day    │ ← Inspiring
│  • Confidence finally       │    examples
│  • Respect from friends     │
│  • Breaking the pattern     │
│  • Proving yourself         │
│                             │
│                             │
│  That future is possible.   │ ← Hopeful
│  You just need the right    │    transition
│  system.                    │
│                             │
│ ┌─────────────────────────┐ │
│ │   LET ME SHOW YOU →     │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Interactions:**
- Text area for custom vision
- Examples are not tappable, just inspiration
- Continue after input
- Transition to solution phase

---

## ACT 3: RELIEF (Steps 10-13)

### Step 10: ConsequencesVsWillpowerView (BREATHING STEP)
**Purpose:** Core principle. Visual comparison. Educational peak moment.

```
┌─────────────────────────────┐
│                             │
│   WILLPOWER FAILS.          │ ← Header (32pt)
│   CONSEQUENCES WIN.         │    Split design
│                             │
│                             │
│  ┌────────────┬────────────┐│
│  │ WILLPOWER  │ CONSEQUENCES││ ← Split screen
│  ├────────────┼────────────┤│    Visual compare
│  │            │            ││
│  │  🧠 Alone  │ 👥 Crew    ││
│  │            │            ││
│  │  💭 "I'll  │ ⚡ "You    ││
│  │  start     │  must or   ││
│  │  tomorrow" │  pay $20"  ││
│  │            │            ││
│  │  ⏰ Fails  │ 🎯 Works   ││
│  │  in 2hrs   │  24/7      ││
│  │            │            ││
│  │  ❌ 95%    │ ✅ Real    ││
│  │  quit      │  results   ││
│  │            │            ││
│  └────────────┴────────────┘│
│                             │
│                             │
│  Your brain avoids pain.    │ ← Key insight
│  That's why you need        │
│  EXTERNAL consequences      │
│  you can't ignore.          │
│                             │
│ ┌─────────────────────────┐ │
│ │  SHOW ME HOW THIS       │ │
│ │  WORKS →                │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Animations:**
- Split screen slides in from sides
- Items fade in sequentially
- "EXTERNAL consequences" pulses

---

### Step 11: HowPacktWorksView (BREATHING STEP)
**Purpose:** 3-part formula visualization. This is THE mechanism.

```
┌─────────────────────────────┐
│                             │
│   HERE'S HOW IT WORKS       │ ← Header
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │         [1]             │ │
│  │    👥 YOUR CREW         │ │ ← Step 1 card
│  │                         │ │    Glass effect
│  │  3-10 people who see    │ │    Animated in
│  │  everything you do      │ │
│  │                         │ │
│  └─────────────────────────┘ │
│            +                │
│  ┌─────────────────────────┐ │
│  │         [2]             │ │
│  │    🎯 YOUR GOAL         │ │ ← Step 2 card
│  │                         │ │
│  │  Check in daily at      │ │
│  │  your committed time    │ │
│  │                         │ │
│  └─────────────────────────┘ │
│            +                │
│  ┌─────────────────────────┐ │
│  │         [3]             │ │
│  │  ⚡ REAL CONSEQUENCES   │ │ ← Step 3 card
│  │                         │ │
│  │  Miss? Your pack votes. │ │
│  │  Cash fine or phone jail│ │
│  │  You CAN'T escape.      │ │
│  └─────────────────────────┘ │
│            =                │
│       ✨ SUCCESS            │ ← Result
│                             │
│ ┌─────────────────────────┐ │
│ │  SEE IT IN ACTION →     │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Animations:**
- Cards cascade in (0.2s apart)
- Plus signs fade in
- Equals and success emphasize

---

### Step 12: LivePackExampleView (BREATHING STEP)
**Purpose:** ONE powerful real example. Show the social dynamic.

```
┌─────────────────────────────┐
│                             │
│   REAL PACK IN ACTION       │ ← Header
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ 🐺 IRON WOLVES          │ │ ← Pack header
│  │ Gym • 4 members         │ │    Glass card
│  ├─────────────────────────┤ │
│  │                         │ │
│  │ Jake missed leg day     │ │ ← Feed item
│  │ Yesterday 6:00 PM       │ │    Real example
│  │                         │ │
│  │ ❌ MISSED CHECK-IN      │ │
│  │                         │ │
│  │ Pack voted:             │ │
│  │ ⚡ 1 hour phone jail    │ │
│  │                         │ │
│  │ 💬 Comments:            │ │
│  │                         │ │
│  │ Mike: "Dude, again?!    │ │ ← Real comments
│  │ That's 3 this week"     │ │    Show social
│  │                         │ │    pressure
│  │ Sarah: "Better show up  │ │
│  │ tomorrow or it's $20"   │ │
│  │                         │ │
│  │ Jake: "I know I know... │ │
│  │ no excuses tomorrow"    │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  Your crew sees everything. │ ← Key message
│  You can't hide.            │
│  That's why it works.       │
│                             │
│ ┌─────────────────────────┐ │
│ │  I WANT THIS →          │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Key Elements:**
- Realistic pack name/goal
- Actual consequence shown
- Real-feeling comments
- Social pressure visible

---

### Step 13: BrotherhoodFeaturesView (BREATHING STEP)
**Purpose:** Show the fun/social side. Not just punishment.

```
┌─────────────────────────────┐
│                             │
│  YOUR PACK IS MORE THAN     │ ← Header
│  CONSEQUENCES                │
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ 💬 TRASH TALK           │ │ ← Feature cards
│  │                         │ │    3 features
│  │ Roast friends who miss. │ │    Glass effect
│  │ Hype those who show up. │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ ⚡ JAIL YOUR FRIENDS    │ │
│  │                         │ │
│  │ Vote on consequences.   │ │
│  │ Democracy + Stakes.     │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ 🎉 CELEBRATE WINS       │ │
│  │                         │ │
│  │ Streak milestones.      │ │
│  │ Pack victories.         │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│                             │
│  It's accountability        │ ← Selling point
│  that's actually fun.       │
│                             │
│ ┌─────────────────────────┐ │
│ │  WHY THIS WORKS →       │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Animations:**
- Cards slide in from bottom
- Icons bounce in
- Text fades in

---

## ACT 4: BRIDGE (Step 14)

### Step 14: ValuePropositionView (BREATHING STEP)
**Purpose:** Final conviction builder before they commit to building.

```
┌─────────────────────────────┐
│                             │
│   YOU TRIED ALONE.          │ ← Header (28pt)
│   IT DIDN'T WORK.           │    3 sections
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ ❌ SOLO ATTEMPTS        │ │ ← Section 1
│  │                         │ │    Glass card
│  │ • Motivation faded      │ │    Red tint
│  │ • Excuses won           │ │
│  │ • Nobody noticed        │ │
│  │ • You gave up           │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ 📱 TRACKING APPS        │ │ ← Section 2
│  │                         │ │    Orange tint
│  │ • No real stakes        │ │
│  │ • Easy to ignore        │ │
│  │ • Just data             │ │
│  │ • Nobody cares          │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ ✅ PAKKT WORKS          │ │ ← Section 3
│  │                         │ │    Green tint
│  │ • Real people watching  │ │    Positive
│  │ • Actual consequences   │ │
│  │ • Can't ignore it       │ │
│  │ • Your crew enforces    │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│                             │
│  Ready to build your pack?  │ ← Transition
│                             │
│ ┌─────────────────────────┐ │
│ │   LET'S BUILD IT →      │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Animations:**
- Cards slide in sequentially
- Color tints emphasize feeling
- Final card pulses

---

## ACT 5: BUILD (Steps 15-23)

### Steps 15-23: Pack Creation Flow
**Note:** These are ALREADY DESIGNED and implemented from your previous work.
I'll just list them here for completeness:

**Step 15: PackFoundationView** ✅ Already perfect
**Step 16: PackIdentityView** ✅ Already perfect
**Step 17: GoalsCreationView** ✅ Already perfect
**Step 18: PackRulesView** ✅ Already perfect
**Step 19: PackConsequencesView** ✅ Already perfect
**Step 20: PackPreviewView** ✅ Already perfect
**Step 21: PackPactAgreementView** ✅ Already perfect
**Step 22: SignPackPactView** ✅ Already perfect
**Step 23: InvitePackMembersView** ✅ Already perfect

**These 9 steps stay exactly as you designed them.**

---

## ACT 6: URGENCY (Step 24)

### Step 24: CountdownToFirstChallengeView (BREATHING STEP)
**Purpose:** Create urgency. Make it real. Stakes start NOW.

```
┌─────────────────────────────┐
│                             │
│                             │
│   YOUR FIRST CHECK-IN       │ ← Header (28pt)
│   STARTS IN...              │
│                             │
│                             │
│        ┌───────┐            │
│        │  08   │            │ ← Big countdown
│        └───────┘            │    72pt bold
│         HOURS               │    Animated
│                             │    Real-time
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │                         │ │
│  │  Tomorrow at 6:00 AM    │ │ ← Details card
│  │                         │ │    Glass effect
│  │  Your pack expects you  │ │
│  │  to check in.           │ │
│  │                         │ │
│  │  Miss it?               │ │
│  │  They'll know.          │ │
│  │  They'll vote.          │ │
│  │  You'll pay.            │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│                             │
│  This is real.              │ ← Emphasis
│  No backing out now.        │
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │   I'M READY →           │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Animations:**
- Countdown number ticks in real-time
- Pulse animation every second
- Details card emphasizes stakes
- Creates nervous excitement

**Technical:**
- Calculate time until first check-in
- Update countdown every second
- Show hours/minutes remaining

---

## ACT 7: COMMIT (Steps 25-27)

### Step 25: PermissionsSetupView
**Purpose:** Get critical permissions. Combined into ONE screen.

```
┌─────────────────────────────┐
│                             │
│   YOUR PACK NEEDS TO        │ ← Header
│   REACH YOU                 │
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ 🔔 NOTIFICATIONS        │ │ ← Permission 1
│  │                         │ │    Toggle card
│  │ When your pack votes,   │ │
│  │ jails you, or trash     │ │
│  │ talks you.              │ │
│  │                         │ │
│  │           [Toggle: ON]  │ │ ← iOS toggle
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ ⏰ SCREEN TIME          │ │ ← Permission 2
│  │                         │ │    Toggle card
│  │ For phone jail          │ │
│  │ consequences. We can    │ │
│  │ actually lock your apps.│ │
│  │                         │ │
│  │           [Toggle: ON]  │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│                             │
│  ⚠️ Without these, your     │ ← Warning
│  pack can't enforce         │    .orange color
│  consequences.              │
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │   ENABLE & CONTINUE →   │ │ ← Triggers iOS
│ └─────────────────────────┘ │    permissions
└─────────────────────────────┘
```

**Interactions:**
- Toggles are for show (iOS handles actual permission)
- Button triggers iOS permission dialogs
- Can skip, but show warning
- Both permissions in ONE step

---

### Step 26: YourPackRealityView (BREATHING STEP)
**Purpose:** Emotional peak. Show them THEIR pack. Contrast with past.

```
┌─────────────────────────────┐
│                             │
│   THIS IS YOUR PACK'S       │ ← Header (28pt)
│   REALITY NOW               │
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ 🐺 THE GYM WOLVES       │ │ ← THEIR pack
│  │                         │ │    Uses actual
│  │ 5 Members • Daily Goal  │ │    data they
│  │                         │ │    entered
│  │ ✓ You                   │ │
│  │ ✓ Mike (invited)        │ │
│  │ ✓ Sarah (invited)       │ │
│  │ ✓ Alex (invited)        │ │
│  │ ✓ Jordan (invited)      │ │
│  │                         │ │
│  │ Morning workout at 6 AM │ │
│  │ Cash fine: $10          │ │
│  │ Phone jail: 30 min      │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│           VS                │ ← Contrast
│                             │
│  ┌─────────────────────────┐ │
│  │ BEFORE PAKKT            │ │ ← Past attempts
│  │                         │ │    Red/faded
│  │ ❌ You tried alone      │ │
│  │ ❌ Apps didn't work     │ │
│  │ ❌ Nobody held you      │ │
│  │ ❌ You always quit      │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  Now you have a crew.       │ ← Emotional
│  Now you have stakes.       │    message
│  Now you'll succeed.        │
│                             │
│ ┌─────────────────────────┐ │
│ │  LET'S MAKE IT          │ │
│ │  OFFICIAL →             │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

**Key Elements:**
- Uses their actual pack data
- Shows their invited members
- Contrasts with failed past
- Emotional peak before payment

---

### Step 27: PaywallView
**Purpose:** Convert to paid. Clear value, pricing, and CTA.

```
┌─────────────────────────────┐
│                             │
│   ACCOUNTABILITY THAT       │ ← Header
│   ACTUALLY WORKS            │
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ ✓ Your Pack (5 members) │ │ ← What they get
│  │ ✓ Daily Check-ins       │ │    Checklist
│  │ ✓ Real Consequences     │ │
│  │ ✓ Pack Voting           │ │
│  │ ✓ Phone Jail Enforcement│ │
│  │ ✓ Live Feed             │ │
│  │ ✓ Trash Talk & Support  │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│                             │
│  ┌─────────────────────────┐ │
│  │ 💎 PAKKT PREMIUM        │ │ ← Pricing card
│  │                         │ │    Glass effect
│  │   $16/month             │ │    Big price
│  │                         │ │
│  │   First 7 days free     │ │
│  │   Cancel anytime        │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│                             │
│  Less than your last        │ ← Value framing
│  failed gym membership.     │    Relatable
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │ START FREE TRIAL →      │ │ ← Primary CTA
│ └─────────────────────────┘ │    Prominent
│                             │
│  Restore Purchase           │ ← Secondary
│                             │
└─────────────────────────────┘
```

**After Successful Payment:**

```
┌─────────────────────────────┐
│                             │
│                             │
│         [Pakkt Logo]        │ ← Success state
│                             │
│                             │
│      WELCOME TO PAKKT       │ ← Celebration
│                             │
│                             │
│  Your pack is waiting.      │ ← Message
│  Your first check-in is     │
│  in 8 hours.                │
│                             │
│  Don't let them down.       │
│                             │
│                             │
│                             │
│ ┌─────────────────────────┐ │
│ │   ENTER THE APP →       │ │ ← Final CTA
│ └─────────────────────────┘ │
│                             │
└─────────────────────────────┘
```

**Interactions:**
- Pricing card is prominent
- Free trial emphasized
- Payment via iOS StoreKit
- Success animation after purchase

---

## Design Guidelines Summary

### Motion Design
- **Page transitions:** .spring(response: 0.5, dampingFraction: 0.8)
- **Element animations:** Cascade with 0.2s delays
- **Emphasis:** Pulse scale(1.05) for 0.3s
- **Haptics:** Light on taps, medium on completion

### Content Principles
- **One concept per screen:** Don't overload
- **Visual breathing room:** 40-60px top/bottom padding
- **Clear hierarchy:** Large headers, readable body text
- **Alternate rhythm:** Question → Visual → Question → Visual

### Emotional Arc
- Steps 1-2: Intrigue
- Steps 3-9: Pain (building)
- Steps 10-13: Relief (solution)
- Step 14: Conviction
- Steps 15-23: Building (empowerment)
- Step 24: Urgency
- Steps 25-27: Commitment

---

## Implementation Notes

### Data Flow
```swift
// OnboardingData needs these new properties:
@Published var goalName: String = ""
@Published var failureCount: Int = 15
@Published var failedApproaches: [String] = []
@Published var emotionalImpact: String = ""
@Published var successVision: String = ""
@Published var firstCheckInTime: Date = Date()
```

### View Files to Create
```
NEW FILES:
- WelcomeToPacktView.swift (Step 1)
- WhatIsPackView.swift (Step 2)
- GoalFailureInputView.swift (Step 3)
- WhyWillpowerFailsView.swift (Step 4)
- FailurePatternView.swift (Step 5)
- FailedApproachesVisualView.swift (Step 6)
- WhatYouveTriedView.swift (Step 7)
- EmotionalImpactView.swift (Step 8)
- SuccessVisionView.swift (Step 9)
- ConsequencesVsWillpowerView.swift (Step 10)
- HowPacktWorksView.swift (Step 11)
- LivePackExampleView.swift (Step 12)
- BrotherhoodFeaturesView.swift (Step 13)
- ValuePropositionView.swift (Step 14)
- CountdownToFirstChallengeView.swift (Step 24)
- PermissionsSetupView.swift (Step 25)
- YourPackRealityView.swift (Step 26)
- PaywallView.swift (Step 27)

KEEP EXISTING:
- PackFoundationView.swift (Step 15) ✅
- PackIdentityView.swift (Step 16) ✅
- GoalsCreationView.swift (Step 17) ✅
- PackRulesView.swift (Step 18) ✅
- PackConsequencesView.swift (Step 19) ✅
- PackPreviewView.swift (Step 20) ✅
- PackPactAgreementView.swift (Step 21) ✅
- SignPackPactView.swift (Step 22) ✅
- InvitePackMembersView.swift (Step 23) ✅
```

### Controller Updates
```swift
// OnboardingFlowController.swift
let totalSteps = 27  // Updated from 31

// Update switch statement (steps 1-27)
```

---

## Next Steps

1. **Review these sketches** - Any changes needed?
2. **Create new view files** - 18 new views needed
3. **Update existing views** - Minor tweaks to 9 existing
4. **Update controller** - New flow order
5. **Update data model** - Add new properties
6. **Test complete flow** - 27-step experience

Ready to start implementation?
