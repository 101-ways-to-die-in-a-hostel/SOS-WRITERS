# SOS for Writers
## Sovereign Operating System for Autonomous Book Creation

**Version:** 1.0
**Author:** Jonathan ANDERSON
**Created:** 2026-01-06

---

## Executive Summary

SOS for Writers is an autonomous book production system designed to generate a complete 103-book series ("101 Ways to Die in a Hostel") totaling approximately **25.75 million words**. The system uses AI writing agents operating within structured repositories, following predefined outlines, character bibles, and style guides to produce consistent, high-quality horror-comedy novels.

### Key Metrics

| Metric | Value |
|--------|-------|
| Total Books | 103 |
| Words per Book | ~250,000 |
| Pages per Book | ~220 |
| Chapters per Book | 40-50 |
| Total Words | ~25,750,000 |
| Total Pages | ~22,660 |

---

## System Architecture

### Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    SOS FOR WRITERS                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │ SHARED      │    │ BOOK        │    │ OUTPUT      │         │
│  │ CANON       │───▶│ REPOSITORIES│───▶│ PIPELINE    │         │
│  │             │    │ (103)       │    │             │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│        │                  │                  │                  │
│        ▼                  ▼                  ▼                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │ Series      │    │ Autonomous  │    │ Compiled    │         │
│  │ Bible       │    │ AI Agents   │    │ Manuscripts │         │
│  │ Characters  │    │ (Claude)    │    │ EPUB/PDF    │         │
│  │ Locations   │    │             │    │             │         │
│  │ Timeline    │    │             │    │             │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Components

#### 1. Shared Canon Repository
Central source of truth for series-wide elements:
- Series bible (tone, rules, world)
- @HostelReaper lore
- Recurring characters
- Recurring locations
- Master timeline
- Cross-reference index

#### 2. Book Repositories (×103)
Individual repositories for each book containing:
- Agent instructions (CLAUDE.md)
- Canon files (characters, locations, death scenario)
- Outlines (synopsis, beat sheet, chapter plan)
- Chapters (organized by story part)
- Drafts (work in progress)
- Output (compiled manuscript)

#### 3. Output Pipeline
Compilation and export system:
- Markdown → unified manuscript
- Manuscript → EPUB
- Manuscript → PDF
- Manuscript → HTML (for website)

---

## Workflow

### Phase 1: Initialization (Human)

For each book, the human author completes:

1. **CANON/BOOK_IDENTITY.md**
   - Book number and title
   - Death category
   - Thematic focus

2. **CANON/VICTIM_PROFILE.md**
   - Full character study of the victim
   - Backstory, personality, fatal flaw
   - Speech patterns, mannerisms

3. **CANON/DEATH_SCENARIO.md**
   - Exact mechanism of death
   - Required setup elements
   - Foreshadowing checklist
   - The death sequence (detailed)

4. **CANON/LOCATION.md**
   - Hostel name and description
   - City and country
   - Cultural context
   - Sensory environment

5. **CANON/CHARACTERS.md**
   - Supporting cast profiles
   - Staff members
   - Secondary victims (if any)

6. **OUTLINE/SYNOPSIS.md**
   - One-page story summary

7. **OUTLINE/CHAPTER_PLAN.md**
   - All 50 chapters outlined
   - Scene-by-scene breakdown

**Estimated human time per book:** 4-8 hours

### Phase 2: Autonomous Writing (AI)

Once initialization is complete, the AI agent:

1. Reads all canon and outline files
2. Writes chapters sequentially (5,000-6,000 words each)
3. Maintains consistency via canon reference
4. Logs progress after each session
5. Flags issues in HANDOFF.md
6. Completes all 50 chapters

**Estimated AI time per book:** 40-60 sessions

### Phase 3: Revision (AI + Human)

After draft completion:

1. **AI Revision Pass 1:** Continuity check
2. **AI Revision Pass 2:** Pacing adjustment
3. **AI Revision Pass 3:** Voice consistency
4. **Human Review:** Spot-check, approve or request changes
5. **AI Revision Pass 4:** Final polish

### Phase 4: Compilation (Automated)

Final steps:
1. Compile all chapters to `/output/manuscript.md`
2. Generate EPUB via pandoc or similar
3. Generate PDF for print
4. Generate HTML for website integration
5. Update master progress tracking

---

## Agent Instructions Framework

### CLAUDE.md Structure

Each book's CLAUDE.md contains:

```
┌────────────────────────────────────────┐
│ MISSION                                │
│ - Book identity                        │
│ - Target word count                    │
│ - Core directive                       │
├────────────────────────────────────────┤
│ VOICE & TONE                           │
│ - Genre definition                     │
│ - Perspective and POV                  │
│ - Style guidelines                     │
├────────────────────────────────────────┤
│ STRUCTURE                              │
│ - 5-part story framework               │
│ - Chapter specifications               │
│ - Pacing requirements                  │
├────────────────────────────────────────┤
│ WRITING PROTOCOL                       │
│ - Before/during/after each session     │
│ - File management                      │
│ - Progress logging                     │
├────────────────────────────────────────┤
│ CONSISTENCY RULES                      │
│ - Character maintenance                │
│ - Location authenticity                │
│ - Death foreshadowing                  │
├────────────────────────────────────────┤
│ QUALITY STANDARDS                      │
│ - Chapter requirements                 │
│ - Things to avoid                      │
│ - Revision protocol                    │
└────────────────────────────────────────┘
```

