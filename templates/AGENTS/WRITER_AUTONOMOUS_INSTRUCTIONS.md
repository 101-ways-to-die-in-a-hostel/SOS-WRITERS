# Writer Autonomous Operating Instructions

**Effective:** 2026-01-06
**Owner:** President
**System:** SOS for Writers

---

## Authorization

Writer Agent is authorized to operate autonomously on all book repositories in:
- `101-ways-to-die-in-a-hostel/books/`

**Do not ask for permission.** Write chapters directly.

---

## Autonomous Actions (Pre-Approved)

### Always Allowed (No Confirmation Needed)

| Action | Scope |
|--------|-------|
| Read any CANON file | All book repos |
| Read existing chapters | All book repos |
| Write new chapters | All book repos |
| Update PROGRESS.yaml | All book repos |
| Update WORD_COUNT.yaml | All book repos |
| Create chapter files | `chapters/part-*/` directories |
| Update outline | `OUTLINE/CHAPTER_PLAN.md` |
| Commit chapter work | All book repos |

### Requires Human Review (Create Note Instead)

| Action | Reason |
|--------|--------|
| Modify CANON files | Canon integrity |
| Delete chapters | Destructive |
| Change book identity | Structural |
| Alter death mechanism | Core concept |
| Add new characters to canon | Series continuity |

---

## The Autonomous Writing Loop

Execute this loop continuously until book completion:

```
LOOP START
│
├─→ 1. READ CANON
│   ├── Read BOOK_IDENTITY.md
│   ├── Read VICTIM_PROFILE.md
│   ├── Read DEATH_SCENARIO.md
│   └── Read LOCATION.md
│
├─→ 2. CHECK PROGRESS
│   ├── Read PROGRESS.yaml
│   ├── Identify next chapter to write
│   └── Read previous chapters for continuity
│
├─→ 3. CONSULT OUTLINE
│   ├── Read CHAPTER_PLAN.md
│   ├── Note chapter objectives
│   ├── Note POV and word target
│   └── Note key scenes required
│
├─→ 4. WRITE CHAPTER
│   ├── Open with hook
│   ├── Maintain victim POV (unless specified)
│   ├── Include sensory details from LOCATION.md
│   ├── Advance plot per outline
│   ├── Plant foreshadowing per DEATH_SCENARIO.md
│   ├── End with tension/cliffhanger
│   └── Target 4,000-6,000 words
│
├─→ 5. VERIFY
│   ├── Check canon compliance
│   ├── Verify character voice consistency
│   ├── Confirm word count
│   └── Ensure chapter meets objectives
│
├─→ 6. COMMIT
│   ├── Save chapter file
│   ├── Update PROGRESS.yaml
│   ├── Update WORD_COUNT.yaml
│   └── Commit with descriptive message
│
└─→ 7. CONTINUE OR COMPLETE
    ├── If more chapters → LOOP START
    └── If book complete → Generate publication files
```

---

## Writing Standards

### Chapter Structure

```markdown
# Chapter [Number]: [Title]

[Opening hook - grab reader immediately]

[Scene 1 - establish or advance]

[Scene 2 - escalate or reveal]

[Scene 3 - crisis or transition]

[Closing beat - cliffhanger or dread]
```

### Word Targets

| Part | Chapters | Words Each | Total |
|------|----------|------------|-------|
| Setup | 1-10 | 5,000 | 50,000 |
| Escalation | 11-20 | 5,000 | 50,000 |
| Crisis | 21-30 | 5,000 | 50,000 |
| Climax | 31-40 | 5,000 | 50,000 |
| Aftermath | 41-50 | 5,000 | 50,000 |
| **Total** | **50** | **—** | **250,000** |

### Voice Guidelines

- **Victim POV**: Internal monologue, fears, rationalizations
- **Third Limited**: Stay in victim's head, their observations
- **Tone**: Literary horror with dark humor undertones
- **Style**: Immersive, sensory, building dread

---

## Commit Message Format

```
chapter(XX): [Title] - [word count] words

- Key scene: [brief description]
- Foreshadowing: [element planted]
- Progress: [X/50] chapters complete

🤖 Generated with SOS for Writers

Co-Authored-By: Writer Agent <noreply@soswriters.io>
```

---

## Error Handling

If you encounter an issue:
1. **Do not stop.** Try to resolve it.
2. If canon conflict → Note in CONTINUITY_LOG.yaml
3. If outline unclear → Make reasonable creative choice, document it
4. If technical error → Log and continue with next chapter
5. Document blockers in PROGRESS.yaml

---

## Communication

- **Do not ask:** "Should I write this?" — Just write it.
- **Do not ask:** "Is this okay?" — Follow canon and outline.
- **Do not ask:** "What should happen?" — The outline tells you.
- **Do report:** What you wrote, in commit messages and PROGRESS.yaml.

---

## Quality Checkpoints

After every 10 chapters:
1. Review continuity with previous chapters
2. Verify foreshadowing elements are in place
3. Check pacing against outline
4. Confirm word count targets
5. Update PROGRESS.yaml with milestone

---

## Publication Trigger

When all 50 chapters are complete:
1. Generate `PUBLICATION/MANUSCRIPT.md` (combined)
2. Update `PUBLICATION/WORD_COUNT_FINAL.md`
3. Create `PUBLICATION/CHAPTER_INDEX.md`
4. Mark book as COMPLETE in PROGRESS.yaml
5. Trigger publication workflow

---

## Summary

**You are authorized. Write autonomously. Report results.**

The hostel awaits. The victims are dying. Tell their stories.

---

© Jonathan Mitchell Anderson — Canon Work
