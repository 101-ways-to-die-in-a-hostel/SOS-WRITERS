# Production Pipeline Specification

## Overview

This document defines the complete production pipeline for each book in the "101 Ways to Die in a Hostel" series. Each book requires the following deliverables before publication.

---

## Phase 1: Canon Writing (REQUIRED FIRST)

All canon documents must be complete before any production work begins.

### Required Canon Documents

| Document | Template | Status Check |
|----------|----------|--------------|
| BOOK_IDENTITY.md | `templates/CANON/BOOK_IDENTITY.md` | Core identity, themes, tone |
| DEATH_SCENARIO.md | `templates/CANON/DEATH_SCENARIO.md` | Complete death mechanics |
| VICTIM_PROFILE.md | `templates/CANON/VICTIM_PROFILE.md` | Victim details, fatal flaw |
| LOCATION.md | `templates/CANON/LOCATION.md` | Hostel and city details |
| CHARACTERS.md | `templates/CANON/CHARACTERS.md` | Supporting cast |

### Canon Completion Criteria
- [ ] All 5 canon documents created
- [ ] Documents follow templates exactly
- [ ] Internal consistency verified
- [ ] Cross-references checked
- [ ] Ready for production phase

---

## Phase 2: Visual Production

Once canon is complete, visual assets can be produced in parallel.

### 2A. Mood Board (FIRST)

**Template:** `templates/PRODUCTION/MOOD_BOARD_BRIEF.md`

**Purpose:** Establishes visual language for all other production.

**Inputs:**
- BOOK_IDENTITY.md (tone, themes)
- LOCATION.md (atmosphere)
- DEATH_SCENARIO.md (horror elements)

**Outputs:**
- `assets/mood-board/moodboard.png`
- `assets/mood-board/color-palette.png`

**Must Complete Before:** Book cover, character sketches, location photos

---

### 2B. Book Cover

**Template:** `templates/PRODUCTION/BOOK_COVER_BRIEF.md`

**Purpose:** Primary marketing asset, first impression.

**Inputs:**
- Mood board (colors, style)
- BOOK_IDENTITY.md (subtitle, themes)
- DEATH_SCENARIO.md (visual hint of death)

**Outputs:**
- `assets/covers/cover-print.png` (300 DPI, CMYK)
- `website/assets/images/cover.png` (web optimized)
- `assets/covers/cover-social-square.png`
- `assets/covers/cover-social-story.png`

---

### 2C. Character Sketches

**Template:** `templates/PRODUCTION/CHARACTER_SKETCHES_BRIEF.md`

**Purpose:** Visualization for writing, marketing, trailers.

**Inputs:**
- VICTIM_PROFILE.md
- CHARACTERS.md
- Mood board (style guide)

**Outputs:**
- `assets/character-sketches/victim-portrait.png`
- `assets/character-sketches/victim-fullbody.png`
- `assets/character-sketches/[character]-portrait.png` (for each major character)

---

### 2D. Location Photos

**Template:** `templates/PRODUCTION/LOCATION_PHOTOS_BRIEF.md`

**Purpose:** Setting visualization, trailer backgrounds, marketing.

**Inputs:**
- LOCATION.md
- DEATH_SCENARIO.md (death location)
- Mood board (atmosphere guide)

**Outputs:**
- `assets/location-photos/hostel-exterior.png`
- `assets/location-photos/hostel-interior.png`
- `assets/location-photos/death-location.png`
- `assets/location-photos/city-[landmark].png`

---

## Phase 3: Video Production

### 3A. Trailer

**Existing Template:** `FILM/trailers/scripts/` (already populated)

**Inputs:**
- Trailer script
- Character sketches
- Location photos
- Mood board

**Outputs:**
- `FILM/trailers/output/trailer-youtube.mp4` (16:9)
- `FILM/trailers/output/trailer-tiktok.mp4` (9:16)
- `FILM/trailers/output/trailer-instagram.mp4` (1:1)
- `website/assets/video/trailer.mp4` (web version)

---

## Phase 4: Website Updates

### 4A. Landing Page Content

**Location:** `website/data/book.json`

**Required Fields:**
```json
{
  "synopsis": {
    "short": "[From BOOK_IDENTITY - one sentence]",
    "long": "[2-3 paragraph synopsis]"
  },
  "death_teaser": "[Tagline from BOOK_IDENTITY]",
  "tagline": "[Series tagline]"
}
```

### 4B. Asset Integration

**Update these references in `website/index.html`:**
- Book cover image path
- Trailer video embed
- Character gallery (optional)
- Location gallery (optional)

---

## Production Order

```
1. Canon Documents (all 5)
        ↓
2. Mood Board
        ↓
   ┌────┴────┬────────┐
   ↓         ↓        ↓
3. Cover  Sketches  Photos
   │         │        │
   └────┬────┴────────┘
        ↓
4. Video Trailer
        ↓
5. Website Integration
        ↓
6. Publication Ready
```

---

## Quality Gates

### Gate 1: Canon Complete
- [ ] All 5 canon documents exist and are complete
- [ ] Internal consistency check passed
- [ ] Ready for production sign-off

### Gate 2: Visual Production Complete
- [ ] Mood board approved
- [ ] Book cover approved (all variants)
- [ ] Character sketches approved
- [ ] Location photos approved

### Gate 3: Video Complete
- [ ] Trailer rendered for all platforms
- [ ] Audio/music properly licensed
- [ ] Website video uploaded

### Gate 4: Publication Ready
- [ ] Website updated with all assets
- [ ] JSON data complete
- [ ] All deliverables in correct locations
- [ ] Final review passed

---

## File Organization

```
book-XXX-[slug]/
├── CANON/
│   ├── BOOK_IDENTITY.md      ✓ Written
│   ├── DEATH_SCENARIO.md     ✓ Written
│   ├── VICTIM_PROFILE.md     ✓ Written
│   ├── LOCATION.md           ✓ Written
│   └── CHARACTERS.md         ○ To Write
├── assets/
│   ├── covers/               ○ To Generate
│   ├── character-sketches/   ○ To Generate
│   ├── location-photos/      ○ To Generate
│   └── mood-board/           ○ To Generate
├── FILM/
│   └── trailers/
│       ├── scripts/          ✓ Written
│       └── output/           ○ To Render
└── website/
    ├── assets/
    │   ├── images/
    │   │   └── cover.png     ○ To Add
    │   └── video/
    │       └── trailer.mp4   ○ To Add
    └── data/
        └── book.json         ✓ Populated
```

✓ = Complete in all 103 repos
○ = Missing in all 103 repos

---

## Automation Scripts

### Audit Script
```bash
./audit-repos.sh
```
Generates report of missing items across all repos.

### Issue Creation
```bash
./create-issues.sh
```
Creates GitHub issues for missing production items.

### Deployment
```bash
./deploy-all-landing-pages.sh
./push-all-changes.sh
```
Deploys website updates to Vercel.

---

*Pipeline specification created: 2026-01-06*
