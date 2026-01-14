# SQL-CrUX-Normalization-Analysis
SQL-driven competitive analysis of HOKA’s UX performance using BigQuery and CrUX field data. This repository features a custom normalization script that processes millions of real-user metrics to benchmark Core Web Vitals (LCP, INP, CLS) across 29 retail brands. Includes data engineering logic for device-specific density and SEO risk modeling.


**ENGINEERING A COMPETITIVE UX ANALYSIS FOR HOKA**

**Tools:** Google BigQuery, SQL, Chrome User Experience Report (CrUX), Looker Studio

**Link to Data Visualization in Looker Studio:** 

HOKA UX Performance and Competitive Index https://lookerstudio.google.com/reporting/d0572145-0823-4c23-8cc9-8143ca0c269a

**Summary**
The Core Issue: Despite HOKA's rapid market growth as a top challenger brand in the sporting goods sector, its digital performance is failing to keep pace. An analysis of real-world user data reveals that HOKA’s website ranks in the bottom quartile of the running industry, creating significant risks for organic search visibility and customer conversion.

**Key Findings:**
**Competitive Ranking:** 

- HOKA ranks 24th out of 29 analyzed brands, trailing direct competitors like On Running, Brooks, and niche leaders like Norda (Figure 2).

- The "UX Score" Gap: HOKA holds a UX Score of 74.2%, while top performer Norda achieves 97.44%. This 22-point gap indicates that HOKA users are significantly more likely to experience frustration (Figure 2).

**Critical Technical Failure:** 

- The primary bottleneck is Interactivity (INP) on mobile devices. 48.29% of user interactions (clicks, taps, filter selections) on HOKA’s mobile site are rated "Needs Improvement" or "Poor"(Figure 1).

**Business Implications:**

- SEO & Discovery: Google uses Core Web Vitals as a direct ranking signal. By failing to meet the "Good" thresholds for interactivity and loading, HOKA risks being down-ranked in organic search results, ceding visibility to faster competitors.
- Revenue Risk: High Interaction to Next Paint (INP) latency correlates with cart abandonment.1 If nearly half of mobile interactions are sluggish, users are more likely to bounce to competitor sites.

**Recommendations:**

- Immediate Engineering Action: Audit third-party JavaScript and main-thread execution on mobile to resolve the high INP latency.
- Strategic Monitoring: Adopt the SQL-based monitoring pipeline provided in this analysis to track monthly progress against the industry benchmark.

