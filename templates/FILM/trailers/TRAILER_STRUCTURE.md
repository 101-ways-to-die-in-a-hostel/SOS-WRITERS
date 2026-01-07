# Video Trailer Structure

## Directory Layout

Each book's `FILM/trailers/` directory follows this structure:

```
FILM/
├── ADAPTATION_BIBLE.md          # Film/TV adaptation guide
└── trailers/
    ├── TRAILER_BRIEF.md         # Trailer concept and goals
    ├── scripts/
    │   ├── 101-ways_[slug]_trailer-30s_script.md    # Master script
    │   ├── 101-ways_[slug]_trailer-30s_storyboard.md
    │   └── 101-ways_[slug]_trailer-30s_voiceover.md
    ├── prompts/
    │   ├── runway/              # Runway ML prompts
    │   │   ├── shot-01_opening.txt
    │   │   ├── shot-02_victim.txt
    │   │   └── ...
    │   ├── pika/                # Pika Labs prompts
    │   │   └── ...
    │   ├── sora/                # OpenAI Sora prompts
    │   │   └── ...
    │   └── universal/           # Platform-agnostic prompts
    │       └── shot-descriptions.yaml
    ├── assets/
    │   ├── reference-images/    # Style/mood references
    │   ├── audio/
    │   │   ├── voiceover/       # VO recordings
    │   │   ├── music/           # Background tracks
    │   │   └── sfx/             # Sound effects
    │   └── branding/            # Series logos, titles
    ├── renders/
    │   ├── raw/                 # Raw AI-generated clips
    │   ├── edited/              # Post-processed clips
    │   └── composited/          # Final assembled scenes
    └── output/
        ├── 101-ways_[slug]_trailer-30s_v1.mp4
        ├── 101-ways_[slug]_trailer-30s_final.mp4
        └── thumbnails/
            ├── youtube_1280x720.jpg
            ├── tiktok_1080x1920.jpg
            └── instagram_1080x1080.jpg
```

---

## Naming Convention

### Pattern
```
[series]_[book-slug]_[content-type]_[variant].[ext]
```

### Components
| Component | Format | Example |
|-----------|--------|---------|
| series | `101-ways` | Fixed prefix |
| book-slug | `faulty-electrical` | From repo name |
| content-type | `trailer-30s`, `trailer-60s`, `teaser-15s` | Duration/type |
| variant | `script`, `storyboard`, `v1`, `final` | Version/format |
| ext | `.md`, `.mp4`, `.txt`, `.yaml` | File type |

### Examples
```
101-ways_faulty-electrical_trailer-30s_script.md
101-ways_faulty-electrical_trailer-30s_storyboard.md
101-ways_faulty-electrical_trailer-30s_v1.mp4
101-ways_faulty-electrical_trailer-30s_final.mp4
101-ways_gas-leak-explosion_teaser-15s_tiktok.mp4
```

---

## Trailer Types

### 30-Second Trailer (Primary)
- **Purpose:** Book launch, social media, ads
- **Structure:** 6-8 shots, voice-over, music
- **Platforms:** YouTube, Instagram Reels, TikTok

### 15-Second Teaser
- **Purpose:** Pre-launch hype, paid ads
- **Structure:** 3-4 shots, text overlays, no VO
- **Platforms:** TikTok, Instagram Stories, YouTube Shorts

### 60-Second Extended
- **Purpose:** YouTube, website, pitch meetings
- **Structure:** Full narrative arc, character intro
- **Platforms:** YouTube, website embed

---

## Production Pipeline

```
1. BRIEF         → Define trailer goals, tone, key moments
2. SCRIPT        → Write shot list, VO, timing
3. STORYBOARD    → Visual beat-by-beat breakdown
4. PROMPTS       → Generate AI prompts per platform
5. GENERATE      → Run AI video generation
6. REVIEW        → Select best takes
7. EDIT          → Assemble, add audio
8. RENDER        → Export final versions
9. DISTRIBUTE    → Upload to platforms
```
