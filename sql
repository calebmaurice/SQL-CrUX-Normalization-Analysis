CREATE OR REPLACE TABLE `[INSERT YOUR DESTINATION]`
  AS
  SELECT
    origin,
    date,
    device,
    -- Grouping by brand name for cleaner analysis.
    CASE
      WHEN REGEXP_CONTAINS(origin, r'tenthousand') THEN 'Ten Thousand'
      WHEN REGEXP_CONTAINS(origin, r'satisfyrunning') THEN 'Satisfy Running'
      WHEN REGEXP_CONTAINS(origin, r'peluva') THEN 'Peluva'
      WHEN REGEXP_CONTAINS(origin, r'myrqvist') THEN 'Myrqvist'
      WHEN REGEXP_CONTAINS(origin, r'tracksmith') THEN 'Tracksmith'
      WHEN REGEXP_CONTAINS(origin, r'soarrunning') THEN 'Soar Running'
      WHEN REGEXP_CONTAINS(origin, r'rungum') THEN 'Run Gum'
      WHEN REGEXP_CONTAINS(origin, r'hyloathletics') THEN 'Hylo'
      WHEN REGEXP_CONTAINS(origin, r'janji') THEN 'Janji'
      WHEN REGEXP_CONTAINS(origin, r'on-running') THEN 'On Running'
      WHEN REGEXP_CONTAINS(origin, r'cieleathletics') THEN 'Ciele'
      WHEN REGEXP_CONTAINS(origin, r'torsa') THEN 'Torsa'
      WHEN REGEXP_CONTAINS(origin, r'nike') THEN 'Nike'
      WHEN REGEXP_CONTAINS(origin, r'adidas') THEN 'Adidas'
      WHEN REGEXP_CONTAINS(origin, r'brooksrunning') THEN 'Brooks'
      WHEN REGEXP_CONTAINS(origin, r'asics') THEN 'ASICS'
      WHEN REGEXP_CONTAINS(origin, r'newbalance') THEN 'New Balance'
      WHEN REGEXP_CONTAINS(origin, r'hoka') THEN 'HOKA'
      WHEN REGEXP_CONTAINS(origin, r'saucony') THEN 'Saucony'
      WHEN REGEXP_CONTAINS(origin, r'underarmour') THEN 'Under Armour'
      WHEN REGEXP_CONTAINS(origin, r'puma') THEN 'Puma'
      WHEN REGEXP_CONTAINS(origin, r'lululemon') THEN 'Lululemon'
      WHEN REGEXP_CONTAINS(origin, r'mizuno') THEN 'Mizuno'
      WHEN REGEXP_CONTAINS(origin, r'altrarunning') THEN 'Altra'
      WHEN REGEXP_CONTAINS(origin, r'salomon') THEN 'Salomon'
      WHEN REGEXP_CONTAINS(origin, r'banditrunning') THEN 'Bandit Running'
      WHEN REGEXP_CONTAINS(origin, r'craftsportswear') THEN 'Craft Sportswear'
      WHEN REGEXP_CONTAINS(origin, r'topoathletic') THEN 'Topo Athletic'
      WHEN REGEXP_CONTAINS(origin, r'karhu') THEN 'Karhu'
      WHEN REGEXP_CONTAINS(origin, r'nordarun') THEN 'Norda'
      WHEN REGEXP_CONTAINS(origin, r'saysky') THEN 'SAYSKY'
      WHEN REGEXP_CONTAINS(origin, r'newtonrunning') THEN 'Newton Running'
      WHEN REGEXP_CONTAINS(origin, r'districtvision') THEN 'District Vision'
      ELSE 'Other Competitor'
    END
    AS brand_name,
    desktopDensity,
    phoneDensity,
    tabletDensity,
    -- First Paint (FP)
    fast_fp,
    avg_fp,
    slow_fp,
    p75_fp,
    -- First Contentful Paint (FCP)
    fast_fcp,
    avg_fcp,
    slow_fcp,
    p75_fcp,
    -- Largest Contentful Paint (FCP)
    fast_lcp,
    avg_lcp,
    slow_lcp,
    p75_lcp,
    -- Time to First Byte (TTFB)
    fast_ttfb,
    avg_ttfb,
    slow_ttfb,
    p75_ttfb,
    -- DOMContentLoaded (DCL)
    fast_dcl,
    avg_dcl,
    slow_dcl,
    p75_dcl,
    -- Onload
    fast_ol,
    avg_ol,
    slow_ol,
    p75_ol,
    -- First Input Delay (FID)
    fast_fid,
    avg_fid,
    slow_fid,
    p75_fid,
    -- Interaction to Next Paint (INP)
    fast_inp,
    avg_inp,
    slow_inp,
    p75_inp,
    -- Cumulative Layout Shift (CLS)
    small_cls,
    medium_cls,
    large_cls,
    p75_cls,
  FROM
    `chrome-ux-report.materialized.device_summary`
  WHERE
    date BETWEEN "2023-01-01" AND "2025-12-31"
    AND REGEXP_CONTAINS(origin, r'^https://(www\.)?(?:tenthousand\.cc|satisfyrunning\.com|peluva\.com|myrqvist\.com|tracksmith\.com|soarrunning\.com|rungum\.com|hyloathletics\.com|janji\.com|on-running\.com|cieleathletics\.com|torsa\.co\.uk|nike\.com|adidas\.com|brooksrunning\.com|asics\.com|newbalance\.com|hoka\.com|saucony\.com|underarmour\.com|puma\.com|lululemon\.com|mizuno\.com|altrarunning\.com|salomon\.com|banditrunning\.com|craftsportswear\.com|topoathletic\.com|karhu\.com|nordarun\.com|saysky\.dk|newtonrunning\.com|districtvision\.com)$')
  ORDER BY
    date DESC
  LIMIT
    1000;

  

