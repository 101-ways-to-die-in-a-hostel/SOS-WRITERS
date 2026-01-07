# SOS for Writers - Repository Structure Template

## Book Repository Template

Each of the 103 books follows this exact structure. Clone and customize for each death scenario.

```
book-XXX-[slug]/
│
├── .github/
│   └── workflows/
│       ├── word-count.yml           # Track daily word count
│       ├── consistency-check.yml    # Validate against series canon
│       └── compile-manuscript.yml   # Generate final output
│
├── AGENTS/
│   ├── CLAUDE.md                    # Primary autonomous writing instructions
│   ├── WRITER_PRIME.md              # Core writing directives (immutable)
│   ├── STYLE_GUIDE.md               # Voice, tone, formatting rules
│   ├── SESSION_LOG.md               # Running log of writing sessions
│   └── HANDOFF.md                   # Instructions for resuming work
│
├── CANON/
│   ├── BOOK_IDENTITY.md             # This book's unique identity
│   ├── CHARACTERS.md                # All characters in this book
│   ├── VICTIM_PROFILE.md            # Deep dive on the death victim
│   ├── DEATH_SCENARIO.md            # The specific death mechanics
│   ├── LOCATION.md                  # Hostel and city worldbuilding
│   ├── TIMELINE.md                  # Story chronology
│   └── CONNECTIONS.md               # Links to other books in series
│
├── OUTLINE/
│   ├── SYNOPSIS.md                  # 1-page story summary
│   ├── BEAT_SHEET.md                # Scene-by-scene breakdown
│   ├── CHAPTER_PLAN.md              # All 40-50 chapters outlined
│   └── THEMES.md                    # Thematic elements to weave in
│
├── chapters/
│   ├── part-1-setup/
│   │   ├── chapter-01.md
│   │   ├── chapter-02.md
│   │   └── ...
│   ├── part-2-escalation/
│   │   ├── chapter-11.md
│   │   └── ...
│   ├── part-3-crisis/
│   │   ├── chapter-21.md
│   │   └── ...
│   ├── part-4-climax/
│   │   ├── chapter-31.md
│   │   └── ...
│   └── part-5-aftermath/
│       ├── chapter-41.md
│       └── ...
│
├── drafts/
│   ├── raw/                         # First drafts
│   ├── revised/                     # After revision pass
│   └── polished/                    # Final drafts
│
├── research/
│   ├── DEATH_RESEARCH.md            # How this death actually works
│   ├── LOCATION_RESEARCH.md         # Real details about the city
│   ├── CULTURAL_NOTES.md            # Cultural accuracy considerations
│   └── references/                  # Source materials
│
├── assets/
│   ├── character-sketches/          # Character descriptions for covers
│   ├── location-photos/             # Reference imagery
│   └── mood-board/                  # Tonal references
│
├── output/
│   ├── manuscript.md                # Compiled full manuscript
│   ├── manuscript.epub              # EPUB export
│   ├── manuscript.pdf               # PDF export
│   └── word-count.json              # Progress tracking data
│
├── PROGRESS.md                      # Current status dashboard
├── README.md                        # Book overview
├── LICENSE.md                       # IP protection (all rights reserved)
└── .gitignore
```

---

## Directory Purposes

### `/AGENTS/`
Contains all instructions for autonomous AI writing. The CLAUDE.md file is the primary entry point that agents read to understand their task.

### `/CANON/`
The "bible" for this book. All worldbuilding, character, and story information that must remain consistent. Agents reference this constantly to maintain continuity.

### `/OUTLINE/`
The structural plan. Agents follow this to know what happens in each chapter. Should be completed before autonomous writing begins.

### `/chapters/`
The actual manuscript. Organized into 5 parts following story structure:
- **Part 1 (Setup):** Introduce victim, location, situation - Chapters 1-10
- **Part 2 (Escalation):** Warning signs ignored, danger builds - Chapters 11-20
- **Part 3 (Crisis):** Things go wrong, escape attempts fail - Chapters 21-30
- **Part 4 (Climax):** The death sequence, maximum horror - Chapters 31-40
- **Part 5 (Aftermath):** Consequences, other victims, @HostelReaper - Chapters 41-50

