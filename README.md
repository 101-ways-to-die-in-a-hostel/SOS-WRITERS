# SOS-WRITERS

**Save Our Sanity - A Complete Autonomous Book Production Toolkit**

Turn your book idea into a published, marketed, and selling product with minimal friction. SOS-WRITERS provides everything you need: templates, scripts, workflows, and AI agent configurations for the entire book lifecycle.

---

## What Is This?

SOS-WRITERS is a turnkey system for writers who want to:

- **Write** with AI assistance (Claude, Codex, GPT)
- **Track** progress automatically
- **Edit** with structured beta reader and editor workflows
- **Produce** covers, trailers, and marketing assets
- **Launch** with a proven 12-week checklist
- **Sell** across all platforms
- **Monitor** sales and royalties

Built by writers, for writers. Works for standalone books or 100+ book series.

---

## Quick Start

### 1. Install to a New Book Project

```bash
# Clone SOS-WRITERS
git clone https://github.com/101-ways-to-die-in-a-hostel/SOS-WRITERS.git

# Install templates to your book repo
./SOS-WRITERS/pack/install.sh /path/to/your-book-repo
```

### 2. Or Copy Templates Manually

```bash
cp -r SOS-WRITERS/templates/* /path/to/your-book-repo/
```

### 3. Start Writing

Open `CLAUDE.md` or `templates/AGENTS/CODEX.md` and let AI agents help you write.

---

## What's Included

### Templates (`/templates`)

| Folder | Purpose | Files |
|--------|---------|-------|
| `CANON/` | Story bible - characters, locations, plot | 5 templates |
| `WRITING/` | Progress tracking, chapter templates | 2 templates |
| `OUTLINE/` | Synopsis, chapter plans, beat sheets | 1 template |
| `EDITING/` | Beta reader guides, editor handoffs | 2 templates |
| `PRODUCTION/` | Cover briefs, character art, mood boards | 4 templates |
| `MARKETING/` | Marketing kit, ad copy for all platforms | 2 templates |
| `DISTRIBUTION/` | Retailer specs, pricing, rights management | 4 templates |
| `LAUNCH/` | 12-week launch checklist | 1 template |
| `SALES/` | Sales tracking, royalty calculations | 1 template |
| `PUBLICATION/` | ISBN, print specs, audiobook specs | 5 templates |
| `FILM/` | Trailer scripts, adaptation bible | 4 templates |
| `LEGAL/` | IP canon, rights documentation | 1 template |
| `WEBSITE/` | Landing page template | 2 templates |
| `AGENTS/` | AI agent configurations | 4 templates |

### Scripts (`/scripts`)

| Script | Purpose |
|--------|---------|
| `ai-write-book.sh` | Full autonomous book writing pipeline |
| `ai-write-chapter.sh` | Write a single chapter with AI |
| `codex-write-book.sh` | OpenAI Codex integration |
| `codex-batch-books.sh` | Batch process multiple books |
| `generate-trailer.sh` | Generate book trailer scripts |
| `generate-website.sh` | Generate landing pages |
| `deploy-agents.sh` | Deploy AI writing agents |

### Pack (`/pack`)

| Script | Purpose |
|--------|---------|
| `install.sh` | Install templates to a single book |
| `install-all.sh` | Install templates to multiple books |

### Specs (`/specs`)

| Document | Purpose |
|----------|---------|
| `SOS_FOR_WRITERS.md` | Complete writer's guide |
| `PRODUCTION_PIPELINE.md` | Full workflow documentation |

---

## The Writer's Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                        SOS-WRITERS WORKFLOW                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. PLAN          2. WRITE         3. EDIT         4. PRODUCE   │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐   │
│  │ CANON/  │ ──▶ │WRITING/ │ ──▶ │EDITING/ │ ──▶ │PRODUCTION│   │
│  │ OUTLINE/│     │ AGENTS/ │     │         │     │ FILM/    │   │
│  └─────────┘     └─────────┘     └─────────┘     └─────────┘   │
│                                                                  │
│  5. PUBLISH       6. LAUNCH        7. SELL        8. TRACK      │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐   │
│  │PUBLICAT-│ ──▶ │ LAUNCH/ │ ──▶ │MARKETING│ ──▶ │ SALES/  │   │
│  │ION/     │     │         │     │DISTRIBU-│     │         │   │
│  │DISTRIB- │     │         │     │TION/    │     │         │   │
│  └─────────┘     └─────────┘     └─────────┘     └─────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## AI Agent Integration

SOS-WRITERS works with multiple AI providers:

### Claude (Anthropic)
- Use `CLAUDE.md` for autonomous writing
- Supports Claude Code CLI for direct integration
- Chapter-by-chapter progress tracking

### OpenAI Codex
- Use `templates/AGENTS/CODEX.md`
- Batch processing support
- Integration with GitHub Copilot