CREATE OR REPLACE TABLE `[INSERT YOUR DESTINATION]`
AS
SELECT
  origin,
  date,
  device,
  brand_name,
  -- Normalization Logic: (Metric Count / Device Density) = Normalized Proportion
  -- Normalizing proportions using SAFE_DIVIDE to prevent division-by-zero errors
  -- First Paint (FP)
  SAFE_DIVIDE(
    fast_fp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_fp,
  SAFE_DIVIDE(
    avg_fp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_fp,
  SAFE_DIVIDE(
    slow_fp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_fp,
  p75_fp,

  -- First Contentful Paint (FCP)
  SAFE_DIVIDE(
    fast_fcp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_fcp,
  SAFE_DIVIDE(
    avg_fcp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_fcp,
  SAFE_DIVIDE(
    slow_fcp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_fcp,
  p75_fcp,
  
  -- Largest Contentful Paint (FCP)
  SAFE_DIVIDE(
    fast_lcp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_lcp,
  SAFE_DIVIDE(
    avg_lcp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_lcp,
  SAFE_DIVIDE(
    slow_lcp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_lcp,
  p75_lcp,

  -- Time to First Byte (TTFB)
  SAFE_DIVIDE(
    fast_ttfb,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_ttfb,
  SAFE_DIVIDE(
    avg_ttfb,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_ttfb,
  SAFE_DIVIDE(
    slow_ttfb,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_ttfb,
  p75_ttfb,

  -- DOM Content Loaded (DCL)
  SAFE_DIVIDE(
    fast_dcl,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_dcl,
  SAFE_DIVIDE(
    avg_dcl,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_dcl,
  SAFE_DIVIDE(
    slow_dcl,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_dcl,
  p75_dcl,

  -- Onload (OL)
  SAFE_DIVIDE(
    fast_ol,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_ol,
  SAFE_DIVIDE(
    avg_ol,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_ol,
  SAFE_DIVIDE(
    slow_ol,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_ol,
  -- p75_ol is not explicitly selected here, but it's in the source table and should be included if desired.
  -- Assuming it should be included like other p75 metrics.
  p75_ol,

  -- First Input Delay (FID)
  SAFE_DIVIDE(
    fast_fid,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_fid,
  SAFE_DIVIDE(
    avg_fid,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_fid,
  SAFE_DIVIDE(
    slow_fid,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_fid,
  p75_fid,

  -- Interaction to Next Paint (INP)
  SAFE_DIVIDE(
    fast_inp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS fast_inp,
  SAFE_DIVIDE(
    avg_inp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS avg_inp,
  SAFE_DIVIDE(
    slow_inp,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS slow_inp,
  p75_inp,

  -- Cumulative Layout Shift (CLS)
  SAFE_DIVIDE(
    small_cls,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS small_cls,
  SAFE_DIVIDE(
    medium_cls,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS medium_cls,
  SAFE_DIVIDE(
    large_cls,
    CASE
      WHEN device = 'desktop' THEN desktopDensity
      WHEN device = 'phone' THEN phoneDensity
      ELSE tabletDensity
      END)
    AS large_cls,
  p75_cls,

  -- Densities for reference
  desktopDensity,
  phoneDensity,
  tabletDensity
FROM `[INSERT YOUR DESTINATION]`
WHERE device IN ('desktop', 'phone', 'tablet');