![Figure 1 HOKA Cross-Device UX Performance](https://github.com/user-attachments/assets/81c26d26-f22f-4370-96e4-1a8ee0e272d0)

Figure 1: HOKA Cross-Device UX Performance

![Figure 2 HOKA UX Competitive Index](https://github.com/user-attachments/assets/d0b427e9-b073-4b4a-a743-e22ed768529d)

Figure 2: HOKA UX Competitive Index

**1. Introduction: A CrUX Field Data Analysis of HOKA vs. Competitors**

HOKA is currently a primary beneficiary of a massive "Market share reshuffle" in the sporting goods industry, where challenger brands are outpacing incumbents like Nike and Adidas.2 However, as the industry pivots, HOKA’s digital infrastructure is becoming a liability. An analysis of real-world user data reveals that HOKA’s website ranks in the bottom quartile of the running industry, creating significant risks for organic search visibility and customer retention (Figure 2).

Google explicitly uses Core Web Vitals, metrics that quantify the quality of user experience, as ranking signals for Search.3 For a "challenger brand" like HOKA, which is aggressively fighting for market share against incumbents like Nike and Adidas, a slow website does more than annoy customers; it actively suppresses the brand's visibility in organic search results.

My investigation began with a personal frustration: attempting to buy a pair of HOKA Cliftons on my smartphone resulted in a sluggish, unresponsive interface. However, anecdotal evidence is insufficient for business strategy. I wanted to determine if this was an isolated incident or a systemic SEO liability.

To answer this, I engineered a comparative analysis using the Chrome User Experience Report (CrUX). Unlike "Lab Data" (synthetic tests), CrUX provides "Field Data", metrics aggregated from millions of real Chrome users.4 This dataset is the exact source of truth Google uses to determine if a website provides a "Good" experience worthy of high search placement.

This analysis benchmarks HOKA against 28 competing running brands, moving beyond simple load times to analyze the specific "Web Vitals" that dictate Google ranking favourability and user retention.

**2. Methodology: Field Data Over Lab Data**

For this analysis, I prioritized "Field Data" (Real User Monitoring) over "Lab Data" (synthetic testing).
While lab tools like Lighthouse are excellent for debugging, they simulate a controlled environment, they cannot replicate the variability of real-world device capabilities or network conditions. By leveraging the CrUX dataset via Google BigQuery, I accessed aggregated performance metrics from millions of actual Chrome users. This moves the analysis from theoretical performance to the actual experience of customers in the wild.

**3. Data Engineering: Developing the Normalization Script**

Raw CrUX data is powerful but often fragmented. To derive actionable insights, I developed a custom SQL pipeline to clean, group, and normalize the data.

**Step 1:** Origin Grouping and Brand Attribution

The CrUX dataset identifies websites by their "origin" (e.g., https://www.hoka.com). However, for a competitive analysis, I needed to aggregate data at the brand level and filter out noise.

I wrote a CASE WHEN logic block using REGEXP_CONTAINS to map disjointed origins to clean, human-readable brand names. This allowed me to group varying URL structures, such as brooksrunning.com versus on-running.com, into standardized categories for visualization.

-- Excerpt from data cleaning logic

CASE
WHEN REGEXP_CONTAINS(origin, r'hoka') THEN 'HOKA'
WHEN REGEXP_CONTAINS(origin, r'on-running') THEN 'On Running'
WHEN REGEXP_CONTAINS(origin, r'brooksrunning') THEN 'Brooks'
ELSE 'Other Competitor'
END AS brand_name

**Step 2:** Device-Specific Normalization

A critical component of this analysis was properly handling device density. A simple average of performance metrics can be misleading if it doesn't account for how users access the site (e.g., 90% mobile vs. 10% desktop).

To solve this, I engineered a normalization script that adjusts performance metrics based on device density. I utilized the SAFE_DIVIDE function in BigQuery to prevent division-by-zero errors while calculating the normalized proportion of "Fast," "Average," and "Slow" experiences for each metric.

I calculated the performance rates for key metrics, by dividing the metric count by the specific density of that device (Desktop, Phone, or Tablet).

-- Normalization Logic: (Metric Count / Device Density) = Normalized Proportion

SAFE_DIVIDE(
fast_lcp,
CASE
WHEN device = 'desktop' THEN desktopDensity
WHEN device = 'phone' THEN phoneDensity
ELSE tabletDensity
END)
AS fast_lcp

This normalization ensures that the final "UX Score" is not just a raw number, but a weighted reflection of the actual user base's device preferences.

**4. Data Visualization: Building the Looker Studio Dashboard** 

After processing the data in BigQuery, I connected the normalized dataset to Looker Studio to visualize the competitive landscape. The goal was to translate technical metrics into a business-accessible "UX Score" (Figure 1).

**The Three Pillars of UX**

I structured the dashboard around Google's Core Web Vitals, categorizing them into three pillars to score user sessions:5

1. Loading (LCP): Measures how fast the main content becomes visible.6﻿
2. Interactivity (INP): Measures responsiveness to user taps and clicks (replacing the older FID metric).7﻿
3. Visual Stability (CLS): Measures layout shifts that cause user frustration.8﻿

**Dashboard Architecture**

I designed the visualization to rank 29 brands based on the percentage of Chrome users who have "Good" UX experiences. The dashboard features:

1. Ranked Tables: A leaderboard showing the "UX Score" alongside detailed breakdowns for LCP, INP, and CLS "Needs Improvement" percentages.
2. Top Ten Charts: Bar charts highlighting industry leaders for each specific metric, such as Newton Running and Norda.
3. Performance Thresholds: Visual indicators defining "Good" (e.g., INP ≤ 200ms), "Needs Improvement," and "Poor" (e.g., LCP > 4.0s) to instantly flag underperformance.

This visualization layer allowed me to instantly identify that while HOKA’s Visual Stability (CLS) was relatively strong (81.9% Good), the user experience was collapsing during Interactivity (INP).

**5. The Analysis: HOKA’s Competitive Positioning** 

The SQL analysis revealed a stark hierarchy among the 29 analyzed brands. While niche competitors like Norda achieve a UX Score of 97.44%, HOKA significantly underperforms.

**The Dashboard:** Competitive Index Ranking
- Rank: HOKA places 23rd out of 29 brands.
- UX Score: A composite score of 75.19%, well below the industry leaders.
- The Bottleneck: Mobile Interactivity (INP)

The granular data extraction highlighted that HOKA’s primary failure point is Interaction to Next Paint (INP) on mobile devices.

- INP Performance: 48.29% of HOKA’s user interactions fall into "Needs Improvement" or "Poor".
- LCP Performance: 26.54% of page loads are slower than the optimal 2.5 seconds.

This data confirms my initial anecdotal experience: nearly half the time a user attempts to filter a shoe size or tap a menu on HOKA's mobile site, they experience a perceptible delay (over 200ms). In contrast, competitors like On Running and Brooks deliver significantly more responsive experiences.

**6. Business Implications**

This engineering analysis exposes a critical risk to HOKA's growth strategy:
- Search Ranking Risk: Google uses Core Web Vitals (LCP, INP, CLS) as ranking signals. Ranking 23rd places HOKA at a disadvantage in organic search visibility compared to faster competitors.
- Conversion Friction: High INP correlates with user frustration. In an industry where consumers are increasingly shifting toward "challenger brands," a sluggish mobile interface can drive users back to legacy giants or faster agile competitors.

**7. Conclusion & Code Repository**
This project demonstrates how SQL-based engineering can transform raw web vital logs into strategic business intelligence. By normalizing field data, we moved beyond simple averages to uncover specific architectural weaknesses in HOKA's mobile delivery.
Recommendations:

- Engineering: Audit third-party JavaScript execution to resolve the high INP scores.
- Monitoring: Implement the provided SQL script into a scheduled BigQuery job to track performance trends month-over-month.

--------------------------------------------------------------------------------
1. Unbounce. (n.d.). Think Fast, The Page Speed Report. Stats & Trends for Marketers. Retrieved from Unbounce: https://unbounce.com/page-speed-report/ ↩︎
2. Thiel, A., Becker, S., Coggins, B., Falardeau, E., D’Auria, G., & Brown, P. (2025, March 4). Sporting Goods 2025—The new balancing act: Turning uncertainty into opportunity. Retrieved from McKinsey & Company: https://www.mckinsey.com/industries/retail/our-insights/sporting-goods-industry-trends  ↩︎
3. Google. (2024, February 8). Overview of CrUX. Retrieved from developer.chrome.com: https://developer.chrome.com/docs/crux ↩︎
4. Pollard, B. (2022, August 15). Why is CrUX data different from my RUM data? Retrieved from web.dev: https://web.dev/articles/crux-and-rum-differences?hl=en#lab_data_versus_field_data ↩︎
5. Walton, P. (2020, May 4). Web Vitals. Retrieved from web.dev: https://web.dev/articles/vitals#core-web-vitals ↩︎
6. Walton, P., & Barry, P. (2019, August 8). Largest Contentful Paint (LCP). Retrieved from web.dev: https://web.dev/articles/lcp ↩︎
7. Jeremy, W., & Barry, P. (2022, May 6). Interaction to Next Paint (INP). Retrieved from web.dev: https://web.dev/articles/inp ↩︎
8. Milica, M., & Barry, P. (2023, April 12). Cumulative Layout Shift (CLS). Retrieved from web.dev: https://web.dev/articles/cls ↩︎
