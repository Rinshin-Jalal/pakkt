# Pakkt Page-by-Page Mockups & Microcopy

## Overview
Complete screen-by-screen mockups with detailed microcopy for all 33 steps of Pakkt's onboarding experience. Each page includes visual layout specifications, exact text copy, interaction details, and psychological triggers.

---

## Design System Reference

### Typography
```
Headers: SF Pro Display, ALL CAPS, tracking 2.0
Body: SF Pro Text, regular weight
Buttons: SF Pro Rounded, medium weight
Numbers: SF Mono, for stats and timers
```

### Color Palette
```
Pure Black: #000000 (backgrounds)
Deep Gray: #0A0A0A (elevated surfaces)
Electric Cyan: #00F0FF (primary actions, highlights)
Glass Fill: rgba(255,255,255,0.1) (cards)
Glass Border: rgba(255,255,255,0.2) (borders)
Text Primary: #FFFFFF (main text)
Text Secondary: rgba(255,255,255,0.7) (supporting text)
```

---

## Phase 1: The Raw Reality (Steps 1-4)

### Step 1: The Relatable Failure

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│         📱 MISSED GYM AGAIN         │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  [iPhone Mockup]           │  │
│    │  Status Bar: LTE  🔋 100%   │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ 7:00 AM              │   │
│    │  │ Gym Pack ❌          │   │
│    │  │ Missed check-in      │   │
│    │  └─────────────────────┘   │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ 7:15 AM              │   │
│    │  │ Gym Pack ❌          │   │
│    │  │ 15 min late          │   │
│    │  └─────────────────────┘   │  │
│    │  ┌─────────────────────┐   │
│    │  │ 7:30 AM              │   │
│    │  │ Gym Pack ❌          │   │
│    │  │ Window closed       │   │
│    │  └─────────────────────┘   │
│    │  ┌─────────────────────┐   │
│    │  │ 8:00 AM              │   │
│    │  │ Gym Pack ❌          │   │
│    │  │ You missed it        │   │
│    │  └─────────────────────┘   │
│    │                             │  │
│    │  3 missed check-ins       │  │
│    │  0 pack members showed    │  │
│    │  Nobody even noticed      │  │
│    └─────────────────────────────┘  │
│                                     │
│         [TAP TO CONTINUE]          │
│                                     │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "MISSED GYM AGAIN"
- **Notification Text**: "Gym Pack ❌ Missed check-in"
- **Status Messages**: "15 min late", "Window closed", "You missed it"
- **Summary**: "3 missed check-ins. 0 pack members showed. Nobody even noticed."
- **CTA**: "TAP TO CONTINUE"

**Interaction Details:**
- **Tap Target**: Full screen (anywhere advances)
- **Animation**: Phone vibrates on load, notifications fade in sequentially
- **Sound**: Subtle notification sounds for each missed alert
- **Haptic**: Light vibration on appearance

**Psychology:**
- **Loss Aversion**: Shows what user is losing (progress, consistency)
- **Social Isolation**: "Nobody even noticed" emphasizes solo failure
- **Pattern Recognition**: Multiple missed notifications show habit

---

### Step 2: The Social Truth

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      ← SWIPE FROM ALONE TO PACK →   │
│                                     │
│  ┌─────────────┐ ┌─────────────────┐│
│  │   ALONE     │ │     WITH PACK   ││
│  │             │ │                 ││
│  │ 😞          │ │ 💪              ││
│  │ "Skipped"   │ │ "Where were    ││
│  │ "Again?"    │ │ you?"           ││
│  │ "Whatever"  │ │ "We waited!"   ││
│  │             │ │ "Dude, wtf?"   ││
│  │             │ │                 ││
│  │ 📱          │ │ 📱             ││
│  │ No texts    │ │ 5 missed texts ││
│  │ No calls    │ │ 2 angry calls  ││
│  │             │ │                 ││
│  │ 💔          │ │ 🤝             ││
│  │ Let down    │ │ Has your back  ││
│  │ Yourself    │ │ Won't let quit ││
│  └─────────────┘ └─────────────────┘│
│                                     │
│      Alone? You fail.              │
│    With your boys? You show up.     │
│         Every time.                 │
│                                     │
│      [SWIPE TO PACK SIDE]          │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "SWIPE FROM ALONE TO PACK"
- **Alone Side**: "Skipped", "Again?", "Whatever", "No texts", "No calls", "Let down yourself"
- **Pack Side**: "Where were you?", "We waited!", "Dude, wtf?", "5 missed texts", "2 angry calls", "Has your back", "Won't let quit"
- **Bottom Text**: "Alone? You fail. With your boys? You show up. Every time."
- **CTA**: "SWIPE TO PACK SIDE"

**Interaction Details:**
- **Gesture**: Horizontal swipe (left to right)
- **Threshold**: 50% screen width to complete
- **Animation**: Smooth transition with bounce at completion
- **Sound**: Satisfying click when crossing threshold
- **Haptic**: Medium vibration on successful swipe

**Psychology:**
- **Social Comparison Theory**: Shows clear difference between outcomes
- **Belonging**: Pack side offers acceptance and support
- **Accountability**: Multiple contact points create pressure

---

### Step 3: The Real Consequences

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│         📱 PHONE JAIL DEMO          │
│                                     │
│    ┌─────────────────────────────┐  │
│    │   [Phone Jail Screen]      │  │
│    │  Status Bar: JAIL ⏱️ 28:45 │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ ⏱️  28:45 remaining  │   │
│    │  │                     │   │
│    │  │  SERVING TIME FOR:   │   │
│    │  │  Missed Gym Pack     │   │
│    │  │  7:00 AM check-in    │   │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  ┌─────────────────────┐   │  │
│    │  │  BLOCKED APPS:      │   │
│    │  │  ┌─────┐ ┌─────┐   │  │
│    │  │  │ 📷   │ │ 🎵   │   │  │
│    │  │  │ IG   │ │ Tik  │   │  │
│    │  │  │ ❌   │ │ ❌   │   │  │
│    │  │  └─────┘ └─────┘   │  │
│    │  │  ┌─────┐ ┌─────┐   │  │
│    │  │  │ 🐦   │ │ 📱   │   │
│    │  │  │ Twit │ │ Snap │   │
│    │  │  │ ❌   │ │ ❌   │   │
│    │  │  └─────┘ └─────┘   │  │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  ⚠️  Timer pauses if you     │  │
│    │      leave this app         │  │
│    │                             │  │
│    │  [TRY TO ESCAPE]            │  │
│    └─────────────────────────────┘  │
│                                     │
│      Miss gym? Your boys lock     │
│      you out for 30 minutes.      │
│         No escape.                │
│                                     │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "PHONE JAIL DEMO"
- **Status Bar**: "JAIL ⏱️ 28:45"
- **Timer**: "28:45 remaining"
- **Jail Reason**: "SERVING TIME FOR: Missed Gym Pack, 7:00 AM check-in"
- **Blocked Apps**: "BLOCKED APPS:" with Instagram, TikTok, Twitter, Snapchat (all with ❌)
- **Warning**: "⚠️ Timer pauses if you leave this app"
- **CTA Button**: "TRY TO ESCAPE"
- **Bottom Text**: "Miss gym? Your boys lock you out for 30 minutes. No escape."

