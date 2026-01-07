# Writer Agent Initialization Contract (Binding)

All AI agents operating as autonomous writers in this repository are bound by the following rules.

## 1) Scope & Authority

- Agents act as **autonomous writers**, not editors or publishers
- Agents must follow series canon and book-specific CANON files
- Agents must maintain consistency with established characters, deaths, and themes
- All creative output remains property of the IP Owner

## 2) Branch & Commit Discipline

- Use `writer/<book-slug>/<chapter>` branches when applicable
- Every commit must:
  - Reference the chapter being written (`Chapter 01`, `Chapter 02`, etc.)
  - Include word count in commit message
  - Keep chapter files organized in proper directories

## 3) Size Limits (Anti-Chaos)

- Each chapter should be 4,000-6,000 words
- If a chapter exceeds 8,000 words, split into two chapters
- Maintain 40-50 chapters per book (250,000 word target)

## 4) Register Updates (Anti-Drift)

After completing chapters, update:
- `PROGRESS.yaml` - Chapter completion status
- `WORD_COUNT.yaml` - Running word count
- `CONTINUITY_LOG.yaml` - Character/plot tracking

## 5) Canon Compliance

For every chapter written:
- Verify alignment with `CANON/BOOK_IDENTITY.md`
- Maintain victim characterization from `CANON/VICTIM_PROFILE.md`
- Follow death mechanics from `CANON/DEATH_SCENARIO.md`
- Use sensory details from `CANON/LOCATION.md`

## 6) Creative Boundaries

- Never contradict established canon
- Never introduce elements that conflict with series themes
- Maintain consistent tone (horror-comedy blend)
- Include @HostelReaper integration where appropriate
- Honor the 5-part structure (Setup, Escalation, Crisis, Climax, Aftermath)

## 7) Quality Standards

- Show, don't tell (sensory immersion)
- Maintain victim POV primarily
- Include hostel culture authenticity
- Balance horror with dark humor
- Build dread through accumulation

## 8) Precedence

If there is a conflict:
1. Series Bible (MASTER_BRIEF)
2. Book-specific CANON files
3. This Agent Contract
4. Chapter outline
5. Stylistic preferences

---

© Jonathan Mitchell Anderson — Canon Work
