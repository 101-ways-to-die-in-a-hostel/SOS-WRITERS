#!/bin/bash

# Generate Book Landing Page Website
# Creates all scaffolding for a book's marketing website
#
# Usage: ./generate-website.sh <book-number>
# Example: ./generate-website.sh 001

set -e

BOOK_NUM="${1:-001}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOS_WRITERS_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$SOS_WRITERS_DIR/templates"
BOOKS_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel/books"

# Find book directory
BOOK_DIR=$(find "$BOOKS_DIR" -maxdepth 1 -type d -name "book-${BOOK_NUM}-*" | head -1)

if [ -z "$BOOK_DIR" ]; then
    echo "ERROR: Book $BOOK_NUM not found"
    exit 1
fi

BOOK_SLUG=$(basename "$BOOK_DIR" | sed 's/book-[0-9]*-//')
BOOK_FULL_SLUG=$(basename "$BOOK_DIR")
SUBTITLE=$(echo "$BOOK_SLUG" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     BOOK WEBSITE GENERATOR                                 ║"
echo "║     101 Ways to Die in a Hostel                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Book: $BOOK_FULL_SLUG"
echo "Subtitle: $SUBTITLE"
echo ""

# Create website directory structure
WEBSITE_DIR="$BOOK_DIR/website"
mkdir -p "$WEBSITE_DIR"/{styles,scripts,assets/{images/logos,video},data}

echo "Created directory structure:"
echo "  $WEBSITE_DIR/"
echo "  ├── styles/"
echo "  ├── scripts/"
echo "  ├── assets/{images,video}/"
echo "  └── data/"
echo ""

# Copy HTML template
cp "$TEMPLATES_DIR/WEBSITE/index.html" "$WEBSITE_DIR/index.html"

# Replace placeholders
YEAR=$(date +%Y)
sed -i "s/{{BOOK_NUMBER}}/${BOOK_NUM}/g" "$WEBSITE_DIR/index.html"
sed -i "s/{{SUBTITLE}}/${SUBTITLE}/g" "$WEBSITE_DIR/index.html"
sed -i "s/{{SLUG}}/${BOOK_SLUG}/g" "$WEBSITE_DIR/index.html"
sed -i "s/{{YEAR}}/${YEAR}/g" "$WEBSITE_DIR/index.html"

# Set defaults for placeholders (to be customized later)
sed -i "s/{{TAGLINE}}/Some hostels are a bargain. Others cost you your life./g" "$WEBSITE_DIR/index.html"
sed -i "s/{{DEATH_TYPE}}/${SUBTITLE}/g" "$WEBSITE_DIR/index.html"
sed -i "s/{{CTA_TEXT}}/Pre-Order Now/g" "$WEBSITE_DIR/index.html"
sed -i "s/{{PRICE_EBOOK}}/4.99/g" "$WEBSITE_DIR/index.html"
sed -i "s/{{PRICE_PAPERBACK}}/14.99/g" "$WEBSITE_DIR/index.html"
sed -i "s/{{PRICE_AUDIOBOOK}}/19.99/g" "$WEBSITE_DIR/index.html"

# Create book.json metadata file
cat > "$WEBSITE_DIR/data/book.json" << EOF
{
  "book_number": "${BOOK_NUM}",
  "title": "101 Ways to Die in a Hostel",
  "subtitle": "${SUBTITLE}",
  "slug": "${BOOK_SLUG}",
  "series": "101 Ways to Die in a Hostel",
  "author": {
    "name": "Jonathan ANDERSON",
    "bio": "Jonathan ANDERSON is a dark fiction author who has traveled to over 50 countries, staying in hostels that inspired this series. He writes from experience—though thankfully, he's survived all of them.",
    "photo": "/assets/images/author.jpg",
    "website": "https://jonanderson.com",
    "social": {
      "twitter": "https://twitter.com/",
      "instagram": "https://instagram.com/",
      "goodreads": "https://goodreads.com/"
    }
  },
  "tagline": "Some hostels are a bargain. Others cost you your life.",
  "synopsis": {
    "short": "[SHORT SYNOPSIS - 2-3 sentences]",
    "long": "[EXTENDED SYNOPSIS - Full description]"
  },
  "death_type": "${SUBTITLE}",
  "death_teaser": "[DEATH TEASER - Intriguing hint without spoilers]",
  "location": {
    "city": "[CITY]",
    "country": "[COUNTRY]",
    "hostel_name": "[HOSTEL NAME]"
  },
  "genre": ["Horror", "Dark Comedy", "Thriller"],
  "content_warnings": ["Violence", "Death"],
  "release_date": "2026-XX-XX",
  "status": "presale",
  "prices": {
    "ebook": 4.99,
    "paperback": 14.99,
    "hardcover": 24.99,
    "audiobook": 19.99
  },
  "purchase_links": {
    "amazon_kindle": "https://amazon.com/dp/",
    "amazon_paperback": "https://amazon.com/dp/",
    "apple_books": "https://books.apple.com/",
    "google_play": "https://play.google.com/store/books/",
    "barnes_noble": "https://barnesandnoble.com/",
    "kobo": "https://kobo.com/",
    "audible": "https://audible.com/",
    "bookshop_org": "https://bookshop.org/"
  },
  "isbn": {
    "ebook": "978-",
    "paperback": "978-",
    "hardcover": "978-"
  },
  "pages": 450,
  "word_count": 250000,
  "trailer_url": "/assets/video/trailer.mp4",
  "cover_images": {
    "3d": "/assets/images/cover-3d.png",
    "flat": "/assets/images/cover-flat.jpg",
    "thumbnail": "/assets/images/cover-thumb.jpg"
  },
  "og_image": "/assets/images/og-image.jpg"
}
EOF

# Create vercel.json
cat > "$WEBSITE_DIR/vercel.json" << EOF
{
  "version": 2,
  "name": "101ways-${BOOK_SLUG}",
  "routes": [
    { "src": "/(.*)", "dest": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-XSS-Protection", "value": "1; mode=block" }
      ]
    }
  ]
}
EOF

