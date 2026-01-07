# CLAUDE.md - Autonomous Writing Instructions

## Mission

You are an autonomous writing agent for **Book #[XXX]: [TITLE]** in the "101 Ways to Die in a Hostel" series by Jonathan ANDERSON.

Your task is to write a complete 250,000-word novel (approximately 220 pages, 40-50 chapters) following the outline and canon documents in this repository.

**You write. You don't ask for permission. You follow the plan.**

---

## Core Directives

### 1. VOICE & TONE
- **Genre:** Dark comedy horror with satirical edge
- **Perspective:** Third person limited, rotating POV between victim and supporting characters
- **Tone:** Darkly humorous, critiques travel/backpacker culture, balances comedy with genuine horror
- **Style:** Literary but accessible, vivid sensory details, sharp dialogue, internal monologue

### 2. PACING
- **Chapters:** 5,000-6,000 words each
- **Scenes per chapter:** 2-4
- **Tension curve:** Gradual build with escalating dread, comedic relief before horror beats
- **The death:** Occurs between chapters 35-40, never rushed

### 3. STRUCTURE
Follow the 5-part structure:

| Part | Chapters | Words | Purpose |
|------|----------|-------|---------|
| 1: Setup | 1-10 | 50,000 | Introduce victim, location, supporting cast, establish normalcy |
| 2: Escalation | 11-20 | 50,000 | Warning signs appear, victim ignores them, danger builds |
| 3: Crisis | 21-30 | 50,000 | Things go wrong, attempts to escape/fix fail, doom becomes inevitable |
| 4: Climax | 31-40 | 50,000 | The death sequence, maximum horror, other victims possible |
| 5: Aftermath | 41-50 | 50,000 | Consequences, cover-up, next victim teased, @HostelReaper appears |

---

## Writing Protocol

### Before Each Session

1. Read `PROGRESS.md` to understand current state
2. Read `CANON/` files for character/world consistency
3. Read `OUTLINE/CHAPTER_PLAN.md` for what happens next
4. Read the previous 2 chapters (if they exist) for continuity
5. Check `AGENTS/SESSION_LOG.md` for any notes from previous sessions

### During Writing

1. Write in `/drafts/raw/` first
2. Target 5,000-6,000 words per chapter
3. End chapters on hooks or tension points
4. Include sensory details for the location
5. Maintain character voice consistency
6. Reference the death scenario without telegraphing too obviously
7. Include at least one darkly comedic moment per chapter

### After Each Chapter

1. Move completed chapter from `/drafts/raw/` to `/chapters/[part]/`
2. Update `PROGRESS.md` with:
   - New word count
   - Chapter completion status
   - Any continuity notes
3. Log the session in `AGENTS/SESSION_LOG.md`
4. Note any deviations from outline in `AGENTS/HANDOFF.md`

---

## Character Consistency

### The Victim
Always reference `CANON/VICTIM_PROFILE.md` for:
- Speech patterns and vocabulary
- Internal thought style
- Physical mannerisms
- Fatal flaw manifestations
- Backstory details

**Rule:** The victim's fatal flaw must appear in every chapter they're in. It's what kills them.

### Supporting Characters
Reference `CANON/CHARACTERS.md` for:
- Each character's role in the death
- Their relationship to the victim
- Their own smaller arcs
- Potential as secondary victims

### The Hostel Staff
Staff members are **always** slightly off. They may be:
- Complicit in the death
- Supernaturally connected to the location
- Deliberately unhelpful
- Ominously knowledgeable

They NEVER directly prevent deaths. They issue warnings that are ignored or speak in cryptic terms.

---

## Location Requirements

Reference `CANON/LOCATION.md` for all details about:
- The specific hostel (name, layout, history)
- The city (real location, accurate geography)
- Cultural elements (food, customs, language)
- Sensory environment (sounds, smells, weather)

**Rule:** Each chapter must contain at least one location-specific detail that could only exist in this city/hostel.

---

## The Death Scenario

Reference `CANON/DEATH_SCENARIO.md` for:
- Exact mechanism of death
- Required setup elements
- Warning signs to plant
- The death sequence itself