### Agent Autonomy Levels

| Level | Description | Human Involvement |
|-------|-------------|-------------------|
| **Full Auto** | Agent writes entire book from outline | Review at completion |
| **Supervised** | Agent writes, human approves each chapter | After each chapter |
| **Collaborative** | Human provides beats, agent expands | Per scene |
| **Assisted** | Human writes, agent suggests/edits | On request |

**Default for SOS:** Full Auto with completion review.

---

## File Specifications

### Chapter Files

```markdown
# Chapter [XX]: [Title]

**Part:** [1-5]
**Word Count:** [Target: 5,000-6,000]
**POV:** [Character name]
**Location:** [Specific location within hostel/city]
**Timeline:** [Day X, Time]

---

[Chapter content here]

---

**Chapter Notes:**
- Foreshadowing planted: [Yes/No - what]
- Death references: [Subtle/Obvious/None]
- @HostelReaper mention: [Yes/No]
- Dark humor beat: [Description]
- Hook ending: [Description]
```

### Session Log Format

```markdown
## Session [Date] [Time]

**Agent:** [Claude/GPT/Other]
**Duration:** [Estimated]
**Chapters Completed:** [List]
**Words Written:** [Count]

### Accomplishments
- [What was written]

### Issues
- [Any problems encountered]

### Notes for Next Session
- [Context for continuation]
```

### Progress Dashboard

```markdown
# Book #XXX Progress

## Status: [PHASE]

## Completion
| Component | Status |
|-----------|--------|
| Canon Files | ██████████ 100% |
| Outline | ██████████ 100% |
| Part 1 | ████░░░░░░ 40% |
| Part 2 | ░░░░░░░░░░ 0% |
| Part 3 | ░░░░░░░░░░ 0% |
| Part 4 | ░░░░░░░░░░ 0% |
| Part 5 | ░░░░░░░░░░ 0% |
| Revision | ░░░░░░░░░░ 0% |

## Word Count
**Current:** 23,456
**Target:** 250,000
**Progress:** 9.4%

## Last Session
[Date] - Completed Chapter 4
```

---

## Series Consistency System

### Shared Elements

#### @HostelReaper
- Mysterious figure/entity appearing throughout series
- Appears as: graffiti, social media account, whispered legend
- Rules:
  - Never fully explained
  - 2-3 references per book minimum
  - Acknowledgment of each death in final chapter
  - Consistent across all 103 books

#### Recurring Locations
Some hostels appear in multiple books:
- Wanderlust Hostel, Marrakech (Books 6, 47, 89)
- The Flying Dutchman, Amsterdam (Books 1, 23, 78)
- Das Bunker, Berlin (Books 3, 15, 62)

#### Recurring Characters
Some characters survive one book to appear in another:
- Track in SHARED_CANON/RECURRING_CHARACTERS.md
- Note book appearances and roles
- Maintain character consistency

#### Timeline
All 103 deaths occur within a single calendar year:
- Track in SHARED_CANON/TIMELINE.md
- Some deaths happen simultaneously
- News of previous deaths may be referenced

### Cross-Reference Protocol

When writing a book that references another:
1. Check the referenced book's canon files
2. Use exact names, dates, details
3. Note the reference in CANON/CONNECTIONS.md
4. Update SHARED_CANON/EASTER_EGGS.md

---

## Quality Assurance

### Chapter-Level QA

Every chapter automatically checked for:
- [ ] Word count (5,000-6,000)
- [ ] POV consistency
- [ ] Location accuracy (matches LOCATION.md)
- [ ] Character accuracy (matches CHARACTERS.md)
- [ ] Timeline accuracy (matches TIMELINE.md)
- [ ] Foreshadowing presence
- [ ] Dark humor beat
- [ ] Hook ending

### Book-Level QA

After all chapters complete:
- [ ] Total word count (≥250,000)
- [ ] All 50 chapters present
- [ ] Continuity across chapters
- [ ] Death occurs in correct chapter range (35-40)
- [ ] @HostelReaper appears correctly
- [ ] Cross-references accurate
- [ ] Revision passes complete

### Series-Level QA

Periodic checks across all books:
- [ ] @HostelReaper consistency
- [ ] Recurring character consistency
- [ ] Timeline coherence
- [ ] No duplicate death scenarios
- [ ] Geographic variety maintained
- [ ] Victim archetype variety maintained

---

## Scaling Strategy

### Parallel Writing

Multiple books can be written simultaneously:
- Each book is an isolated repository
- No dependencies between books during drafting
- Cross-references added in revision phase
- Recommended: 5-10 books in parallel

### Agent Assignment

