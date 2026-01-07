#!/bin/bash

# Create comprehensive GitHub issues for SOS-WRITERS platform
# All assigned to PresidentAnderson with proper labels and milestones

REPO="101-ways-to-die-in-a-hostel/SOS-WRITERS"
ASSIGNEE="PresidentAnderson"

echo "Creating SOS-WRITERS platform issues..."
echo ""

# ============================================
# MILESTONE 1: v1.0 - Core Platform
# ============================================
echo "=== v1.0 - Core Platform ==="

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Complete template documentation with examples" \
    --body "## Description
Add comprehensive examples to all templates showing how to fill them out.

## Tasks
- [ ] Add filled example for each CANON template
- [ ] Add filled example for each PRODUCTION template
- [ ] Add filled example for SALES tracker
- [ ] Add filled example for LAUNCH checklist
- [ ] Create examples/ folder with complete book samples

## Acceptance Criteria
- Every template has at least one complete example
- Examples are realistic and helpful for new users" \
    --label "templates" --label "docs" --label "priority-high" \
    --milestone "v1.0 - Core Platform" \
    --assignee "$ASSIGNEE" && echo "✓ Template documentation"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create install script for new book projects" \
    --body "## Description
Improve the installation script to set up a complete book project.

## Tasks
- [ ] Accept book title, author, genre as parameters
- [ ] Create proper folder structure
- [ ] Copy and customize templates with book info
- [ ] Initialize git repo
- [ ] Create initial PROGRESS.md
- [ ] Generate CLAUDE.md with book-specific instructions
- [ ] Option to connect to GitHub repo