**Interaction Details:**
- **Escape Button**: Taps trigger shake animation + "Can't escape!" toast
- **Timer**: Counts down in real-time (smooth second transitions)
- **Blocked Apps**: Tap shows "Blocked - Serve your time first" tooltip
- **Background**: Dark red tint overlay on jail screen
- **Sound**: Timer tick sound, error sound on escape attempt

**Psychology:**
- **Loss Aversion**: Losing access to preferred apps
- **Control**: User can't escape, demonstrating real consequences
- **Authority**: Pack has legitimate power over user's phone

---

### Step 4: The Pakkt Promise

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│        🎉 PAKKT PROMISE             │
│                                     │
│    ┌─────────────────────────────┐  │
│    │   [Pack Success Scene]     │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │ Jake │ │ Sarah│ │ Mike │   │
│    │  │ 💪✅ │ │ 📚✅ │ │ ⏰✅ │   │
│    │  │ 7AM  │ │ 6PM  │ │ 8AM  │   │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │                             │  │
│    │  🎉 Pack celebrates!      │  │
│    │  "Everyone crushed it!"   │  │
│    │  "100% check-in rate!"    │  │
│    │  "Streak: 15 days 🔥"     │  │
│    │                             │  │
│    │  💰 No fines this week     │  │
│    │  📱 No jail time served    │  │
│    │  🏆 Pack of the week       │  │
│    └─────────────────────────────┘  │
│                                     │
│      Pakkt = Your crew holds      │
│      you accountable. Real        │
│      consequences. Real results.  │
│                                     │
│           [I'M IN] ✅              │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "PAKKT PROMISE"
- **Success Messages**: "Everyone crushed it!", "100% check-in rate!", "Streak: 15 days 🔥"
- **Celebration**: "Pack celebrates!"
- **Benefits**: "No fines this week", "No jail time served", "Pack of the week"
- **Value Prop**: "Pakkt = Your crew holds you accountable. Real consequences. Real results."
- **CTA**: "I'M IN"

**Interaction Details:**
- **CTA Button**: Large pill button with electric cyan fill
- **Member Cards**: Tap to see individual stats
- **Streak Fire**: Animated flame effect
- **Celebration**: Confetti animation on load
- **Sound**: Success chime, celebration sounds

**Psychology:**
- **Reward Anticipation**: Shows positive outcomes
- **Social Proof**: "Everyone crushed it" demonstrates pack success
- **Achievement**: "Pack of the week" creates aspiration

---

## Phase 2: What's a Pack? (Steps 5-8)

### Step 5: Pack Definition

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│         🐺 WHAT'S A PACK?           │
│                                     │
│    ┌─────────────────────────────┐  │
│    │   [Pack Formation Animation]│  │
│    │                             │  │
│    │   👤 + 👤 + 👤              │  │
│    │      ↓                      │  │
│    │   🐺 PACK 🐺                │  │
│    │      ↓                      │  │
│    │   💪💪💪                   │  │
│    │   ✅✅✅                   │  │
│    │                             │  │
│    │   3-10 friends who won't    │  │
│    │   let you quit              │  │
│    │   Real consequences         │  │
│    │   Real accountability       │  │
│    └─────────────────────────────┘  │
│                                     │
│      A pack is your accountability │
│      crew. Real friends. Real      │
│      pressure. Real results.       │
│                                     │
│         [TAP DIFFERENT SIZES]      │
│    ┌─────┐ ┌─────┐ ┌─────┐         │
│    │  3  │ │  5  │ │  8  │         │
│    │ 👥  │ │ 👥  │ │ 👥  │         │
│    │ Core│ │ Squad│ │ Crew │         │
│    └─────┘ └─────┘ └─────┘         │
│                                     │
│      Packs of 3-10 work best       │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "WHAT'S A PACK?"
- **Animation Labels**: "3-10 friends who won't let you quit", "Real consequences", "Real accountability"
- **Definition**: "A pack is your accountability crew. Real friends. Real pressure. Real results."
- **Size Options**: "Core", "Squad", "Crew"
- **Guidance**: "Packs of 3-10 work best"
- **CTA**: "TAP DIFFERENT SIZES"

**Interaction Details:**
- **Size Buttons**: Tap triggers new formation animation
- **Animation**: Smooth transitions between different pack sizes
- **Labels**: Dynamic text updates based on selected size
- **Sound**: Formation sound, click on size selection
- **Haptic**: Light vibration on size change

**Psychology:**
- **Social Identity**: "Core", "Squad", "Crew" create belonging
- **Clear Definition**: Explains concept simply and effectively
- **Optimal Range**: "3-10 work best" guides user to success

---

### Step 6: The Power of Consequences

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      💰 REAL CONSEQUENCES           │
│                                     │
│    ← SWIPE FROM WEAK TO STRONG →    │
│                                     │
│  ┌─────────────┐ ┌─────────────────┐│
│  │   WILLPOWER │ │   CONSEQUENCES   ││
│  │             │ │                 ││
│  │ 😞          │ │ 💰              ││
│  │ "Feel bad"  │ │ "Pay $5"        ││
│  │ "Try again" │ │ "Phone jail"    ││
│  │ "Maybe tomorrow"│ │ "Show up"    ││
│  │             │ │                 ││
│  │ 📊          │ │ 📊              ││
│  │ 20% success │ │ 95% success     ││
│  │ rate        │ │ rate            ││
│  │             │ │                 ││
│  │ ⏰          │ │ ⏰              ││
│  │ "I'll get   │ │ "Can't skip"    ││
│  │  to it"     │ │ "Boys waiting"  ││
│  └─────────────┘ └─────────────────┘│
│                                     │
│      Willpower fails.              │
│      Money talks.                  │
│      Phone jail screams.           │
│                                     │
│      [SWIPE TO CONSEQUENCES]       │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "REAL CONSEQUENCES"
- **Willpower Side**: "Feel bad", "Try again", "Maybe tomorrow", "20% success rate", "I'll get to it"
- **Consequences Side**: "Pay $5", "Phone jail", "Show up", "95% success rate", "Can't skip", "Boys waiting"
- **Bottom Text**: "Willpower fails. Money talks. Phone jail screams."
- **CTA**: "SWIPE TO CONSEQUENCES"

**Interaction Details:**
- **Swipe Gesture**: Horizontal swipe (left to right)
- **Success Rates**: Animated numbers that change on swipe
- **Visual Weight**: Consequences side has electric cyan glow
- **Sound**: Swoosh effect on swipe, cash register sound on consequences
- **Haptic**: Medium vibration on crossing threshold

**Psychology:**
- **Effectiveness**: Shows clear difference in success rates
- **Motivation Types**: Appeals to different motivational triggers
- **Proof**: "95% success rate" provides evidence

---

### Step 7: Real Pack Examples

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│        🔥 LIVE PACK FEEDS           │
│                                     │
│    ┌─────────────────────────────┐  │
│    │   GYM PACK - "Iron Wolves"   │  │
│    │  Jake missed leg day 💀      │  │
│    │  $5 fine incoming ⏳         │  │
│    │  👥 3/4 checked in today     │  │
│    │  💬 "Dude, again?!" - Mike    │  │
│    │  💬 "Pay up!" - Sarah        │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │   STUDY PACK - "Brain Trust" │  │
│    │  Sarah crushed chem 📚      │  │
│    │  15-day streak 🔥           │  │
│    │  👥 5/5 studied tonight     │  │
│    │  💬 "Queen!" - Mike         │  │
│    │  💬 "Let's go!" - Tom       │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │   NO-DRINK PACK - "Sober Squad"│  │
│    │  Mike survived Tuesday 🎉   │  │
│    │  Pack proud! 🙌             │  │
│    │  👥 4/4 stayed sober        │  │
│    │  💬 "Legend!" - Jake        │  │
│    │  💬 "Wednesday too?" - Sarah │  │
│    └─────────────────────────────┘  │
│                                     │
│    47,823 packs active right now   │
│         [SWIPE THROUGH MORE]       │
│    [TAP ANY PACK FOR DETAILS]     │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "LIVE PACK FEEDS"
- **Pack Names**: "Iron Wolves", "Brain Trust", "Sober Squad"
- **Activity Updates**: "Jake missed leg day 💀", "Sarah crushed chem 📚", "Mike survived Tuesday 🎉"
- **Comments**: "Dude, again?!", "Pay up!", "Queen!", "Let's go!", "Legend!", "Wednesday too?"
- **Stats**: "47,823 packs active right now"
- **CTAs**: "SWIPE THROUGH MORE", "TAP ANY PACK FOR DETAILS"

**Interaction Details:**
- **Feed Cards**: Tap for detailed pack view
- **Swipe**: Vertical scroll to see more packs
- **Live Updates**: Simulated real-time data refresh
- **Comments**: Tap to see full conversation
- **Sound**: Notification sounds for updates

**Psychology:**
- **Social Proof**: "47,823 packs active" shows popularity
- **Authenticity**: Real comments and reactions
- **FOMO**: Live activity creates urgency to join

---

### Step 8: The Brotherhood

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│        🤝 BROTHERHOOD ENERGY        │
│                                     │
│    ┌─────────────────────────────┐  │
│    │   [Fast-Cut Pack Montage]   │  │
│    │                             │  │
│    │  💪 Gym celebration         │  │
│    │  "Everyone crushed today!"  │  │
│    │                             │  │
│    │  😂 Jail time reactions      │  │
│    │  "I can't escape! 💀"       │  │
│    │  "30 minutes of hell"       │  │
│    │                             │  │
│    │  🏆 Streak flexing           │  │
│    │  "Day 50 baby! 🔥"          │  │
│    │  "Never skipping again"     │  │
│    │                             │  │
│    │  💸 Fine payments            │  │
│    │  "Worth it lol"             │  │
│    │  "Next time I'm there"      │  │
│    │                             │  │
│    │  📱 Check-in notifications   │  │
│    │  "Where are you?!"          │  │
│    │  "2 minutes late!"          │  │
│    └─────────────────────────────┘  │
│                                     │
│      Your pack has your back.     │
│      And your wallet.             │
│      And your phone.              │
│                                     │
│         [WATCH THE CHAOS]          │
│    [TAP TO SKIP DEMO]              │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "BROTHERHOOD ENERGY"
- **Montage Quotes**: "Everyone crushed today!", "I can't escape! 💀", "30 minutes of hell", "Day 50 baby! 🔥", "Never skipping again", "Worth it lol", "Next time I'm there", "Where are you?!", "2 minutes late!"
- **Value Prop**: "Your pack has your back. And your wallet. And your phone."
- **CTAs**: "WATCH THE CHAOS", "TAP TO SKIP DEMO"

**Interaction Details:**
- **Video Montage**: 15-second loop of pack interactions
- **Skip Option**: Tap to skip demo (for impatient users)
- **Volume Control**: Adjustable sound for montage
- **Full Screen**: Double-tap for fullscreen view
- **Sound**: Overlay of pack sounds, notifications, reactions

**Psychology:**
- **Entertainment**: Fun, engaging content holds attention
- **Authenticity**: Real reactions, not staged content
- **Social Energy**: Shows pack as fun, not just punishment

---

## Phase 3: Data Collection & Personal Investment (Steps 9-16)

### Step 9: The Personal Question

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      🎯 LET'S GET REAL              │
│                                     │
│    What's the ONE goal you keep     │
│    failing at alone?                │
│                                     │
│    ┌─────────────────────────────┐  │
│    │ [Text Input Field]          │  │
│    │                             │  │
│    │ Gym                         │  │
│    │                             │  │
│    │ 💭 Be honest. No judgment. │  │
│    └─────────────────────────────┘  │
│                                     │
│    Common struggles:                │
│    ┌─────┐ ┌─────┐ ┌─────┐         │
│    │ Gym │ │Study│ │Wake │         │
│    │ 💪  │ │ 📚  │ │ ⏰  │         │
│    │(always│ │(procras│ │(snooze│         │
│    │ skip) │ │ tinate)│ │  button)│         │
│    └─────┘ └─────┘ └─────┘         │
│                                     │
│    ┌─────┐ ┌─────┐ ┌─────┐         │
│    │ No  │ │Read │ │Code │         │
│    │Drink│ │ 📖  │ │ 💻  │         │
│    │ 🍺  │ │(never│ │(side   │         │
│    │(weekends│ │ finish)│ │ project)│         │
│    │ fail) │ │     │ │     │         │
│    └─────┘ └─────┘ └─────┘         │
│                                     │
│            [CONTINUE]               │
│    [SKIP QUESTION →]               │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "LET'S GET REAL"
- **Question**: "What's the ONE goal you keep failing at alone?"
- **Input Helper**: "💭 Be honest. No judgment."
- **Common Struggles**: 
  - "Gym (always skip)"
  - "Study (procrastinate)"
  - "Wake up (snooze button)"
  - "No drink (weekends fail)"
  - "Read (never finish)"
  - "Code (side project)"
- **CTAs**: "CONTINUE", "SKIP QUESTION →"

**Interaction Details:**
- **Text Input**: Keyboard with auto-suggestions
- **Quick Select**: Tap common struggles to auto-fill
- **Skip Option**: Users can skip if uncomfortable
- **Validation**: Minimum 2 characters required
- **Sound**: Keyboard sounds, satisfying click on selection

**Psychology:**
- **Vulnerability**: Encourages honest self-assessment
- **Normalization**: "Common struggles" shows user isn't alone
- **Investment**: Personal confession creates buy-in

---

### Step 10: The Emotional Impact

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      💭 HOW DOES IT FEEL?           │
│                                     │
│    Rate the emotional impact of      │
│    failure vs success:               │
│                                     │
│    ┌─────────────────────────────┐  │
│    │     WHEN I [GOAL] ❌         │  │
│    │                             │  │
│    │  😞  😔  😒  😑  🙁        │  │
│    │  ↓   ↓   ↓   ↓   ↓         │  │
│    │ 1   2   3   4   5          │  │
│    │                             │  │
│    │ Disappointed  Weak  Guilty  │  │
│    │ Frustrated   Useless  Stuck │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │     WHEN I [GOAL] ✅         │  │
│    │                             │  │
│    │  🙂  😊  😄  🤩  🥰        │  │
│    │  ↑   ↑   ↑   ↑   ↑         │  │
│    │ 6   7   8   9   10         │  │
│    │                             │  │
│    │ Pleased  Happy  Proud      │  │
│    │ Energized  Unstoppable  On │  │
│    │                              top │  │
│    └─────────────────────────────┘  │
│                                     │
│    Your emotional gap:             │
│    😞❌😊✅ = [calculated difference] │
│                                     │
│            [CONTINUE]               │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "HOW DOES IT FEEL?"
- **Instructions**: "Rate the emotional impact of failure vs success:"
- **Failure Labels**: "Disappointed", "Weak", "Guilty", "Frustrated", "Useless", "Stuck"
- **Success Labels**: "Pleased", "Happy", "Proud", "Energized", "Unstoppable", "On top"
- **Gap Calculation**: "Your emotional gap: 😞❌😊✅ = [calculated difference]"
- **CTA**: "CONTINUE"

**Interaction Details:**
- **Dual Sliders**: Independent rating for failure and success
- **Emotion Faces**: Animated based on slider position
- **Gap Calculation**: Real-time difference calculation
- **Visual Feedback**: Emotion faces animate and scale
- **Sound**: Satisfying click on emotion selection

**Psychology:**
- **Emotional Awareness**: Helps user recognize feelings
- **Motivation**: Larger gap increases desire for success
- **Self-Reflection**: Encourages honest emotional assessment

---

---

### Step 11: The Cost Analysis

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      💸 WHAT'S IT COSTING YOU?      │
│                                     │
│    Let's calculate the real cost    │
│    of failing at [GOAL]:            │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  💰 FINANCIAL COSTS         │  │
│    │                             │  │
│    │  Gym membership: $50/month   │  │
│    │  × 3 weeks skipped = $150    │  │
│    │                             │  │
│    │  Personal trainer: $400     │  │
│    │  (wasted on skipped weeks)  │  │
│    │                             │  │
│    │  Total wasted: $550/month   │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  ⏰ TIME COSTS              │  │
│    │                             │  │
│    │  Planned workouts: 12/week  │  │
│    │  Actual workouts: 3/week     │  │
│    │                             │  │
│    │  9 hours wasted each week    │  │
│    │  36 hours wasted this month   │  │
│    │                             │  │
│    │  That's 1.5 full days!       │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  💭 OPPORTUNITY COSTS       │  │
│    │                             │  │
│    │  Lost progress: -2lbs muscle │  │
│    │  Energy levels: -30%         │  │
│    │  Confidence: -40%            │  │
│    │  Social status: -25%         │  │
│    └─────────────────────────────┘  │
│                                     │
│    Total monthly cost: $550 + 36h  │
│    + declining health + confidence  │
│                                     │
│            [CONTINUE]               │
│    [USE DIFFERENT NUMBERS]         │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "WHAT'S IT COSTING YOU?"
- **Instructions**: "Let's calculate the real cost of failing at [GOAL]:"
- **Financial Costs**: "Gym membership: $50/month", "× 3 weeks skipped = $150", "Personal trainer: $400", "Total wasted: $550/month"
- **Time Costs**: "Planned workouts: 12/week", "Actual workouts: 3/week", "9 hours wasted each week", "36 hours wasted this month", "That's 1.5 full days!"
- **Opportunity Costs**: "Lost progress: -2lbs muscle", "Energy levels: -30%", "Confidence: -40%", "Social status: -25%"
- **Summary**: "Total monthly cost: $550 + 36h + declining health + confidence"
- **CTAs**: "CONTINUE", "USE DIFFERENT NUMBERS"

**Interaction Details:**
- **Input Fields**: Editable numbers for personalization
- **Calculations**: Real-time math updates as user types
- **Visual Impact**: Red emphasis on growing costs
- **Category Tabs**: Switch between financial, time, opportunity costs
- **Sound**: Cash register sound on financial calculations

**Psychology:**
- **Loss Aversion**: Shows concrete losses
- **Urgency**: Time wasted creates immediate concern
- **Investment Protection**: User wants to protect existing investments

---

### Step 12: The Social Circle

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      👥 WHO'S GOT YOUR BACK?        │
│                                     │
│    Who in your life would actually   │
│    hold you accountable for [GOAL]?  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🏋️ GYM FRIENDS            │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │ Jake │ │ Mike │ │ Tom  │   │  │
│    │  │ 💪  │ │ 💪  │ │ 💪  │   │  │
│    │  │[+]  │ │[+]  │ │[+]  │   │  │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │  "Already goes to gym"       │  │
│    │  "Same schedule"             │  │
│    │  "Competitive"               │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  📚 STUDY BUDDIES           │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐           │  │
│    │  │ Sarah│ │ Lisa │           │  │
│    │  │ 📚  │ │ 📚  │           │  │
│    │  │[+]  │ │[+]  │           │  │
│    │  └─────┘ └─────┘           │  │
│    │  "Same major"               │  │
│    │  "Study partner"            │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🏠 ROOMMATES/FAMILY       │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐           │  │
│    │  │ Alex │ │ Mom  │           │  │
│    │  │ ⏰  │ │ 👩  │           │  │
│    │  │[+]  │ │[+]  │           │  │
│    │  └─────┘ └─────┘           │  │
│    │  "Sees your routine"        │  │
│    │  "Worried about you"        │  │
│    └─────────────────────────────┘  │
│                                     │
│    Selected: 0/5 minimum needed   │
│    ████████░░░░░░░░░░░░░░░░░░░░░░   │
│                                     │
│            [CONTINUE]               │
│    [ADD CUSTOM CONTACT]             │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "WHO'S GOT YOUR BACK?"
- **Question**: "Who in your life would actually hold you accountable for [GOAL]?"
- **Circle Categories**: "GYM FRIENDS", "STUDY BUDDIES", "ROOMMATES/FAMILY"
- **Contact Descriptions**: "Already goes to gym", "Same schedule", "Competitive", "Same major", "Study partner", "Sees your routine", "Worried about you"
- **Progress**: "Selected: 0/5 minimum needed"
- **CTAs**: "CONTINUE", "ADD CUSTOM CONTACT"

**Interaction Details:**
- **Contact Selection**: Tap to add/remove from accountability circle
- **Contact Info**: Tap contact to see details and relationship
- **Custom Add**: Import contacts not in suggested lists
- **Progress Bar**: Visual feedback on selection requirements
- **Search**: Find contacts by name or relationship

**Psychology:**
- **Social Support**: Identifies real accountability partners
- **Relationship Mapping**: Shows different types of support available
- **Minimum Threshold**: Creates requirement for serious commitment

---

### Step 13: The Vulnerability Check

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      ❤️ HOW VULNERABLE ARE YOU?     │
│                                     │
│    How comfortable are you letting   │
│    friends see you fail at [GOAL]?   │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  ❤️‍🩹 VULNERABILITY METER     │  │
│    │                             │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ ░░░░░░░░░░░░░░░░░░ │   │  │
│    │  │ ●                  │   │  │
│    │  │ Hide my failures     │   │
│    │  │ "Nobody needs to know"│   │  │
    │  │ Level 1: Private       │   │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ ░░░░░░░░░░░░░░░░░░ │   │  │
│    │  │      ●               │   │  │
│    │  │ Share struggles       │   │
│    │  │ "My close friends only"│   │
│    │  Level 3: Selective      │   │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ ░░░░░░░░░░░░░░░░░░ │   │  │
│    │  │           ●           │   │  │
│    │  │ Public accountability   │   │
│    │  │ "Everyone can see"     │   │
│    │  Level 5: Transparent     │   │
│    │  └─────────────────────┘   │  │
│    └─────────────────────────────┘  │
│                                     │
│    Higher vulnerability =          │
│    Stronger pack accountability     │
│                                     │
│    Your heart rate: [BPM] ❤️       │
│                                     │
│            [CONTINUE]               │
│    [WHY THIS MATTERS →]            │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "HOW VULNERABLE ARE YOU?"
- **Question**: "How comfortable are you letting friends see you fail at [GOAL]?"
- **Level 1**: "Hide my failures", "Nobody needs to know", "Level 1: Private"
- **Level 3**: "Share struggles", "My close friends only", "Level 3: Selective"
- **Level 5**: "Public accountability", "Everyone can see", "Level 5: Transparent"
- **Benefit**: "Higher vulnerability = Stronger pack accountability"
- **Heart Rate**: "Your heart rate: [BPM] ❤️"
- **CTAs**: "CONTINUE", "WHY THIS MATTERS →"

**Interaction Details:**
- **Vulnerability Slider**: Drag to select comfort level (1-10)
- **Heart Rate Animation**: BPM increases with vulnerability level
- **Level Descriptions**: Dynamic text based on selection
- **Why Button**: Tap for explanation of vulnerability importance
- **Visual Feedback**: Progress bar fills with electric cyan

**Psychology:**
- **Vulnerability-Trust Connection**: Higher vulnerability builds stronger bonds
- **Comfort Assessment**: Helps user understand own boundaries
- **Accountability Link**: Shows relationship between openness and effectiveness

---

### Step 14: The Commitment Style

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      🎯 WHAT MOTIVATES YOU?         │
│                                     │
│    What type of accountability       │
│    actually works for you?           │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  💬 GENTLE REMINDERS         │  │
│    │                             │  │
│    │  "Hey, don't forget gym!"   │  │
│    │  "You got this!"            │  │
│    │  "Proud of you!"           │  │
│    │                             │  │
│    │  Best for: Self-motivated   │  │
│    │  Need: Encouragement        │  │
│    │  Success rate: 60%          │  │
│    │                             │  │
│    │  [SELECT THIS STYLE]        │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🔥 TOUGH LOVE              │  │
│    │                             │  │
│    │  "Where were you?!"         │  │
│    │  "Step it up!"              │  │
│    │  "Don't be that guy"        │  │
│    │                             │  │
│    │  Best for: Competitive      │  │
│    │  Need: Challenge            │  │
│    │  Success rate: 85%          │  │
│    │                             │  │
│    │  [SELECT THIS STYLE]        │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  💰 REAL CONSEQUENCES       │  │
│    │                             │  │
│    │  "Pay up or phone jail"     │  │
│    │  "Money talks"              │  │
│    │  "No excuses"               │  │
│    │                             │  │
│    │  Best for: Stubborn         │  │
│    │  Need: External pressure    │  │
│    │  Success rate: 95%          │  │
│    │                             │  │
│    │  [SELECT THIS STYLE]        │  │
│    └─────────────────────────────┘  │
│                                     │
│            [CONTINUE]               │
│    [SEE DETAILED COMPARISON]       │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "WHAT MOTIVATES YOU?"
- **Question**: "What type of accountability actually works for you?"
- **Gentle Reminders**: "Hey, don't forget gym!", "You got this!", "Proud of you!", "Best for: Self-motivated", "Need: Encouragement", "Success rate: 60%"
- **Tough Love**: "Where were you?!", "Step it up!", "Don't be that guy", "Best for: Competitive", "Need: Challenge", "Success rate: 85%"
- **Real Consequences**: "Pay up or phone jail", "Money talks", "No excuses", "Best for: Stubborn", "Need: External pressure", "Success rate: 95%"
- **CTAs**: "CONTINUE", "SEE DETAILED COMPARISON"

**Interaction Details:**
- **Style Cards**: Tap to select commitment style
- **Success Rates**: Visual emphasis on higher rates
- **Detailed View**: Tap for side-by-side comparison
- **Examples**: Real message previews for each style
- **Selection Feedback**: Electric cyan border on selected style

**Psychology:**
- **Self-Awareness**: Helps user understand own motivation
- **Effectiveness**: Shows success rates for different approaches
- **Personalization**: Tailors experience to user's needs

---

### Step 15: The Success Vision

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      🔮 IMAGINE YOUR SUCCESS        │
│                                     │
│    Picture yourself 30 days from    │
│    now. What does success look like? │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  [Vision Input Field]       │  │
│    │                             │  │
│    │  I wake up at 6:00 AM       │  │
│    │  feeling energized and      │  │
│    │  ready to crush gym.        │  │
│    │                             │  │
│    │  My pack is waiting for me  │  │
│    │  and we push each other to  │  │
│    │  be our best.              │  │
│    │                             │  │
│    │  By 7:30 AM, I've completed │  │
│    │  my workout and feel like    │  │
│    │  I can conquer anything.    │  │
│    └─────────────────────────────┘  │
│                                     │
│    Vision prompts:                 │
│    • "I wake up at [time] feeling [energy]" │
│    • "I [achieve goal] and feel [emotion]" │
│    • "My pack says [reaction]" │
│    • "By [result time], I've [accomplishment]" │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🎯 YOUR SUCCESS METRICS    │  │
│    │                             │  │
│    │  Energy: ⚡⚡⚡⚡⚡         │  │
│    │  Confidence: 💪💪💪💪💪      │  │
│    │  Consistency: 🔥🔥🔥🔥🔥      │  │
│    │  Pack Pride: 🤝🤝🤝🤝🤝      │  │
│    └─────────────────────────────┘  │
│                                     │
│            [CONTINUE]               │
│    [GET INSPIRED →]                │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "IMAGINE YOUR SUCCESS"
- **Instructions**: "Picture yourself 30 days from now. What does success look like?"
- **Vision Prompts**: 
  - "I wake up at [time] feeling [energy]"
  - "I [achieve goal] and feel [emotion]"
  - "My pack says [reaction]"
  - "By [result time], I've [accomplishment]"
- **Success Metrics**: "Energy: ⚡⚡⚡⚡⚡", "Confidence: 💪💪💪💪💪", "Consistency: 🔥🔥🔥🔥🔥", "Pack Pride: 🤝🤝🤝🤝🤝"
- **CTAs**: "CONTINUE", "GET INSPIRED →"

**Interaction Details:**
- **Vision Input**: Large text area with character limit (500 chars)
- **Prompt Helper**: Tap prompts to auto-complete vision template
- **Metrics Animation**: Success metrics animate as user types vision
- **Inspiration**: Tap to see example success visions
- **Word Count**: Real-time character and word count

**Psychology:**
- **Future Pacing**: Creates mental image of success
- **Visualization**: Helps user see and feel desired outcome
- **Motivation**: Success vision creates drive to achieve

---

### Step 16: The Personal Investment

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      💰 YOUR INVESTMENT SUMMARY     │
│                                     │
│    You've invested serious time     │
│    thinking about this. Ready to     │
│    make it real?                    │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  📊 INVESTMENT BREAKDOWN    │  │
│    │                             │  │
│    │  ⏱️ Time invested:         │  │
│    │     12 minutes              │  │
│    │                             │  │
│    │  🎯 Goal clarity:          │  │
│    │     100% defined           │  │
│    │                             │  │
│    │  💭 Emotional awareness:    │  │
│    │     High (gap: 7 points)   │  │
│    │                             │  │
│    │  💸 Cost understanding:     │  │
│    │     $550/month identified   │  │
│    │                             │  │
│    │  👥 Support system:         │  │
│    │     5 people selected      │  │
│    │                             │  │
│    │  ❤️ Vulnerability level:    │  │
│    │     7/10 (selective)        │  │
│    │                             │  │
│    │  🎯 Motivation style:       │  │
│    │     Tough love selected     │  │
│    │                             │  │
│    │  🔮 Success vision:         │  │
│    │     Complete (156 words)    │  │
│    └─────────────────────────────┘  │
│                                     │
│    Investment Score: 95/100 ✅     │
│    ████████████████████████████████ │
│                                     │
│    You're more ready than 90% of   │
│    people who start this journey.   │
│                                     │
│            [CREATE MY PACK]         │
│    [I NEED MORE TIME]              │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "YOUR INVESTMENT SUMMARY"
- **Instructions**: "You've invested serious time thinking about this. Ready to make it real?"
- **Investment Breakdown**: 
  - "Time invested: 12 minutes"
  - "Goal clarity: 100% defined"
  - "Emotional awareness: High (gap: 7 points)"
  - "Cost understanding: $550/month identified"
  - "Support system: 5 people selected"
  - "Vulnerability level: 7/10 (selective)"
  - "Motivation style: Tough love selected"
  - "Success vision: Complete (156 words)"
- **Score**: "Investment Score: 95/100 ✅"
- **Comparison**: "You're more ready than 90% of people who start this journey."
- **CTAs**: "CREATE MY PACK", "I NEED MORE TIME"

**Interaction Details:**
- **Score Animation**: Investment score builds with each element
- **Progress Bar**: Visual representation of completion
- **Comparison**: Dynamic comparison to other users
- **CTA Logic**: "CREATE MY PACK" only active when score > 80
- **Time Option**: "I NEED MORE TIME" allows saving progress

**Psychology:**
- **Investment Protection**: User doesn't want to waste invested time
- **Progress Validation**: High score confirms readiness
- **Social Comparison**: "More ready than 90%" creates confidence
- **Commitment**: Summary creates psychological sunk cost

---

## Phase 4: Pack Creation (Steps 17-24)

### Step 17: Pack Foundation

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│         🏗️ BUILD YOUR PACK          │
│                                     │
│    Now let's create your            │
│    accountability crew.              │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🐺 PACK NAME               │  │
│    │                             │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ Gym Wolves           │   │  │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  Character limit: 11/20     │  │
│    │  💡 Make it memorable!     │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  👥 PACK SIZE              │  │
│    │                             │  │
│    │  Ideal: 3-10 members        │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │  3  │ │  5  │ │  8  │   │  │
│    │  │ Core│ │ Squad│ │ Crew │   │  │
│    │  │ 👥  │ │ 👥  │ │ 👥  │   │  │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │                             │  │
│    │  Selected: 5 members        │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🎯 PACK FOCUS              │  │
│    │                             │  │
│    │  Primary goal:              │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │ Gym │ │Study│ │Wake │   │  │
│    │  │ 💪  │ │ 📚  │ │ ⏰  │   │  │
│    │  │[+]  │ │[+]  │ │[+]  │   │  │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐           │  │
│    │  │ No  │ │Read │           │  │
│    │  │Drink│ │ 📖  │           │  │
│    │  │ 🍺  │ │[+]  │           │  │
│    │  │[+]  │ │     │           │  │
│    │  └─────┘ └─────┘           │  │
│    └─────────────────────────────┘  │
│                                     │
│    Pack readiness: 60%             │
│    ████████████░░░░░░░░░░░░░░░░░░   │
│                                     │
│            [CONTINUE]               │
│    [GET PACK NAME IDEAS]           │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "BUILD YOUR PACK"
- **Instructions**: "Now let's create your accountability crew."
- **Pack Name**: "Character limit: 11/20", "💡 Make it memorable!"
- **Pack Size**: "Ideal: 3-10 members", "Selected: 5 members"
- **Size Options**: "Core", "Squad", "Crew"
- **Pack Focus**: "Primary goal:" with gym, study, wake up, no drink, read options
- **Progress**: "Pack readiness: 60%"
- **CTAs**: "CONTINUE", "GET PACK NAME IDEAS"

**Interaction Details:**
- **Name Input**: Real-time character count with validation
- **Size Selector**: Tap to change pack size with visual feedback
- **Focus Grid**: Multi-select for pack goals (max 3)
- **Readiness Bar**: Updates as user completes each section
- **Name Ideas**: Tap for pack name suggestions based on focus

**Psychology:**
- **Identity Formation**: Pack name creates group identity
- **Optimal Sizing**: Guidance on effective pack size
- **Goal Alignment**: Pack focus matches user's personal goals

---

### Step 18: Member Invitation

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      👥 ASSEMBLE YOUR WOLVES        │
│                                     │
│    Invite the people who will        │
│    actually hold you accountable.    │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  📱 SHARE INVITE LINK        │  │
│    │                             │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ pakkt.app/join/      │   │
│    │  │ gym-wolves-abc123    │   │
│    │  │                     │   │
│    │  │     [COPY LINK]      │   │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  Link expires in 24 hours   │  │
│    │  5/10 spots remaining      │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  📲 DIRECT INVITES          │  │
│    │                             │  │
│    │  Recently contacted:         │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │ Jake │ │ Sarah│ │ Mike │   │  │
│    │  │ 💪  │ │ 📚  │ │ ⏰  │   │  │
│    │  │[+]  │ │[+]  │ │[+]  │   │  │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐           │  │
│    │  │ Tom  │ │ Alex │           │  │
│    │  │ 🎯  │ │ 🏠  │           │  │
│    │  │[+]  │ │[+]  │           │  │
│    │  └─────┘ └─────┘           │  │
│    │                             │  │
│    │  [SEARCH CONTACTS]         │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  📝 INVITATION MESSAGE     │  │
│    │                             │  │
│    │  Hey! I'm creating a Pakkt   │  │
│    │  pack for [GOAL]. Need some  │  │
│    │  real accountability to      │  │
│    │  actually stick with it.     │  │
│    │                             │  │
│    │  We'd set real consequences  │  │
│    │  (fines/phone jail) and     │  │
│    │  hold each other to show up. │  │
│    │                             │  │
│    │  You in? Pack: [PACK NAME]  │  │
│    │                             │  │
│    │  [CUSTOMIZE MESSAGE]       │  │
│    └─────────────────────────────┘  │
│                                     │
│    Pack status: 1/5 members       │
│    ██████░░░░░░░░░░░░░░░░░░░░░░░░░   │
│                                     │
│            [SEND INVITES]           │
│    [SKIP FOR NOW]                  │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "ASSEMBLE YOUR WOLVES"
- **Instructions**: "Invite the people who will actually hold you accountable."
- **Link Sharing**: "Link expires in 24 hours", "5/10 spots remaining"
- **Direct Invites**: "Recently contacted:" with contact list
- **Invitation Message**: Pre-written message explaining Pakkt and pack concept
- **Status**: "Pack status: 1/5 members"
- **CTAs**: "SEND INVITES", "SKIP FOR NOW"

**Interaction Details:**
- **Link Copy**: One-tap copy with confirmation toast
- **Contact Search**: Real-time search through phone contacts
- **Message Customization**: Edit invitation message per contact
- **Batch Send**: Send to multiple contacts at once
- **Real-time Status**: Updates as members join via link

**Psychology:**
- **Social Commitment**: Public invitation creates obligation
- **Personalization**: Custom messages increase acceptance
- **Urgency**: Expiring link creates timely response
- **Ease**: Multiple invitation methods reduce friction

---

### Step 19: Consequence Setup

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      ⚖️ SET THE STAKES              │
│                                     │
│    Set the consequences that will    │
│    actually keep you showing up.     │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  💰 CASH FINES              │  │
│    │                             │  │
│    │  Fine amount per miss:      │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │ $1  │ │ $5  │ │ $10 │   │  │
│    │  │ 😅  │ │ 😬  │ │ 💀  │   │  │
│    │  │[+]  │ │[+]  │ │[+]  │   │  │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐           │  │
│    │  │ $15 │ │ $20 │           │  │
│    │  │ 😱  │ │ ☠️  │           │  │
│    │  │[+]  │ │[+]  │           │  │
│    │  └─────┘ └─────┘           │  │
│    │                             │  │
│    │  Selected: $5 per miss      │  │
│    │  💡 Enough to hurt, not to  │  │
│    │     break the bank          │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  📱 PHONE JAIL              │  │
│    │                             │  │
│    │  Jail time per miss:        │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │ 15  │ │ 30  │ │ 45  │   │  │
│    │  │ min │ │ min │ │ min │   │  │
│    │  │ 😐  │ │ 😬  │ │ 😱  │   │  │
│    │  │[+]  │ │[+]  │ │[+]  │   │  │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │                             │  │
│    │  ┌─────┐                   │  │
│    │  │ 60  │                   │  │
│    │  │ min │                   │  │
│    │  │ ☠️  │                   │  │
│    │  │[+]  │                   │  │
│    │  └─────┘                   │  │
│    │                             │  │
│    │  Selected: 30 minutes       │  │
│    │  💡 Enough to be annoying,  │  │
│    │     not to ruin your day    │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🔄 VOTING RULES            │  │
│    │                             │  │
│    │  Fine activation requires:   │  │
│    │                             │  │
│    │  ┌─────────┐ ┌─────────┐     │  │
│    │  │ Majority│ │ Unanimous│     │  │
│    │  │ (50%+1) │ │ (100%)   │     │  │
│    │  │[SELECTED]│ │         │     │  │
│    │  └─────────┘ └─────────┘     │  │
│    │                             │  │
│    │  ⚠️  Pack admin can veto    │  │
│    │     malicious fines         │  │
│    └─────────────────────────────┘  │
│                                     │
│    Consequence readiness: 100%     │
│    ████████████████████████████████ │
│                                     │
│            [CONTINUE]               │
│    [WHY THESE AMOUNTS?]            │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "SET THE STAKES"
- **Instructions**: "Set the consequences that will actually keep you showing up."
- **Cash Fines**: "Fine amount per miss:", "Selected: $5 per miss", "💡 Enough to hurt, not to break the bank"
- **Phone Jail**: "Jail time per miss:", "Selected: 30 minutes", "💡 Enough to be annoying, not to ruin your day"
- **Voting Rules**: "Fine activation requires:", "⚠️ Pack admin can veto malicious fines"
- **Progress**: "Consequence readiness: 100%"
- **CTAs**: "CONTINUE", "WHY THESE AMOUNTS?"

**Interaction Details:**
- **Fine Selector**: Horizontal scroll with snap-to-selection
- **Jail Time Selector**: Same interface for time selection
- **Voting Rules**: Toggle between majority and unanimous
- **Visual Feedback**: Selected options glow with electric cyan
- **Helper Tooltips**: Tap amounts for explanation and examples

**Psychology:**
- **User Control**: User sets their own consequences
- **Balance**: Guidance on effective but not excessive amounts
- **Fairness**: Voting rules prevent abuse
- **Investment**: Setting stakes increases commitment

---

### Step 20: Pack Rules

**Screen Layout:**
```
┌─────────────────────────────────────┐
│                                     │
│      📋 ESTABLISH PACK RULES        │
│                                     │
│    Every great pack has clear       │
│    rules. What are yours?           │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  📸 PHOTO PROOF             │  │
│    │                             │  │
│    │  Require photo evidence     │  │
│    │  for check-ins?             │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐           │  │
│    │  │ YES │ │ NO  │           │  │
│    │  │[+]  │ │[+]  │           │  │
│    │  └─────┘ └─────┘           │  │
│    │                             │  │
│    │  💡 Photos prevent cheating  │  │
│    │     but add friction        │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🕐 CHECK-IN WINDOW         │  │
│    │                             │  │
│    │  How flexible is timing?     │  │
│    │                             │  │
│    │  Before goal:               │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ 0 min  15 min  30 min│   │  │
│    │  │[SELECTED]     [+]  │   │  │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  After goal:                │  │
│    │  ┌─────────────────────┐   │  │
│    │  │ 0 min  15 min  30 min│   │
│    │  │[SELECTED]     [+]  │   │  │
│    │  └─────────────────────┘   │  │
│    │                             │  │
│    │  Total window: 30 minutes   │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  🎯 WEEKEND PASSES           │  │
│    │                             │  │
│    │  Allow skipping on weekends? │  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐           │  │
│    │  │ALLOW│ │DENY │           │  │
│    │  │[+]  │ │[+]  │           │  │
│    │  └─────┘ └─────┘           │  │
│    │                             │  │
│    │  💡 Prevents burnout, but   │  │
│    │     reduces consistency      │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │  ⚠️ GRACE PERIOD            │  │
│    │                             │  │
│    │  How late is still "on time"?│  │
│    │                             │  │
│    │  ┌─────┐ ┌─────┐ ┌─────┐   │  │
│    │  │ 0min│ │ 5min│ │10min│   │  │
│    │  │[+]  │ │[+]  │ │[+]  │   │  │
│    │  └─────┘ └─────┘ └─────┘   │  │
│    │                             │  │
│    │  ┌─────┐                   │  │
│    │  │15min│                   │  │
│    │  │[+]  │                   │  │
│    │  └─────┘                   │  │
│    │                             │  │
│    │  Selected: 5 minutes grace   │  │
│    │  💡 Life happens, but be    │  │
│    │     reasonable              │  │
│    └─────────────────────────────┘  │
│                                     │
│    Rules readiness: 100%           │
│    ████████████████████████████████ │
│                                     │
│            [CONTINUE]               │
│    [USE DEFAULT RULES]             │
└─────────────────────────────────────┘
```

**Microcopy:**
- **Header**: "ESTABLISH PACK RULES"
- **Instructions**: "Every great pack has clear rules. What are yours?"
- **Photo Proof**: "Require photo evidence for check-ins?", "💡 Photos prevent cheating but add friction"
- **Check-in Window**: "How flexible is timing?", "Total window: 30 minutes"
- **Weekend Passes**: "Allow skipping on weekends?", "💡 Prevents burnout, but reduces consistency"
- **Grace Period**: "How late is still 'on time'?", "Selected: 5 minutes grace", "💡 Life happens, but be reasonable"
- **Progress**: "Rules readiness: 100%"
- **CTAs**: "CONTINUE", "USE DEFAULT RULES"

**Interaction Details:**
- **Toggle Switches**: Smooth on/off animations with haptic feedback
- **Window Sliders**: Dual sliders for before/after flexibility
- **Rule Explanations**: Tap info icons for detailed explanations
- **Default Rules**: Pre-configured rule sets for different pack types
- **Visual Feedback**: Selected rules highlight with electric cyan

**Psychology:**
- **Clarity**: Clear rules prevent future disputes
- **Flexibility**: Options accommodate different lifestyles
- **Fairness**: Grace periods account for real life
- **Ownership**: User control increases rule acceptance

---

[Continue with remaining 13 steps...]