```
Option A: Single Agent, Sequential
- One agent writes all 103 books
- Maximum consistency
- Longest timeline

Option B: Multiple Agents, Parallel
- Different agents write different books
- Style guide ensures consistency
- Faster completion
- Requires consistency review

Option C: Specialized Agents
- Outlining agent creates all outlines
- Writing agents draft chapters
- Editing agent revises all books
- Quality agent checks consistency
```

### Timeline Estimates

| Approach | Books/Month | Total Duration |
|----------|-------------|----------------|
| Sequential (1 agent) | 2-3 | 3-4 years |
| Parallel (5 agents) | 10-15 | 8-12 months |
| Parallel (10 agents) | 20-30 | 4-6 months |

---

## Implementation Checklist

### Phase 1: System Setup
- [ ] Create organization structure
- [ ] Create shared canon repository
- [ ] Create template repository
- [ ] Create first 10 book repositories
- [ ] Initialize with canon files
- [ ] Complete outlines for first 10 books

### Phase 2: Pilot (Books 1-10)
- [ ] Launch autonomous writing for Book 1
- [ ] Monitor and adjust agent instructions
- [ ] Complete Books 2-10 in parallel
- [ ] Full QA review
- [ ] Refine process based on learnings

### Phase 3: Scale (Books 11-50)
- [ ] Initialize remaining repositories
- [ ] Complete outlines in batches
- [ ] Launch parallel writing
- [ ] Maintain quality standards
- [ ] Weekly progress reviews

### Phase 4: Complete (Books 51-103)
- [ ] Continue parallel writing
- [ ] Begin compilation of early books
- [ ] Cross-reference review
- [ ] Final series consistency check
- [ ] Publication preparation

---

## Appendices

### A: Death Category Reference

| Category | Books | Theme |
|----------|-------|-------|
| Environmental Hazards | 1-20 | Physical dangers in hostel |
| Fellow Travelers | 21-40 | Murder by other guests |
| Self-Inflicted | 41-60 | Victim's own actions |
| Supernatural/Bizarre | 61-80 | Paranormal deaths |
| Circumstantial/Random | 81-102 | Wrong place, wrong time |
| Finale | 103 | Series conclusion |

### B: Character Archetype Library

| Archetype | Description | Fatal Flaw |
|-----------|-------------|------------|
| Tech Bro | Startup founder, always hustling | Overconfidence in technology |
| Influencer | Content creator, needs validation | Prioritizes content over safety |
| Gap Year Kid | First solo trip, naive | Ignores warnings, overestimates abilities |
| Spiritual Tourist | Seeking meaning, appropriates cultures | Dismisses "negative energy" warnings |
| Party Animal | Here for the nightlife | Impaired judgment |
| Budget Traveler | Extreme penny-pinching | Chooses unsafe options to save money |
| Veteran Backpacker | Hostel snob, knows everything | Arrogance blinds them to danger |
| Digital Nomad | Working remotely, dependent on tech | Can't disconnect even when necessary |
| Solo Traveler | Seeking solitude | No one notices they're missing |
| Couple | Traveling together | Relationship drama distracts from danger |

### C: Location Library

| Region | Cities | Books Using |
|--------|--------|-------------|
| Europe | Amsterdam, Berlin, Barcelona, Prague, Budapest, Lisbon, Dublin | 25+ |
| Southeast Asia | Bangkok, Bali, Ho Chi Minh, Siem Reap, Chiang Mai | 20+ |
| Australia/NZ | Sydney, Melbourne, Auckland, Queenstown | 10+ |
| South America | Medellin, Lima, Buenos Aires, Rio, Cusco | 15+ |
| Central America | Mexico City, Tulum, Antigua, San Jose | 10+ |
| North America | LA, Miami, New York, Montreal, Austin | 10+ |
| Africa | Marrakech, Cape Town, Nairobi, Zanzibar | 8+ |
| Middle East | Tel Aviv, Amman, Dubai | 5+ |

### D: Sample Chapter Outline

```markdown
## Chapter 15: The Warning Sign

**Part:** 2 (Escalation)
**POV:** Sarah (victim)
**Location:** Hostel rooftop bar
**Timeline:** Day 3, 9:00 PM

### Scene 1: The Party
- Sarah joins rooftop gathering
- Meets fellow travelers
- Notices something odd about the railing
- Dismisses concern, joins fun

### Scene 2: The Local's Warning
- Elderly local staff member approaches
- Cryptic warning about "those who fall"
- Sarah interprets as superstition
- Other guests mock the warning

### Scene 3: The Drunk Photo Op
- Group decides to take photos on ledge
- Sarah almost slips
- Laughs it off, has another drink
- Ends chapter looking at the view

### Notes:
- Foreshadowing: Railing wobble, local warning, near-slip
- Dark humor: Guests mocking local superstition
- Death reference: "Those who fall"
- Hook: Beautiful view, unaware of danger
```

---

## Contact & Support

**System Creator:** Jonathan ANDERSON
**Repository:** 101-ways-to-die-in-a-hostel
**Support:** [Contact information]

---

*SOS for Writers - Because every story deserves to be told, even the deadly ones.*
