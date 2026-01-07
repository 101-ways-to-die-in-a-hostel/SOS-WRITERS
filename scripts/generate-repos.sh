#!/bin/bash

# SOS for Writers - Repository Generator
# Generates all 103 book repositories from template

set -e

# Configuration
ORG_DIR="/home/presidentanderson/Projects/orgs/101-ways-to-die-in-a-hostel"
TEMPLATE_DIR="$ORG_DIR/101-ways-to-die-in-a-hostel/SOS-WRITERS/templates"
BOOKS_DIR="$ORG_DIR/books"

# Book definitions (number, slug, title, death, category)
declare -a BOOKS=(
    "001|faulty-electrical|Faulty Electrical|Faulty electrical wiring causing electrocution|Environmental"
    "002|gas-leak-explosion|Gas Leak Explosion|Gas leak leading to explosion|Environmental"
    "003|structural-collapse|Structural Collapse|Structural collapse of an old building|Environmental"
    "004|shower-slip|The Fatal Slip|Slip and fall in a wet communal shower|Environmental"
    "005|carbon-monoxide|Silent Night Deadly Night|Carbon monoxide poisoning from malfunctioning heater|Environmental"
    "006|kitchen-fire|Kitchen Inferno|Fire from unattended cooking in shared kitchen|Environmental"
    "007|rooftop-fall|Rooftop Roulette|Falling from rickety rooftop terrace|Environmental"
    "008|elevator-trap|Going Down|Trapped in malfunctioning elevator|Environmental"
    "009|bunk-bed-crush|Bunk Bed Burial|Crushed by falling bunk bed|Environmental"
    "010|pool-drowning|Midnight Swim|Drowning in hostel pool after hours|Environmental"
    "011|renovation-debris|Under Construction|Hit by debris during renovation work|Environmental"
    "012|chemical-reaction|Chemical Reaction|Allergic reaction to cleaning chemicals|Environmental"
    "013|toxic-mold|The Spore Settler|Toxic mold exposure in damp rooms|Environmental"
    "014|heatstroke|Heat Death|Heatstroke in non-air-conditioned room during heatwave|Environmental"
    "015|hypothermia|Cold Comfort|Hypothermia in unheated rooms during winter|Environmental"
    "016|venomous-bite|Bed Bugs Literally|Bitten by venomous insect/spider hiding in bedding|Environmental"
    "017|window-fall|Defenestration Station|Window falling out of frame onto street below|Environmental"
    "018|dumbwaiter|Dumb Way to Die|Caught in outdated dumbwaiter system|Environmental"
    "019|ceiling-fan|Fan Fatal|Hit by falling ceiling fan|Environmental"
    "020|lightning-strike|Struck Down|Lightning strike through leaky roof|Environmental"
    "021|serial-killer|The Backpacker|Murdered by serial killer posing as backpacker|Fellow Travelers"
    "022|balcony-push|Balcony Drop|Pushed from balcony during hostel party|Fellow Travelers"
    "023|roommate-poison|Bitter Roommate|Poisoned by roommate with grudge|Fellow Travelers"
    "024|wristband-strangle|Wristband Wrangle|Strangled with hostel wristband|Fellow Travelers"
    "025|pillow-suffocation|Pillow Talk|Suffocated with pillow during sleep|Fellow Travelers"
    "026|cult-sacrifice|The Gathering|Victim of ritual sacrifice by cult members|Fellow Travelers"
    "027|cannibalism|Budget Cuts|Cannibalized by desperate stranded travelers|Fellow Travelers"
    "028|theft-fight|Locker Wars|Fatal fight over stolen belongings|Fellow Travelers"
    "029|poker-murder|All In|Killed for winning too much at hostel poker night|Fellow Travelers"
    "030|mistaken-identity|Wrong Bed|Mistaken identity by assassin targeting another guest|Fellow Travelers"
    "031|drugged-drink|Last Call|Drugged drink at hostel bar|Fellow Travelers"
    "032|stampede|Exit Strategy|Trampled in stampede during evacuation|Fellow Travelers"
    "033|companion-betrayal|Travel Buddy|Betrayed by travel companion|Fellow Travelers"
    "034|snoring-murder|Snore No More|Smothered by snoring roommates pillow attack|Fellow Travelers"
    "035|manager-psycho|Management Issues|Victim of hostel managers psychotic break|Fellow Travelers"
    "036|hunting-game|The Hunt|Falling victim to most dangerous game hunting scheme|Fellow Travelers"
    "037|witness-killing|Saw Too Much|Killed for witnessing illegal activity in common room|Fellow Travelers"
    "038|noise-revenge|Quiet Hours|Revenge killing for loud midnight return|Fellow Travelers"
    "039|hazing-death|Initiation|Victim of group hazing gone wrong|Fellow Travelers"
    "040|shower-assault|Shower Showdown|Fatal assault over last shower slot|Fellow Travelers"
    "041|alcohol-poisoning|Pub Crawl Flatline|Alcohol poisoning at hostel pub crawl|Self-Inflicted"
    "042|overdose|Stall Warning|Overdose in bathroom stall|Self-Inflicted"
    "043|choking-noodles|Ramen Reaper|Choking on budget instant noodles|Self-Inflicted"
    "044|sleepwalking|Night Walk|Sleepwalking off balcony|Self-Inflicted"
    "045|food-allergy|Street Food Roulette|Allergic reaction to unknown local food|Self-Inflicted"
    "046|medication-error|Lost in Translation|Misreading medication dosage|Self-Inflicted"
    "047|dehydration|Dry Spell|Extreme dehydration from hangover|Self-Inflicted"
    "048|diy-electrical|Sparks Fly|DIY electrical repair gone wrong|Self-Inflicted"
    "049|autoerotic|Pod Problems|Autoerotic asphyxiation in private pod|Self-Inflicted"
    "050|horror-marathon|Scared to Death|Heart attack from horror movie marathon|Self-Inflicted"
    "051|parkour|Urban Explorer|Attempting parkour between hostel buildings|Self-Inflicted"
    "052|viral-challenge|For the Likes|Viral challenge gone wrong|Self-Inflicted"
    "053|selfie-ledge|Edge Case|Taking selfie on dangerous ledge|Self-Inflicted"
    "054|planning-stress|Itinerary Overload|Stress-induced aneurysm from travel planning|Self-Inflicted"
    "055|headphone-strangle|Tangled Up|Falling asleep with headphones causing strangulation|Self-Inflicted"
    "056|local-substances|Local Flavor|Experimenting with local substances|Self-Inflicted"
    "057|shallow-dive|Shallow End|Diving into too-shallow hostel pool|Self-Inflicted"
    "058|diy-tattoo|DIY Ink|Self-performed body modification infection|Self-Inflicted"
    "059|swallowed-key|Key Mistake|Swallowing hostel key to hide it|Self-Inflicted"
    "060|poison-cooking|Chefs Special|Attempting to cook exotic dish with poisonous ingredients|Self-Inflicted"
    "061|ghost-possession|Room 237|Possessed by ghost of former guest|Supernatural"
    "062|cursed-artifact|Souvenir from Hell|Cursed by local artifact purchased at market|Supernatural"
    "063|soul-extraction|The Oldest Guest|Soul extracted by ancient entity living in building|Supernatural"
    "064|dimension-portal|Check-Out Time|Dimension-shifting hostel room portal malfunction|Supernatural"
    "065|time-loop|Groundhog Stay|Time loop exhaustion leading to cardiac arrest|Supernatural"
    "066|sentient-mold|The Blob Below|Absorbed by sentient mold in shower|Supernatural"
    "067|burial-ground|Bad Foundation|Hostel built on ancient burial ground|Supernatural"
    "068|furniture-transform|Part of the Furniture|Transforming into hostel furniture after staying too long|Supernatural"
    "069|nightmare-realm|Dream Hostel|Trapped in nightmare realm during sleep|Supernatural"
    "070|local-taboo|Sacred Ground|Breaking local taboo/curse|Supernatural"
    "071|body-swap|Identity Crisis|Body-swapped with dying local|Supernatural"
    "072|quantum-disaster|Echoes|Quantum entanglement with past disaster|Supernatural"
    "073|haunted-mirror|Mirror Mirror|Haunted mirror showing death reflection|Supernatural"
    "074|siren-plumbing|The Pipes Sing|Succumbing to siren call from plumbing|Supernatural"
    "075|psychic-vampire|Energy Thief|Psychic vampire roommate draining life force|Supernatural"
    "076|forbidden-book|Bookworm|Reading forbidden book from hostel library|Supernatural"
    "077|wifi-consciousness|Connected Forever|Digital consciousness uploaded to hostel wifi|Supernatural"
    "078|time-dilation|Room 1000 Years|Aging rapidly in time-dilated room|Supernatural"
    "079|astral-projection|Out of Body|Astral projection without return|Supernatural"
    "080|ouija-possession|Spirit Board|Demonic possession through hostel ouija board|Supernatural"
    "081|luggage-room|Left Luggage|Mistakenly locked in luggage storage room|Circumstantial"
    "082|wall-decoration|Decoration Day|Crushed by falling backpacker wall decorations|Circumstantial"
    "083|disease-outbreak|Patient Zero|Infected by rare disease outbreak|Circumstantial"
    "084|gang-violence|Crossfire|Wrong place during local gang violence|Circumstantial"
    "085|terrorist-attack|Wrong Place Wrong Time|Caught in terrorist attack targeting tourists|Circumstantial"
    "086|drug-mule|Package Deal|Mistaken for drug mule by cartel|Circumstantial"
    "087|natural-disaster|Acts of God|Natural disaster hitting hostel|Circumstantial"
    "088|laundry-machine|Spin Cycle|Falling into industrial laundry machine|Circumstantial"
    "089|vehicle-strike|Street Crossing|Hit by vehicle outside hostel entrance|Circumstantial"
    "090|wildlife-invasion|Uninvited Guests|Local wildlife invasion|Circumstantial"
    "091|intelligence-witness|Spook Story|Accidental witness to intelligence operation|Circumstantial"
    "092|food-poisoning|Fridge of Doom|Severe food poisoning from communal fridge|Circumstantial"
    "093|detergent-allergy|Clean Kill|Allergic reaction to laundry detergent|Circumstantial"
    "094|maze-lost|No Exit|Lost in maze-like hostel during emergency|Circumstantial"
    "095|mistranslation|Lost in Translation|Mistranslated warning sign leading to danger|Circumstantial"
    "096|protest-crossfire|Civil Unrest|Caught in crossfire of local protest|Circumstantial"
    "097|criminal-witness|Thin Walls|Witness to criminal activity in neighboring room|Circumstantial"
    "098|identity-theft|Stolen Identity|Victim of identity theft leading to targeted killing|Circumstantial"
    "099|tap-water|Dont Drink the Water|Drinking contaminated tap water|Circumstantial"
    "100|doppelganger|Doppelganger|Mistakenly identified as missing person|Circumstantial"
    "101|local-law|Ignorance of the Law|Breaking local law unwittingly resulting in capital punishment|Circumstantial"
    "102|200-dollars|The 200 Dollar Question|Stabbed for not lending 200 dollars fast enough|Circumstantial"
    "103|series-hub|Series Hub|Series Hub and World Map|Bonus"
)

