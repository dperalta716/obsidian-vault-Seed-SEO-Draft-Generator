#!/usr/bin/env python3
"""
Script to update DM-02 markdown files with extracted hyperlinks from Google Sheets
"""

import os
import re

# Mapping of tab names to markdown file names
TAB_TO_FILE = {
    "Vitamin A (900mcg RAE)": "DM-02-Vitamin-A-Claims.md",
    "Vitamin C (90mg)": "DM-02-Vitamin-C-Claims.md", 
    "Vitamin D (20mcg)": "DM-02-Vitamin-D-Claims.md",
    "Vitamin E (15mg)": "DM-02-Vitamin-E-Claims.md",
    "Vitamin K1 (120mcg)": "DM-02-Vitamin-K1-Claims.md",
    "Thamin (1.2mg)": "DM-02-Thiamine-Claims.md",  # Note spelling difference
    "Riboflavin (1.3mg)": "DM-02-Riboflavin-Claims.md",
    "Niacin (16mg)": "DM-02-Niacin-Claims.md",
    "Vitamin B6": "DM-02-Vitamin-B6-Claims.md",
    "Folate (400mcg)": "DM-02-Folate-Claims.md",
    "Vitamin B12 (2.4mcg)": "DM-02-Vitamin-B12-Claims.md",
    "Biotin (30mcg)": "DM-02-Biotin-Claims.md",
    "Pantothenic Acid (5mg)": "DM-02-Pantothenic-Acid-Claims.md",
    "Iodine (150mcg)": "DM-02-Iodine-Claims.md",
    "Zinc (11mg)": "DM-02-Zinc-Claims.md",
    "Selenium (55mcg)": "DM-02-Selenium-Claims.md",
    "Copper (0.9mg)": "DM-02-Copper-Claims.md",
    "Manganese (2.3mg)": "DM-02-Manganese-Claims.md",
    "Chromium (35mcg)": "DM-02-Chromium-Claims.md",
    "Molybdenum (45mcg)": "DM-02-Molybdenum-Claims.md",
    "CoQ10": "DM-02-CoQ10-Claims.md",
    "PQQ (1mg)": "DM-02-PQQ-Claims.md"
}