### Custom Agents
- Configure in `config/ai-providers.yaml`
- Router script for multi-provider workflows
- Parallel processing for series

---

## Template Categories

### For Writing

**CANON/** - Your story's source of truth
- `BOOK_IDENTITY.md` - Title, genre, comps, themes
- `VICTIM_PROFILE.md` - Main character deep dive
- `DEATH_SCENARIO.md` - Plot/conflict details
- `LOCATION.md` - Setting and world-building
- `CHARACTERS.md` - Supporting cast

**WRITING/** - Track your progress
- `PROGRESS_TRACKER.md` - Chapter-by-chapter tracking
- `CHAPTER_TEMPLATE.md` - Scene planning per chapter

### For Editing

**EDITING/** - Structured feedback
- `BETA_READER_GUIDE.md` - What to send beta readers
- `EDITOR_HANDOFF.md` - Everything your editor needs

### For Production

**PRODUCTION/** - Visual assets
- `BOOK_COVER_BRIEF.md` - Cover designer instructions
- `CHARACTER_SKETCHES_BRIEF.md` - Character art specs
- `LOCATION_PHOTOS_BRIEF.md` - Setting imagery
- `MOOD_BOARD_BRIEF.md` - Aesthetic direction

**FILM/** - Trailers and adaptations
- `ADAPTATION_BIBLE.md` - Screen adaptation guide
- `trailers/` - Trailer script templates

### For Publishing

**PUBLICATION/** - Technical specs
- `PRESS_KIT.md` - Media kit template
- `INGRAMSPARK_SPECS.md` - Print specifications
- `AUDIOBOOK_SPECS.md` - Audio production specs
- `DISTRIBUTION_MATRIX.md` - Where to publish

**DISTRIBUTION/** - Rights and pricing
- `DISTRIBUTION_STRATEGY.md` - Channel strategy
- `RETAILER_SPECS.md` - Platform requirements
- `RIGHTS_MANAGEMENT.md` - Copyright and licensing
- `PRICING_MATRIX.md` - Global pricing strategy

### For Launch

**LAUNCH/** - Go to market
- `LAUNCH_CHECKLIST.md` - 12-week countdown

**MARKETING/** - Promotion
- `MARKETING_KIT.md` - Full marketing strategy
- `AD_COPY.md` - Ads for Amazon, Facebook, Google, etc.

### For Sales

**SALES/** - Track revenue
- `SALES_TRACKER.md` - Monthly sales by platform

---

## Directory Structure for Your Book

After installation, your book repo will look like:

```
your-book/
├── CANON/
│   ├── BOOK_IDENTITY.md
│   ├── VICTIM_PROFILE.md
│   ├── DEATH_SCENARIO.md
│   ├── LOCATION.md
│   └── CHARACTERS.md
├── WRITING/
│   ├── PROGRESS_TRACKER.md
│   └── CHAPTER_TEMPLATE.md
├── OUTLINE/
│   └── CHAPTER_PLAN.md
├── EDITING/
│   ├── BETA_READER_GUIDE.md
│   └── EDITOR_HANDOFF.md
├── PRODUCTION/
│   ├── BOOK_COVER_BRIEF.md
│   ├── CHARACTER_SKETCHES_BRIEF.md
│   ├── LOCATION_PHOTOS_BRIEF.md
│   └── MOOD_BOARD_BRIEF.md
├── MARKETING/
│   ├── MARKETING_KIT.md
│   └── AD_COPY.md
├── DISTRIBUTION/
│   ├── DISTRIBUTION_STRATEGY.md
│   ├── RETAILER_SPECS.md
│   ├── RIGHTS_MANAGEMENT.md
│   └── PRICING_MATRIX.md
├── LAUNCH/
│   └── LAUNCH_CHECKLIST.md
├── SALES/
│   └── SALES_TRACKER.md
├── PUBLICATION/
│   └── ...
├── chapters/
│   ├── part-1/
│   ├── part-2/
│   └── ...
├── drafts/
├── website/
└── CLAUDE.md
```

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add or improve templates
4. Submit a pull request

### Template Guidelines
- Use `[PLACEHOLDER]` syntax for fillable fields
- Include examples where helpful
- Keep templates format-agnostic (works in any genre)
- Add checklist items where applicable

---

## License

MIT License - Use freely, modify as needed, no attribution required.

---

## Credits

Created by **Jonathan Anderson** and the 101 Ways to Die in a Hostel team.

Built with assistance from Claude (Anthropic).

---

## Support

- **Issues:** [GitHub Issues](https://github.com/101-ways-to-die-in-a-hostel/SOS-WRITERS/issues)
- **Discussions:** [GitHub Discussions](https://github.com/101-ways-to-die-in-a-hostel/SOS-WRITERS/discussions)

---

*SOS-WRITERS: Because writing a book is hard enough without reinventing the wheel.*
