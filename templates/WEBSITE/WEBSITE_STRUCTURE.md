# Book Website Structure

## Overview

Each book in the "101 Ways to Die in a Hostel" series gets a dedicated landing page website for marketing, presales, and distribution.

## URL Pattern

```
https://101ways.to/[book-slug]
```

Examples:
- `https://101ways.to/faulty-electrical`
- `https://101ways.to/gas-leak-explosion`
- `https://101ways.to/structural-collapse`

Alternative patterns:
- `https://[book-slug].101waystodieinhostel.com`
- `https://101waystodieinhostel.com/book/[xxx]`

---

## Directory Structure

```
book-[XXX]-[slug]/
└── website/
    ├── index.html              # Main landing page
    ├── styles/
    │   └── main.css            # Styles (or Tailwind)
    ├── scripts/
    │   └── main.js             # Interactions
    ├── assets/
    │   ├── images/
    │   │   ├── cover-3d.png    # 3D book cover mockup
    │   │   ├── cover-flat.jpg  # Flat cover
    │   │   ├── author.jpg      # Author photo
    │   │   ├── og-image.jpg    # Social share image
    │   │   └── favicon.ico
    │   └── video/
    │       └── trailer.mp4     # Embedded trailer
    ├── data/
    │   └── book.json           # Book metadata
    ├── vercel.json             # Deployment config
    └── README.md
```

---

## Page Sections

### 1. Hero Section
- Book cover (3D mockup)
- Title and subtitle
- Tagline/hook
- Primary CTA: "Pre-Order Now" / "Buy Now"
- Secondary CTA: "Watch Trailer"

### 2. Synopsis
- Short blurb (2-3 sentences)
- Extended synopsis (expandable)
- Genre tags
- Content warnings (optional)

### 3. The Death (Teaser)
- Intriguing hint at death type
- "How will they die?" hook
- Visual element related to death

### 4. Trailer Embed
- 30-second video trailer
- Auto-play option (muted)
- Full-screen capability

### 5. About the Author
- Author photo
- Bio paragraph
- Social links
- Link to author website

### 6. Series Context
- "Book #[XXX] in the series"
- Links to other books
- Series logo

### 7. Purchase Options
- Amazon Kindle
- Amazon Paperback
- Apple Books
- Google Play Books
- Barnes & Noble
- Kobo
- Direct purchase (if available)
- Audiobook (Audible)

### 8. Reviews/Testimonials
- Pull quotes
- Star ratings
- Review source links

### 9. Newsletter Signup
- Email capture
- "Get notified of new releases"
- Lead magnet option

### 10. Footer
- Copyright
- Legal links
- Social links
- Series website link

---

## Metadata (book.json)