# Create books directory
mkdir -p "$BOOKS_DIR"

# Function to create a book repository
create_book_repo() {
    local NUM="$1"
    local SLUG="$2"
    local TITLE="$3"
    local DEATH="$4"
    local CATEGORY="$5"

    local REPO_NAME="book-${NUM}-${SLUG}"
    local REPO_PATH="$BOOKS_DIR/$REPO_NAME"

    echo "Creating: $REPO_NAME"

    # Create directory structure
    mkdir -p "$REPO_PATH"/{.github/workflows,AGENTS,CANON,OUTLINE,chapters/{part-1-setup,part-2-escalation,part-3-crisis,part-4-climax,part-5-aftermath},drafts/{raw,revised,polished},research,assets/{character-sketches,location-photos,mood-board},output,PUBLICATION,FILM}

    # Copy template files
    cp "$TEMPLATE_DIR/CLAUDE.md" "$REPO_PATH/AGENTS/"
    cp "$TEMPLATE_DIR/CANON/"* "$REPO_PATH/CANON/" 2>/dev/null || true
    cp "$TEMPLATE_DIR/OUTLINE/"* "$REPO_PATH/OUTLINE/" 2>/dev/null || true
    cp "$TEMPLATE_DIR/PUBLICATION/"* "$REPO_PATH/PUBLICATION/" 2>/dev/null || true
    cp "$TEMPLATE_DIR/FILM/"* "$REPO_PATH/FILM/" 2>/dev/null || true

    # Create README with book-specific info
    cat > "$REPO_PATH/README.md" << EOF
# Book #${NUM}: ${TITLE}

**Series:** 101 Ways to Die in a Hostel
**Author:** Jonathan ANDERSON
**Category:** ${CATEGORY}
**Status:** INITIALIZATION

## The Death
${DEATH}

## The Victim
**Name:** [TBD]
**Age:** [TBD]
**Archetype:** [TBD]
**Fatal Flaw:** [TBD]

## The Location
**Hostel:** [TBD]
**City:** [TBD]

## Progress
- [ ] Canon files complete
- [ ] Outline complete
- [ ] Chapters 1-10 drafted
- [ ] Chapters 11-20 drafted
- [ ] Chapters 21-30 drafted
- [ ] Chapters 31-40 drafted
- [ ] Chapters 41-50 drafted
- [ ] Revision pass complete
- [ ] Publication files ready
- [ ] Film adaptation bible complete

## Word Count
Target: 250,000 words
Current: 0 words (0%)
EOF

    # Create PROGRESS.md
    cat > "$REPO_PATH/PROGRESS.md" << EOF
# Book #${NUM} Progress Dashboard

## Current Status
**Phase:** INITIALIZATION
**Active Chapter:** None
**Last Updated:** $(date +%Y-%m-%d)

## Word Count Tracking
| Part | Target | Current | % |
|------|--------|---------|---|
| Part 1 (Setup) | 50,000 | 0 | 0% |
| Part 2 (Escalation) | 50,000 | 0 | 0% |
| Part 3 (Crisis) | 50,000 | 0 | 0% |
| Part 4 (Climax) | 50,000 | 0 | 0% |
| Part 5 (Aftermath) | 50,000 | 0 | 0% |
| **TOTAL** | **250,000** | **0** | **0%** |

## Session Log
| Date | Session | Words Added | Chapters Completed |
|------|---------|-------------|-------------------|

## Next Actions
1. Complete CANON/BOOK_IDENTITY.md
2. Complete CANON/VICTIM_PROFILE.md
3. Complete CANON/DEATH_SCENARIO.md
4. Complete CANON/LOCATION.md
5. Complete OUTLINE/CHAPTER_PLAN.md
6. Begin autonomous writing
EOF

    # Create LICENSE
    cat > "$REPO_PATH/LICENSE.md" << EOF
# License

Copyright © $(date +%Y) Jonathan Mitchell Anderson. All rights reserved.

This work is proprietary and confidential. No part of this book may be reproduced, stored in a retrieval system, or transmitted in any form or by any means without the prior written permission of the author.

For licensing inquiries: PUBLISHING@RICHEREVERYDAYINEVERYWAY.COM
EOF

    # Create .gitignore
    cat > "$REPO_PATH/.gitignore" << EOF
# OS files
.DS_Store
Thumbs.db

# Editor files
*.swp
*.swo
*~

# Compiled output (regenerated)
output/*.pdf
output/*.epub

# Temporary files
*.tmp
*.temp

# Local settings
.env
.env.local
EOF

    # Replace placeholders in template files
    find "$REPO_PATH" -type f -name "*.md" -exec sed -i "s/\[XXX\]/${NUM}/g" {} \;
    find "$REPO_PATH" -type f -name "*.md" -exec sed -i "s/\[TITLE\]/${TITLE}/g" {} \;

    echo "  Created: $REPO_PATH"
}

# Main execution
echo "=========================================="
echo "SOS for Writers - Repository Generator"
echo "=========================================="
echo ""
echo "Creating 103 book repositories..."
echo ""

for book in "${BOOKS[@]}"; do
    IFS='|' read -r NUM SLUG TITLE DEATH CATEGORY <<< "$book"
    create_book_repo "$NUM" "$SLUG" "$TITLE" "$DEATH" "$CATEGORY"
done

echo ""
echo "=========================================="
echo "Complete! Created 103 book repositories."
echo "Location: $BOOKS_DIR"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review and customize each book's CANON files"
echo "2. Complete the OUTLINE/CHAPTER_PLAN.md for each book"
echo "3. Initialize git in each repository (optional)"
echo "4. Begin autonomous writing"
