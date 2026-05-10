
# Surgical mobile + CDN + Nokken CSS/JS fixes
$file = 'c:\Users\berge\OneDrive\Skrivebord\Claude code\github-pages-deploy\pride-park-spill-2026.html'
$enc  = [System.Text.Encoding]::UTF8
$raw  = [System.IO.File]::ReadAllText($file, $enc)
$text = $raw.Replace("`r`n", "`n")

function Replace-Once($src, $old, $new) {
    $idx = $src.IndexOf($old)
    if ($idx -lt 0) { Write-Host "  MISS: [$($old.Substring(0,[Math]::Min(80,$old.Length)))]"; exit 1 }
    Write-Host "  HIT at $idx"
    $src.Substring(0,$idx) + $new + $src.Substring($idx + $old.Length)
}
function FromHere($s) { $s.Replace("`r`n","`n").Trim("`n") }

# ═══════════════════════════════════════════════════════════════
# CHANGE 1 — CSS block before </style>
# ═══════════════════════════════════════════════════════════════
Write-Host "Step 1: CSS block"
$cssNew = @'

/* ═══ SURGICAL MOBILE + CDN + NØKKEN FIXES (auto-added) ════════════════ */

/* 1. --app-h variable + safe-area props */
:root {
  --app-h: 100dvh;
  --safe-top: env(safe-area-inset-top, 0px);
  --safe-right: env(safe-area-inset-right, 0px);
  --safe-bottom: env(safe-area-inset-bottom, 0px);
  --safe-left: env(safe-area-inset-left, 0px);
}

/* 2. Prevent media from causing horizontal overflow */
img, video, iframe, svg {
  max-width: 100%;
}

/* 3. All creature reveal scenes: hard overflow clip */
.creature-reveal-scene {
  overflow: hidden;
}

/* 4. Nøkken in creature-reveal-scene: landscape image containment */
.creature-reveal-scene[data-creature="nokken"] .creature-reveal-media img {
  width: min(52%, 250px) !important;
  max-height: 75% !important;
  object-fit: contain !important;
  object-position: center center !important;
}

/* 5. Nøkken grid card: ensure card doesn't grow, image fills its box */
.mythic-pow-card[data-being="nokken"] {
  overflow: hidden !important;
}
.mythic-pow-card[data-being="nokken"] img {
  object-fit: cover !important;
  object-position: center 30% !important;
}

/* 6. Creature passage stages: contain on all screens */
.creature-image-stage,
.creature-image-frame {
  overflow: hidden;
  max-width: 100%;
}

/* 7. Tabs: ensure horizontal scroll, no wrap, no overflow */
.c-tabs {
  display: flex !important;
  flex-wrap: nowrap !important;
  overflow-x: auto !important;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  max-width: 100%;
}
.c-tabs::-webkit-scrollbar { display: none; }
.c-tabs .c-tab {
  flex: 0 0 auto;
  white-space: nowrap;
}

/* 8. CDN stage: clip the sigil rings inside the frame */
.cdn-stage .creature-image-frame {
  overflow: hidden;
}

/* 9. CDN passage: no horizontal overflow at any level */
.cdn-passage,
.cdn-passage > *,
.cdn-top-rail,
.cdn-module,
.cdn-hero-node,
.cdn-feature-grid,
.cdn-learning-game,
.cdn-feature-card {
  max-width: 100%;
  overflow-x: hidden;
}

/* 10. CDN passage: ensure links/buttons don't cause overflow */
.cdn-passage a,
.cdn-passage button,
.cdn-cta {
  word-break: break-word;
  overflow-wrap: break-word;
}

/* 11. CDN + general: body/scroll overflow catch */
#scroll {
  overflow-x: hidden;
}

/* 12. Mobile-specific overrides */
@media (max-width: 700px) {
  /* CDN sigil rings: contain within the frame */
  .cdn-sigil {
    width: min(100%, 340px) !important;
    height: 240px !important;
    overflow: hidden;
  }
  .cdn-sigil::before {
    width: min(74vw, 250px) !important;
  }
  .cdn-sigil::after {
    width: min(58vw, 192px) !important;
  }
  /* CDN sigil words: reduce distance so they stay inside overflow:hidden */
  .cdn-sigil-word {
    --dist: 88px !important;
    font-size: 6px !important;
    letter-spacing: 0.06em !important;
  }
  /* CDN stage frame height */
  .cdn-stage .creature-image-frame {
    min-height: 240px !important;
  }
  /* CDN top rail: wrap on very narrow screens */
  .cdn-top-rail {
    flex-wrap: wrap;
    gap: 8px;
  }
  .cdn-top-rail .choice,
  .cdn-top-rail .cdn-spotify-link {
    min-width: 0;
    flex-shrink: 1;
    max-width: calc(100% - 8px);
  }
  /* CDN hero title: scale down */
  .cdn-hero-node h2 {
    font-size: clamp(1.3rem, 7vw, 2rem);
    overflow-wrap: break-word;
    word-break: break-word;
  }
  /* CDN feature grid: single column */
  .cdn-feature-grid {
    grid-template-columns: 1fr !important;
  }
  /* Creature image frame on mobile */
  .creature-image-frame img {
    max-width: min(100%, 300px) !important;
    max-height: 340px !important;
  }
  /* p-body: no horizontal overflow */
  .p-body {
    max-width: 100%;
    overflow-x: hidden;
    word-break: break-word;
    overflow-wrap: break-word;
  }
  /* choices: no overflow */
  .choices {
    max-width: 100%;
    overflow-x: hidden;
  }
  .choice {
    max-width: 100%;
    overflow-wrap: break-word;
    word-break: break-word;
  }
}

/* 13. iOS Safari: reinforce scroll container height with safe areas */
@supports (-webkit-touch-callout: none) {
  #scroll {
    max-height: calc(100svh - 40px);
  }
  body[data-passage]:not([data-passage="start"]) #scroll {
    max-height: calc(100svh - 150px - env(safe-area-inset-bottom, 0px));
  }
}

/* ═══ END SURGICAL FIXES ════════════════════════════════════════════════ */
</style>
'@
$cssNew = FromHere $cssNew
$text = Replace-Once $text "</style>" $cssNew
Write-Host "OK: CSS block"

# ═══════════════════════════════════════════════════════════════
# CHANGE 2 — JS: setAppH() to set --app-h variable
# ═══════════════════════════════════════════════════════════════
Write-Host "Step 2: setAppH JS"
$old2 = @'
  function setH(){document.documentElement.style.setProperty('--app-height',window.innerHeight+'px');}
  setH();
  window.addEventListener('resize',setH);
  window.addEventListener('orientationchange',function(){setTimeout(setH,250);});
'@
$old2 = FromHere $old2

$new2 = @'
  function setH(){
    var h=window.innerHeight+'px';
    document.documentElement.style.setProperty('--app-height',h);
    document.documentElement.style.setProperty('--app-h',h);
  }
  setH();
  setTimeout(setH,300);
  window.addEventListener('resize',setH);
  window.addEventListener('orientationchange',function(){setTimeout(setH,260);});
  window.addEventListener('pageshow',setH);
'@
$new2 = FromHere $new2

$text = Replace-Once $text $old2 $new2
Write-Host "OK: setAppH JS"

# ═══════════════════════════════════════════════════════════════
# Save
# ═══════════════════════════════════════════════════════════════
$text = $text.Replace("`r`n","`n").Replace("`n","`r`n")
[System.IO.File]::WriteAllText($file, $text, $enc)
Write-Host "Saved. Chars: $($text.Length)"