```json
{
  "book_number": "001",
  "title": "101 Ways to Die in a Hostel",
  "subtitle": "Faulty Electrical",
  "slug": "faulty-electrical",
  "series": "101 Ways to Die in a Hostel",
  "author": {
    "name": "Jonathan ANDERSON",
    "bio": "...",
    "photo": "/assets/images/author.jpg",
    "website": "https://jonanderson.com",
    "social": {
      "twitter": "@...",
      "instagram": "@...",
      "goodreads": "..."
    }
  },
  "tagline": "Some hostels are a bargain. Others cost you your life.",
  "synopsis": {
    "short": "A backpacker's dream hostel becomes a nightmare when...",
    "long": "..."
  },
  "death_type": "Faulty Electrical",
  "death_teaser": "The wiring hasn't been updated since 1962...",
  "location": {
    "city": "Prague",
    "country": "Czech Republic",
    "hostel_name": "The Bohemian Dream"
  },
  "genre": ["Horror", "Dark Comedy", "Thriller"],
  "content_warnings": ["Violence", "Death"],
  "release_date": "2026-03-15",
  "status": "presale",
  "prices": {
    "ebook": 4.99,
    "paperback": 14.99,
    "hardcover": 24.99,
    "audiobook": 19.99
  },
  "purchase_links": {
    "amazon_kindle": "https://amazon.com/dp/...",
    "amazon_paperback": "https://amazon.com/dp/...",
    "apple_books": "https://books.apple.com/...",
    "google_play": "https://play.google.com/store/books/...",
    "barnes_noble": "https://barnesandnoble.com/...",
    "kobo": "https://kobo.com/...",
    "audible": "https://audible.com/...",
    "bookshop_org": "https://bookshop.org/..."
  },
  "isbn": {
    "ebook": "978-...",
    "paperback": "978-...",
    "hardcover": "978-..."
  },
  "pages": 450,
  "word_count": 250000,
  "trailer_url": "/assets/video/trailer.mp4",
  "cover_images": {
    "3d": "/assets/images/cover-3d.png",
    "flat": "/assets/images/cover-flat.jpg",
    "thumbnail": "/assets/images/cover-thumb.jpg"
  },
  "og_image": "/assets/images/og-image.jpg",
  "reviews": [
    {
      "quote": "Absolutely terrifying...",
      "source": "Goodreads",
      "rating": 5,
      "reviewer": "..."
    }
  ],
  "related_books": ["002", "015", "042"]
}
```

---

## Deployment

### Vercel Configuration (vercel.json)

```json
{
  "version": 2,
  "name": "101ways-[slug]",
  "alias": ["[slug].101waystodieinhostel.com"],
  "routes": [
    { "src": "/(.*)", "dest": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" }
      ]
    }
  ]
}
```

### DNS Setup

For `101ways.to` domain:
```
CNAME [slug] → cname.vercel-dns.com
```

Or for subdomain pattern:
```
CNAME [slug].101waystodieinhostel.com → cname.vercel-dns.com
```

---

## Analytics & Tracking

### Required Integrations
- [ ] Google Analytics 4
- [ ] Facebook Pixel
- [ ] Amazon Attribution (for affiliate tracking)
- [ ] Email capture (ConvertKit/Mailchimp)

### UTM Parameters

For tracking traffic sources:
```
?utm_source=[source]&utm_medium=[medium]&utm_campaign=book[xxx]
```

### Conversion Events
- `page_view` - Landing page loaded
- `trailer_play` - Trailer started
- `trailer_complete` - Trailer finished
- `cta_click` - Purchase button clicked
- `purchase_link_[platform]` - Specific retailer clicked
- `newsletter_signup` - Email captured

---

## SEO

### Meta Tags
```html
<title>Book [XXX]: [Subtitle] | 101 Ways to Die in a Hostel</title>
<meta name="description" content="[Short synopsis]">
<meta name="keywords" content="horror, hostel, backpacker, [death-type], dark comedy">

<!-- Open Graph -->
<meta property="og:title" content="[Subtitle] - 101 Ways to Die in a Hostel">
<meta property="og:description" content="[Tagline]">
<meta property="og:image" content="/assets/images/og-image.jpg">
<meta property="og:type" content="book">

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="[Subtitle]">
<meta name="twitter:description" content="[Tagline]">
<meta name="twitter:image" content="/assets/images/og-image.jpg">

<!-- Book-specific -->
<meta property="book:author" content="Jonathan ANDERSON">
<meta property="book:isbn" content="978-...">
<meta property="book:release_date" content="2026-03-15">
```

### Structured Data (JSON-LD)
```json
{
  "@context": "https://schema.org",
  "@type": "Book",
  "name": "101 Ways to Die in a Hostel: [Subtitle]",
  "author": {
    "@type": "Person",
    "name": "Jonathan ANDERSON"
  },
  "isbn": "978-...",
  "bookFormat": "EBook",
  "numberOfPages": 450,
  "genre": ["Horror", "Dark Comedy"],
  "inLanguage": "en",
  "publisher": {
    "@type": "Organization",
    "name": "..."
  }
}
```
