# SOS-WRITERS Pack

Production pipeline installer for the "101 Ways to Die in a Hostel" book series.

## Quick Start

### Install to a Single Book Repo

```bash
# From SOS-WRITERS directory
./pack/install.sh /path/to/book-001-faulty-electrical

# Or from inside the book repo
curl -sSL https://raw.githubusercontent.com/.../pack/install.sh | bash
```

### Install to All Book Repos

```bash
# Install to all 103 books
./pack/install-all.sh

# Install to specific range
./pack/install-all.sh --books 001-010

# Install to specific books
./pack/install-all.sh --books 001,050,100

# Preview without installing
./pack/install-all.sh --dry-run

# Parallel installation (faster)
./pack/install-all.sh --parallel 10
```

## What Gets Installed

Each book repository receives:

```
book-XXX-[slug]/
├── AGENTS/                    # AI writer configurations
│   ├── WRITER_AGENT_INIT_CONTRACT.md
│   ├── WRITER_AUTONOMOUS_INSTRUCTIONS.md
│   └── WRITER_AGENT_BRIEF.md
├── CANON/                     # Book identity (templates)
│   ├── BOOK_IDENTITY.md
│   ├── VICTIM_PROFILE.md
│   ├── DEATH_SCENARIO.md
│   └── LOCATION.md
├── OUTLINE/                   # Story structure
│   └── CHAPTER_PLAN.md
├── FILM/                      # Video production
│   ├── ADAPTATION_BIBLE.md
│   └── trailers/
│       ├── TRAILER_BRIEF.md
│       ├── scripts/
│       ├── prompts/{runway,pika,sora,universal}/
│       ├── assets/
│       ├── renders/
│       └── output/
├── website/                   # Landing page
│   ├── index.html
│   ├── data/book.json
│   ├── vercel.json
│   └── assets/
├── LEGAL/                     # IP protection
│   └── IP_CANON.md
├── REGISTERS/                 # Progress tracking
│   ├── PROGRESS.yaml
│   ├── WORD_COUNT.yaml
│   └── CONTINUITY_LOG.yaml
├── PUBLICATION/               # Publishing specs
│   ├── DISTRIBUTION_MATRIX.md
│   ├── COVER_BRIEF.md
│   └── ...
├── chapters/                  # Manuscript
│   ├── part-1-setup/
│   ├── part-2-escalation/
│   ├── part-3-crisis/
│   ├── part-4-climax/
│   └── part-5-aftermath/
├── drafts/                    # Work in progress
├── research/                  # Reference material
├── assets/                    # Visual assets
└── output/                    # Final files
```

## Pack Contents

```
SOS-WRITERS/
├── pack/
│   ├── install.sh           # Single repo installer
│   ├── install-all.sh       # Batch installer
│   └── README.md            # This file
├── templates/               # Source templates
│   ├── AGENTS/
│   ├── CANON/
│   ├── FILM/
│   ├── WEBSITE/
│   ├── LEGAL/
│   ├── OUTLINE/
│   ├── PUBLICATION/
│   └── REGISTERS/
├── scripts/                 # Automation tools
│   ├── ai-pipeline.sh       # Multi-AI book writer
│   ├── ai-write-book.sh
│   ├── ai-write-chapter.sh
│   ├── ai-router.sh         # AI provider router
│   ├── generate-trailer.sh  # Trailer scaffolding
│   ├── generate-website.sh  # Website scaffolding
│   └── deploy-agents.sh     # Deploy to books
└── config/
    └── ai-providers.yaml    # AI provider configs
```

## Customization

After installation, customize these files in each book repo:

### Required (before writing)
1. `CANON/BOOK_IDENTITY.md` - Book concept
2. `CANON/VICTIM_PROFILE.md` - Main character
3. `CANON/DEATH_SCENARIO.md` - How they die
4. `CANON/LOCATION.md` - Hostel and city
5. `OUTLINE/CHAPTER_PLAN.md` - All 50 chapters

### Before Trailer Production
1. `FILM/trailers/TRAILER_BRIEF.md`
2. Add reference images to `FILM/trailers/assets/`

### Before Website Launch
1. `website/data/book.json` - Full metadata
2. Add cover images to `website/assets/images/`
3. Add trailer to `website/assets/video/`
4. Update purchase links

## Version

- Pack Version: 1.0
- Last Updated: 2026-01-06
- Compatible with: 101 Ways to Die in a Hostel series

## Support

For issues, contact the SOS-WRITERS maintainers or check the main repo.