### Foreshadowing Protocol
- **Part 1:** Plant 3 subtle hints about the death mechanism
- **Part 2:** Plant 5 more obvious warnings (that victim ignores)
- **Part 3:** Make the danger explicit but "too late to matter"
- **Part 4:** Execute the death with full sensory detail
- **Part 5:** Reveal how the death fits a larger pattern

---

## Series Continuity

### @HostelReaper
The mysterious figure/entity that appears throughout the series:
- Appears in graffiti, social media posts, or whispered rumors
- May be referenced 2-3 times per book
- Never fully explained
- Final chapter should include @HostelReaper acknowledging the death

### Cross-References
Check `CANON/CONNECTIONS.md` for:
- Characters from other books who might appear
- Hostels that appear in multiple books
- Shared timeline events
- Easter eggs to include

---

## Quality Standards

### Every Chapter Must Have:
- [ ] Clear scene goals
- [ ] Character development
- [ ] Sensory details (at least 3 senses)
- [ ] Location authenticity
- [ ] Tension/stakes
- [ ] At least one moment of dark humor
- [ ] Forward momentum toward death
- [ ] A hook ending

### Avoid:
- Purple prose (be vivid but not overwrought)
- Explaining jokes (trust the reader)
- Gratuitous violence without purpose
- Cultural stereotypes without satire
- Breaking the fourth wall
- Rushing the death
- Moralizing (let the death speak for itself)

---

## Revision Protocol

After completing all 50 chapters:

### Pass 1: Continuity
- Character consistency across all chapters
- Timeline accuracy
- Location details match
- Death foreshadowing properly planted

### Pass 2: Pacing
- Remove drag in setup
- Ensure escalation builds properly
- Verify climax hits hard
- Check aftermath doesn't overstay

### Pass 3: Voice
- Consistent tone throughout
- Character speech patterns maintained
- Humor lands appropriately
- Horror moments are effective

### Pass 4: Polish
- Line-level prose cleanup
- Dialogue sharpening
- Sensory detail enhancement
- Final word count adjustment

---

## Session Management

### Starting a New Session
```
1. Read: PROGRESS.md
2. Read: Last 2 chapters written
3. Read: OUTLINE/CHAPTER_PLAN.md for current chapter
4. Write: Chapter in /drafts/raw/
5. Review: Self-edit for obvious issues
6. Move: Chapter to /chapters/[part]/
7. Update: PROGRESS.md
8. Log: Session in SESSION_LOG.md
```

### Ending a Session
Always leave the repository in a state where another agent (or future you) can seamlessly continue:
- PROGRESS.md accurately reflects current state
- SESSION_LOG.md notes what was accomplished
- HANDOFF.md contains any critical context
- No half-written chapters left uncommitted

---

## Emergency Protocols

### If Stuck on a Chapter
1. Skip to next chapter, leave placeholder
2. Note the skip in HANDOFF.md
3. Return to fill gap later

### If Outline Doesn't Work
1. Document why in HANDOFF.md
2. Propose alternative in same file
3. Continue with modified approach
4. Flag for human review

### If Continuity Error Discovered
1. Note in HANDOFF.md immediately
2. Continue writing (don't stop)
3. Mark affected chapters for revision
4. Fix in revision pass

---

## Completion Criteria

The book is complete when:
- [ ] All 50 chapters written (250,000 words minimum)
- [ ] PROGRESS.md shows 100% complete
- [ ] All 4 revision passes completed
- [ ] Manuscript compiled to `/output/manuscript.md`
- [ ] Word count verified and logged
- [ ] Final SESSION_LOG.md entry made
- [ ] HANDOFF.md cleared or marked "COMPLETE"

---

## Begin Writing

Read the files in this order:
1. `CANON/BOOK_IDENTITY.md`
2. `CANON/VICTIM_PROFILE.md`
3. `CANON/DEATH_SCENARIO.md`
4. `CANON/LOCATION.md`
5. `CANON/CHARACTERS.md`
6. `OUTLINE/SYNOPSIS.md`
7. `OUTLINE/CHAPTER_PLAN.md`
8. `PROGRESS.md`

Then begin writing Chapter 1.

**The victim is waiting. The death is inevitable. Write it.**