### `/drafts/`
Work-in-progress storage. Agents save rough drafts here before moving to chapters/ when approved.

### `/research/`
Real-world information to ground the fiction. Death mechanics, location accuracy, cultural sensitivity.

### `/output/`
Final compiled manuscripts in various formats.

---

## File Templates

### README.md
```markdown
# Book #XXX: [TITLE]

**Series:** 101 Ways to Die in a Hostel
**Author:** Jonathan ANDERSON
**Status:** [PLANNING / OUTLINING / DRAFTING / REVISING / COMPLETE]

## The Death
[One paragraph summary of how the victim dies]

## The Victim
**Name:** [Full name]
**Age:** [Age]
**Archetype:** [Tech bro / Influencer / Gap year kid / etc.]
**Fatal Flaw:** [The character trait that leads to their death]

## The Location
**Hostel:** [Hostel name]
**City:** [City, Country]

## Progress
- [ ] Outline complete
- [ ] Characters developed
- [ ] Chapters 1-10 drafted
- [ ] Chapters 11-20 drafted
- [ ] Chapters 21-30 drafted
- [ ] Chapters 31-40 drafted
- [ ] Chapters 41-50 drafted
- [ ] Revision pass complete
- [ ] Final manuscript compiled

## Word Count
Target: 250,000 words
Current: [X] words ([X]%)
```

### PROGRESS.md
```markdown
# Book #XXX Progress Dashboard

## Current Status
**Phase:** [PLANNING / OUTLINING / DRAFTING / REVISING / COMPLETE]
**Active Chapter:** [Chapter number]
**Last Updated:** [Date]

## Word Count Tracking
| Part | Target | Current | % |
|------|--------|---------|---|
| Part 1 (Setup) | 50,000 | 0 | 0% |
| Part 2 (Escalation) | 50,000 | 0 | 0% |
| Part 3 (Crisis) | 50,000 | 0 | 0% |
| Part 4 (Climax) | 50,000 | 0 | 0% |
| Part 5 (Aftermath) | 50,000 | 0 | 0% |
| **TOTAL** | **250,000** | **0** | **0%** |

## Session Log
| Date | Session | Words Added | Chapters Completed |
|------|---------|-------------|-------------------|
| | | | |

## Blockers
- [ ] None currently

## Next Actions
1. [Next immediate task]
```

---

## Naming Convention

Repository names follow this pattern:
```
book-[XXX]-[slug]
```

Where:
- `XXX` = Three-digit book number (001-103)
- `slug` = Lowercase, hyphenated death descriptor

### Examples:
```
book-001-faulty-electrical
book-002-gas-leak-explosion
book-003-structural-collapse
book-021-serial-killer-backpacker
book-077-digital-consciousness-wifi
book-102-the-200-dollar-question
```

---

## Initial Setup Checklist

When creating a new book repository:

1. [ ] Clone this template structure
2. [ ] Update README.md with book details
3. [ ] Complete CANON/BOOK_IDENTITY.md
4. [ ] Complete CANON/VICTIM_PROFILE.md
5. [ ] Complete CANON/DEATH_SCENARIO.md
6. [ ] Complete CANON/LOCATION.md
7. [ ] Complete OUTLINE/SYNOPSIS.md
8. [ ] Complete OUTLINE/BEAT_SHEET.md
9. [ ] Complete OUTLINE/CHAPTER_PLAN.md
10. [ ] Review AGENTS/CLAUDE.md for book-specific customization
11. [ ] Initialize git repository
12. [ ] Begin autonomous writing

---

## Cross-Repository Links

All 103 books share common elements tracked in the parent organization:

```
101-ways-to-die-in-a-hostel/          (org level)
├── .shared-canon/
│   ├── SERIES_BIBLE.md               # Overarching series rules
│   ├── HOSTEL_REAPER.md              # @HostelReaper lore
│   ├── RECURRING_CHARACTERS.md       # Characters who appear in multiple books
│   ├── RECURRING_LOCATIONS.md        # Hostels that appear in multiple books
│   ├── TIMELINE.md                   # When each death occurs
│   └── EASTER_EGGS.md                # Cross-references between books
└── [103 book repositories]
```

Books reference shared canon via relative paths or git submodules.