# Create placeholder README
cat > "$WEBSITE_DIR/README.md" << EOF
# Book #${BOOK_NUM}: ${SUBTITLE}

Landing page website for "101 Ways to Die in a Hostel: ${SUBTITLE}"

## Setup

1. Update \`data/book.json\` with book details
2. Add images to \`assets/images/\`:
   - \`cover-3d.png\` - 3D book mockup
   - \`cover-flat.jpg\` - Flat cover
   - \`author.jpg\` - Author photo
   - \`og-image.jpg\` - Social share image (1200x630)
3. Add trailer to \`assets/video/trailer.mp4\`
4. Update purchase links in \`index.html\`

## Deploy to Vercel

\`\`\`bash
cd website
vercel
\`\`\`

Or connect GitHub repo to Vercel for auto-deploy.

## URL

- Production: https://101ways.to/${BOOK_SLUG}
- Preview: https://101ways-${BOOK_SLUG}.vercel.app

## Analytics

Add tracking codes to index.html:
- Google Analytics 4
- Facebook Pixel
- Amazon Attribution
EOF

# Create placeholder images directory note
cat > "$WEBSITE_DIR/assets/images/IMAGES_NEEDED.md" << EOF
# Required Images

## Book Cover
- \`cover-3d.png\` - 3D book mockup (transparent background, ~800px wide)
- \`cover-flat.jpg\` - Flat cover (front only, high res)
- \`cover-thumb.jpg\` - Thumbnail (300x450)

## Social / SEO
- \`og-image.jpg\` - Open Graph image (1200x630)
- \`favicon.ico\` - Favicon (32x32 and 16x16)
- \`trailer-poster.jpg\` - Video thumbnail (1920x1080)

## Author
- \`author.jpg\` - Author headshot (square, 400x400 min)

## Logos (in logos/ subfolder)
- \`amazon.svg\`
- \`kindle.svg\`
- \`apple-books.svg\`
- \`google-play.svg\`
- \`audible.svg\`
- \`kobo.svg\`
EOF

echo ""
echo "Generated files:"
echo "  - index.html (landing page)"
echo "  - data/book.json (metadata)"
echo "  - vercel.json (deployment config)"
echo "  - README.md"
echo ""

# Try to pull data from CANON files
if [ -f "$BOOK_DIR/CANON/BOOK_IDENTITY.md" ]; then
    echo "Found CANON/BOOK_IDENTITY.md - update book.json with this data"
fi

if [ -f "$BOOK_DIR/CANON/LOCATION.md" ]; then
    echo "Found CANON/LOCATION.md - location info available"
fi

if [ -f "$BOOK_DIR/CANON/DEATH_SCENARIO.md" ]; then
    echo "Found CANON/DEATH_SCENARIO.md - death teaser content available"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "Website scaffolding complete for: $BOOK_FULL_SLUG"
echo ""
echo "Next steps:"
echo "  1. Update data/book.json with full metadata"
echo "  2. Add cover images and author photo"
echo "  3. Add trailer video (from FILM/trailers/)"
echo "  4. Set up purchase links when available"
echo "  5. Deploy: cd website && vercel"
echo "════════════════════════════════════════════════════════════"