## Usage
\`\`\`bash
./install.sh --title \"My Book\" --author \"Name\" --genre \"Thriller\"
\`\`\`" \
    --label "automation" --label "core" --label "priority-high" \
    --milestone "v1.0 - Core Platform" \
    --assignee "$ASSIGNEE" && echo "✓ Install script"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create word count tracking script" \
    --body "## Description
Script to automatically track word counts across chapters.

## Tasks
- [ ] Count words in all chapter files
- [ ] Update PROGRESS_TRACKER.md automatically
- [ ] Calculate daily/weekly averages
- [ ] Show progress bars in terminal
- [ ] Generate progress report
- [ ] Optional: commit changes

## Output Example
\`\`\`
Book: My Novel
Progress: 45,000 / 80,000 words (56%)
████████████░░░░░░░░

Today: +2,340 words
This week: +12,500 words
Avg/day: 1,785 words
At this pace: 20 days to completion
\`\`\`" \
    --label "automation" --label "core" --label "priority-high" \
    --milestone "v1.0 - Core Platform" \
    --assignee "$ASSIGNEE" && echo "✓ Word count script"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create manuscript compilation script" \
    --body "## Description
Compile all chapters into publishable manuscript formats.

## Tasks
- [ ] Combine chapters in correct order
- [ ] Add front matter (title page, copyright, dedication)
- [ ] Add back matter (author bio, also by, preview)
- [ ] Generate table of contents
- [ ] Output to Markdown
- [ ] Output to DOCX (using pandoc)
- [ ] Output to EPUB
- [ ] Output to PDF (optional)
- [ ] Validate output files

## Dependencies
- pandoc installed" \
    --label "automation" --label "core" --label "priority-medium" \
    --milestone "v1.0 - Core Platform" \
    --assignee "$ASSIGNEE" && echo "✓ Manuscript compilation"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Add revision tracking template" \
    --body "## Description
Create templates for tracking revisions and edits.

## Templates Needed
- [ ] REVISION_CHECKLIST.md - What to check in each revision pass
- [ ] EDIT_LOG.md - Track edits made and why
- [ ] BETA_FEEDBACK_TRACKER.md - Aggregate beta reader feedback
- [ ] EDITOR_RESPONSE.md - Track responses to editor notes

## Each Should Include
- Date tracking
- Chapter/scene level tracking
- Categories of changes
- Notes section" \
    --label "templates" --label "priority-medium" \
    --milestone "v1.0 - Core Platform" \
    --assignee "$ASSIGNEE" && echo "✓ Revision tracking"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create series management tools" \
    --body "## Description
Tools for managing multi-book series.

## Tasks
- [ ] Series continuity checker script
- [ ] Character appearance tracker across books
- [ ] Timeline validator
- [ ] Cross-reference generator
- [ ] Series-wide search tool
- [ ] Shared world bible generator

## Output
- series-continuity-report.md
- character-appearances.json
- timeline.json" \
    --label "automation" --label "core" --label "priority-medium" \
    --milestone "v1.0 - Core Platform" \
    --assignee "$ASSIGNEE" && echo "✓ Series management"

sleep 0.5

# ============================================
# MILESTONE 2: v1.1 - Web Dashboard
# ============================================
echo ""
echo "=== v1.1 - Web Dashboard ==="

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create web dashboard - Project overview" \
    --body "## Description
Build the main dashboard showing all writing projects.

## Features
- [ ] List all book projects
- [ ] Show progress percentage for each
- [ ] Show word count / target
- [ ] Show current status (drafting, editing, published)
- [ ] Quick actions (open, archive, delete)
- [ ] Search and filter projects

## Tech Stack
- Static HTML/CSS/JS (no framework)
- Dark theme matching existing style
- Mobile responsive
- Works offline (local file access)" \
    --label "dashboard" --label "ux" --label "priority-high" \
    --milestone "v1.1 - Web Dashboard" \
    --assignee "$ASSIGNEE" && echo "✓ Dashboard overview"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create web dashboard - Book detail view" \
    --body "## Description
Detailed view for a single book project.

## Features
- [ ] Progress by part/chapter
- [ ] Word count chart over time
- [ ] Checklist completion (CANON, PRODUCTION, etc.)
- [ ] Direct links to edit files
- [ ] Recent activity log
- [ ] Notes/reminders section

## Navigation
- Breadcrumb: Dashboard > [Book Title]
- Quick nav to other books" \
    --label "dashboard" --label "ux" --label "priority-high" \
    --milestone "v1.1 - Web Dashboard" \
    --assignee "$ASSIGNEE" && echo "✓ Book detail view"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create web dashboard - Writing analytics" \
    --body "## Description
Analytics page showing writing productivity.

## Features
- [ ] Words written per day (calendar heatmap)
- [ ] Words written per week/month (bar chart)
- [ ] Best writing times analysis
- [ ] Streak tracking
- [ ] Goal progress
- [ ] Comparative analysis across books

## Charts Needed
- Calendar heatmap (like GitHub contributions)
- Line chart for trends
- Bar chart for comparisons" \
    --label "dashboard" --label "ux" --label "priority-medium" \
    --milestone "v1.1 - Web Dashboard" \
    --assignee "$ASSIGNEE" && echo "✓ Writing analytics"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create web dashboard - Sales tracker" \
    --body "## Description
Sales and revenue tracking dashboard.

## Features
- [ ] Revenue by platform
- [ ] Revenue by book
- [ ] Monthly/yearly trends
- [ ] ROI calculator
- [ ] Expense tracking
- [ ] Profit margins
- [ ] Export to CSV

## Data Source
- Read from SALES_TRACKER.md files
- Manual entry option
- Import from retailer CSV (stretch goal)" \
    --label "dashboard" --label "monetization" --label "priority-medium" \
    --milestone "v1.1 - Web Dashboard" \
    --assignee "$ASSIGNEE" && echo "✓ Sales tracker"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create web dashboard - Launch calendar" \
    --body "## Description
Visual calendar for book launches and milestones.

## Features
- [ ] Monthly calendar view
- [ ] List view option
- [ ] Add/edit events
- [ ] Event types (launch, promo, deadline, etc.)
- [ ] Color coding
- [ ] Reminders
- [ ] Export to iCal

## Event Types
- Book launch
- Pre-order start
- Promotion/sale
- ARC deadline
- Edit deadline
- Marketing campaign" \
    --label "dashboard" --label "ux" --label "priority-medium" \
    --milestone "v1.1 - Web Dashboard" \
    --assignee "$ASSIGNEE" && echo "✓ Launch calendar"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create web dashboard - Series bible viewer" \
    --body "## Description
Interactive series bible for reference while writing.

## Features
- [ ] Character database (searchable)
- [ ] Location database
- [ ] Timeline viewer
- [ ] Cross-reference links
- [ ] Quick lookup while writing
- [ ] Add/edit entries
- [ ] Import from markdown files

## Views
- List view
- Card view
- Detail modal
- Relationship map (stretch goal)" \
    --label "dashboard" --label "ux" --label "priority-low" \
    --milestone "v1.1 - Web Dashboard" \
    --assignee "$ASSIGNEE" && echo "✓ Series bible viewer"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Add navigation menu to dashboard" \
    --body "## Description
Create consistent navigation across all dashboard pages.

## Features
- [ ] Sidebar or top nav
- [ ] Links to all sections
- [ ] Current page highlight
- [ ] Quick search
- [ ] Mobile hamburger menu
- [ ] User settings access

## Pages to Link
- Dashboard Home
- All Books
- Analytics
- Sales
- Calendar
- Series Bible
- Settings" \
    --label "dashboard" --label "ux" --label "priority-high" \
    --milestone "v1.1 - Web Dashboard" \
    --assignee "$ASSIGNEE" && echo "✓ Navigation menu"

sleep 0.5

# ============================================
# MILESTONE 3: v1.2 - AI Integration
# ============================================
echo ""
echo "=== v1.2 - AI Integration ==="

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Integrate Claude for autonomous writing" \
    --body "## Description
Deep integration with Claude for AI-assisted writing.

## Features
- [ ] CLAUDE.md template improvements
- [ ] Context injection from CANON files
- [ ] Chapter generation workflow
- [ ] Revision suggestions
- [ ] Continuity checking
- [ ] Style consistency validation

## Requirements
- Works with Claude Code CLI
- Works with API directly
- Graceful handling of context limits" \
    --label "ai-integration" --label "core" --label "priority-high" \
    --milestone "v1.2 - AI Integration" \
    --assignee "$ASSIGNEE" && echo "✓ Claude integration"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Integrate OpenAI Codex for writing" \
    --body "## Description
OpenAI Codex integration for writing assistance.

## Features
- [ ] CODEX.md template improvements
- [ ] Batch chapter generation
- [ ] Parallel book processing
- [ ] Integration with existing scripts
- [ ] Cost tracking
- [ ] Output validation

## Scripts
- codex-write-chapter.sh improvements
- codex-batch-books.sh improvements" \
    --label "ai-integration" --label "core" --label "priority-medium" \
    --milestone "v1.2 - AI Integration" \
    --assignee "$ASSIGNEE" && echo "✓ Codex integration"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create AI writing router" \
    --body "## Description
Smart router to use the best AI for each task.

## Features
- [ ] Task classification
- [ ] Cost optimization
- [ ] Quality routing
- [ ] Fallback handling
- [ ] Usage logging
- [ ] Budget limits

## Routing Logic
- Outline: Claude (better at structure)
- Prose: GPT-4 or Claude
- Editing: Claude
- Formatting: Codex
- Research: Perplexity/web search" \
    --label "ai-integration" --label "automation" --label "priority-medium" \
    --milestone "v1.2 - AI Integration" \
    --assignee "$ASSIGNEE" && echo "✓ AI router"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Add AI-powered continuity checker" \
    --body "## Description
Use AI to check for continuity errors across the manuscript.

## Features
- [ ] Character consistency (appearance, speech patterns)
- [ ] Timeline consistency
- [ ] Location consistency
- [ ] Plot hole detection
- [ ] Foreshadowing tracker
- [ ] Report generation

## Output
- continuity-report.md with issues found
- Suggested fixes
- Confidence scores" \
    --label "ai-integration" --label "automation" --label "priority-medium" \
    --milestone "v1.2 - AI Integration" \
    --assignee "$ASSIGNEE" && echo "✓ Continuity checker"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Add AI-powered blurb generator" \
    --body "## Description
Generate book descriptions/blurbs using AI.

## Features
- [ ] Multiple length options (tweet, short, long)
- [ ] Genre-appropriate tone
- [ ] A/B variations
- [ ] Keyword optimization
- [ ] Hook analysis

## Output
- 280-character version (social)
- 150-word version (Amazon)
- 300-word version (detailed)
- Tagline options" \
    --label "ai-integration" --label "priority-low" \
    --milestone "v1.2 - AI Integration" \
    --assignee "$ASSIGNEE" && echo "✓ Blurb generator"

sleep 0.5

# ============================================
# MILESTONE 4: v2.0 - Platform Launch
# ============================================
echo ""
echo "=== v2.0 - Platform Launch ==="

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create user authentication system" \
    --body "## Description
User accounts for the SaaS platform.

## Features
- [ ] Email/password registration
- [ ] OAuth (Google, GitHub)
- [ ] Password reset
- [ ] Email verification
- [ ] Session management
- [ ] User profiles

## Security
- Bcrypt password hashing
- JWT tokens
- Rate limiting
- HTTPS required" \
    --label "core" --label "priority-high" \
    --milestone "v2.0 - Platform Launch" \
    --assignee "$ASSIGNEE" && echo "✓ User auth"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create subscription/billing system" \
    --body "## Description
Monetization through subscriptions.

## Features
- [ ] Free tier (limited features)
- [ ] Pro tier (full features)
- [ ] Team tier (collaboration)
- [ ] Stripe integration
- [ ] Usage tracking
- [ ] Invoice generation

## Pricing Tiers
- Free: 1 project, basic templates
- Pro ($9/mo): Unlimited projects, AI features
- Team ($29/mo): Collaboration, shared libraries" \
    --label "monetization" --label "core" --label "priority-high" \
    --milestone "v2.0 - Platform Launch" \
    --assignee "$ASSIGNEE" && echo "✓ Billing system"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create cloud storage for projects" \
    --body "## Description
Cloud storage and sync for writing projects.

## Features
- [ ] Project upload/download
- [ ] Real-time sync
- [ ] Version history
- [ ] Conflict resolution
- [ ] Offline support
- [ ] Export/import

## Tech
- S3 or equivalent storage
- Delta sync for efficiency
- End-to-end encryption option" \
    --label "core" --label "priority-high" \
    --milestone "v2.0 - Platform Launch" \
    --assignee "$ASSIGNEE" && echo "✓ Cloud storage"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create collaboration features" \
    --body "## Description
Multi-user collaboration on projects.

## Features
- [ ] Invite collaborators
- [ ] Role-based permissions (owner, editor, viewer)
- [ ] Real-time presence
- [ ] Comments on chapters
- [ ] Change tracking
- [ ] Activity feed

## Roles
- Owner: Full control
- Editor: Edit content, not settings
- Viewer: Read-only access
- Beta Reader: Read + comment" \
    --label "community" --label "core" --label "priority-medium" \
    --milestone "v2.0 - Platform Launch" \
    --assignee "$ASSIGNEE" && echo "✓ Collaboration"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create template marketplace" \
    --body "## Description
Marketplace for users to share/sell templates.

## Features
- [ ] Browse templates by category
- [ ] Free and paid templates
- [ ] Creator profiles
- [ ] Ratings and reviews
- [ ] One-click install
- [ ] Revenue sharing (70/30)

## Categories
- Genre-specific (Romance, Thriller, SciFi)
- Function-specific (Plotting, Marketing)
- Series management
- Business/legal" \
    --label "community" --label "monetization" --label "priority-low" \
    --milestone "v2.0 - Platform Launch" \
    --assignee "$ASSIGNEE" && echo "✓ Template marketplace"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create API for third-party integrations" \
    --body "## Description
Public API for integrations and extensions.

## Endpoints
- [ ] /projects - CRUD for projects
- [ ] /chapters - CRUD for chapters
- [ ] /progress - Word count and progress
- [ ] /exports - Generate exports
- [ ] /ai - AI writing features

## Features
- API key authentication
- Rate limiting
- Webhooks
- OpenAPI documentation
- SDK for common languages" \
    --label "api" --label "core" --label "priority-medium" \
    --milestone "v2.0 - Platform Launch" \
    --assignee "$ASSIGNEE" && echo "✓ API"

sleep 0.5

env -u GH_TOKEN gh issue create -R "$REPO" \
    --title "Create mobile app (or PWA)" \
    --body "## Description
Mobile access to writing projects.

## Options
1. Progressive Web App (PWA) - faster to build
2. Native apps (iOS/Android) - better UX

## Features
- [ ] View projects
- [ ] Read/edit chapters
- [ ] Dictation support
- [ ] Offline mode
- [ ] Push notifications
- [ ] Quick capture (notes/ideas)

## Recommendation
Start with PWA, native later based on demand" \
    --label "ux" --label "priority-low" \
    --milestone "v2.0 - Platform Launch" \
    --assignee "$ASSIGNEE" && echo "✓ Mobile app"

sleep 0.5

echo ""
echo "================================"
echo "All platform issues created!"
echo ""
echo "View issues: https://github.com/$REPO/issues"
echo ""
echo "Milestones:"
echo "  v1.0 - Core Platform"
echo "  v1.1 - Web Dashboard"
echo "  v1.2 - AI Integration"
echo "  v2.0 - Platform Launch"