# Extracted links data (tab_name, study_name, url)
LINKS_DATA = [
    ("Vitamin A (900mcg RAE)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Vitamin A (900mcg RAE)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Vitamin A (900mcg RAE)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Vitamin C (90mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Vitamin C (90mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Vitamin C (90mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Vitamin C (90mg)", "Immune Function Support", "[Add link here]"),  # These last two need manual links
    ("Vitamin C (90mg)", "Collagen Synthesis Support", "[Add link here]"),
    ("Vitamin C (90mg)", "Antioxidant Function", "[Add link here]"),
    ("Vitamin D (20mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Vitamin D (20mcg)", "Health Canada MVM Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Vitamin D (20mcg)", "EFSA Health Claims", "[NO LINK FOUND]"),
    ("Vitamin D (20mcg)", "What We Eat in America, NHANES 2015-2016", "https://www.ars.usda.gov/ARSUserFiles/80400530/pdf/1516/Table_37_SUP_GEN_15.pdf"),
    ("Vitamin E (15mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Vitamin E (15mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Vitamin E (15mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register/details/POL-HC-6522"),
    ("Vitamin K1 (120mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Vitamin K1 (120mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Vitamin K1 (120mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register/details/POL-HC-6523"),
    ("Thamin (1.2mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Thamin (1.2mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Thamin (1.2mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Riboflavin (1.3mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Riboflavin (1.3mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Riboflavin (1.3mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Niacin (16mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Niacin (16mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Niacin (16mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Vitamin B6", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Vitamin B6", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Vitamin B6", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Folate (400mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Folate (400mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Folate (400mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Vitamin B12 (2.4mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Vitamin B12 (2.4mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Vitamin B12 (2.4mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Biotin (30mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Biotin (30mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Biotin (30mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Pantothenic Acid (5mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Pantothenic Acid (5mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Pantothenic Acid (5mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Iodine (150mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Iodine (150mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Iodine (150mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Zinc (11mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Zinc (11mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Zinc (11mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Selenium (55mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Selenium (55mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Selenium (55mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Copper (0.9mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Copper (0.9mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Copper (0.9mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Manganese (2.3mg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Manganese (2.3mg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Manganese (2.3mg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Chromium (35mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Chromium (35mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Chromium (35mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("Molybdenum (45mcg)", "CFR 101.54", "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-B/part-101/subpart-D/section-101.54"),
    ("Molybdenum (45mcg)", "Health Canada Multi-Vitamin/Mineral Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=multi_vitmin_suppl&lang=eng"),
    ("Molybdenum (45mcg)", "EFSA Health Claims", "https://ec.europa.eu/food/food-feed-portal/screen/health-claims/eu-register"),
    ("CoQ10", "Coenzyme Q10 supplementation—In ageing and disease", "https://pdf.sciencedirectassets.com/271048/1-s2.0-S0047637421X0005X/1-s2.0-S0047637421000932/main.pdf"),
    ("CoQ10", "Coenzyme Q10", "https://pubmed.ncbi.nlm.nih.gov/30285386/"),
    ("CoQ10", "Coenzyme Q10 Supplementation in Aging and Disease", "https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2018.00044/full#F1"),
    ("CoQ10", "Health Canada Antioxidant Monograph", "https://webprod.hc-sc.gc.ca/nhpid-bdipsn/atReq?atid=antiox2&lang=eng"),
    ("CoQ10", "Role of coenzyme Q10 (CoQ10) in cardiac disease, hypertension and Meniere-like syndrome", "https://www.sciencedirect.com/science/article/pii/S0163725809001429"),
    ("PQQ (1mg)", "Pyrroloquinoline quinone stimulates mitochondrial biogenesis", "https://pubmed.ncbi.nlm.nih.gov/19861415/"),
    ("PQQ (1mg)", "Potential physiological importance of PQQ", "https://www.researchgate.net/publication/26869770_Potential_physiological_importance_of_PQQ")
]

def update_file_with_links(file_path, links):
    """Update a markdown file with the appropriate links"""
    
    if not os.path.exists(file_path):
        print(f"Warning: File not found: {file_path}")
        return
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    original_content = content
    updates_made = 0
    
    for study_name, url in links:
        if "[NO LINK FOUND]" in url or url == "[Add link here]":
            continue
            
        # Find the study section
        # Pattern matches "## Study X: {study_name}" followed by "**Link**:"
        pattern = rf'(## Study \d+: {re.escape(study_name)}.*?\n\*\*Link\*\*: )\[Add link here\]'
        
        if re.search(pattern, content, re.DOTALL):
            content = re.sub(pattern, rf'\1[{url}]({url})', content, count=1)
            updates_made += 1
    
    if updates_made > 0:
        with open(file_path, 'w') as f:
            f.write(content)
        print(f"✅ Updated {os.path.basename(file_path)}: {updates_made} links added")
    else:
        print(f"ℹ️  No updates needed for {os.path.basename(file_path)}")

def main():
    # Base directory
    base_dir = "/Users/david/Documents/Obsidian Vaults/claude-code-demo/SEO Clients/Seed/NPD Keyword Research/Claims"
    
    # Group links by file
    file_links = {}
    for tab_name, study_name, url in LINKS_DATA:
        if tab_name in TAB_TO_FILE:
            file_name = TAB_TO_FILE[tab_name]
            if file_name not in file_links:
                file_links[file_name] = []
            file_links[file_name].append((study_name, url))
    
    # Update each file
    print("Starting to update DM-02 files with hyperlinks...\n")
    
    for file_name, links in file_links.items():
        file_path = os.path.join(base_dir, file_name)
        update_file_with_links(file_path, links)
    
    print("\n✅ All files processed successfully!")

if __name__ == "__main__":
    main()