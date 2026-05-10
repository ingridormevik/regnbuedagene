
# DEL 2-4: kilder passage, CSS, KILDER routing buttons
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

# ─── 1. CSS before </style> ─────────────────────────────────────────────────
Write-Host "Step 1: CSS"
$cssOld = @'
</style>
'@
$cssOld = FromHere $cssOld

$cssNew = @'

/* -- creature-lede ---------------------------------------- */
.creature-lede {
  font-style: italic;
  font-size: 0.95em;
  color: rgba(255,255,255,0.82);
  border-left: 3px solid var(--pride-p, #b86bff);
  padding: 10px 14px;
  margin: 0 0 18px 0;
  background: rgba(255,255,255,0.04);
  border-radius: 0 10px 10px 0;
  line-height: 1.6;
}
.creature-lede em {
  font-style: normal;
  opacity: 0.7;
  font-size: 0.88em;
}
/* -- kilder page ------------------------------------------ */
.kilder-intro {
  font-style: italic;
  color: rgba(255,255,255,0.7);
  margin-bottom: 20px;
  line-height: 1.7;
}
.kilder-body { padding-bottom: 32px; }
.kilder-section {
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 12px;
  margin-bottom: 14px;
  overflow: hidden;
}
.kilder-section summary {
  padding: 14px 16px;
  cursor: pointer;
  font-weight: 600;
  font-size: 0.95em;
  background: rgba(255,255,255,0.05);
  list-style: none;
  display: flex;
  justify-content: space-between;
  align-items: center;
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
  user-select: none;
}
.kilder-section summary::-webkit-details-marker { display: none; }
.kilder-section summary::after {
  content: '\25B8';
  font-size: 0.85em;
  opacity: 0.6;
  transition: transform 0.2s;
  flex-shrink: 0;
}
.kilder-section[open] summary::after { transform: rotate(90deg); }
.kilder-list {
  list-style: none;
  padding: 12px 16px 16px;
  margin: 0;
  border-top: 1px solid rgba(255,255,255,0.07);
}
.kilder-list li {
  padding: 8px 0;
  font-size: 0.875em;
  line-height: 1.55;
  border-bottom: 1px solid rgba(255,255,255,0.05);
  color: rgba(255,255,255,0.85);
}
.kilder-list li:last-child { border-bottom: none; }
.kilder-list a {
  color: var(--pride-g, #4fc);
  text-decoration: underline;
}
.kilder-footer {
  margin-top: 24px;
  font-size: 0.82em;
  color: rgba(255,255,255,0.45);
  line-height: 1.6;
  text-align: center;
}
</style>
'@
$cssNew = FromHere $cssNew

$text = Replace-Once $text $cssOld $cssNew
Write-Host "OK: CSS"

# ─── 2. KILDER button in alle_funnet ────────────────────────────────────────
Write-Host "Step 2: alle_funnet KILDER button"
$old2 = @'
TILBAKE TIL KARTET / FINN MERCH / INFO</button>
    <button class="choice" data-go="regnbuenatt">
'@
$old2 = FromHere $old2

$new2 = @'
TILBAKE TIL KARTET / FINN MERCH / INFO</button>
    <button class="choice" data-go="kilder"><span class="arr">&#8594;</span>${LANG.current === 'en' ? 'Sources &#38; References' : 'Kilder og referanser'}</button>
    <button class="choice" data-go="regnbuenatt">
'@
$new2 = FromHere $new2

$text = Replace-Once $text $old2 $new2
Write-Host "OK: alle_funnet"

# ─── 3. KILDER button in start ───────────────────────────────────────────────
Write-Host "Step 3: start KILDER button"
$old3 = @'
>${t('start-parade')}</button>
  </div>
`,
'@
$old3 = FromHere $old3

$new3 = @'
>${t('start-parade')}</button>
    <button class="choice" data-go="kilder" style="opacity:0.7;font-size:0.85em;"><span class="arr">&#8594;</span>${LANG.current === 'en' ? 'Sources &#38; References' : 'Kilder og referanser'}</button>
  </div>
`,
'@
$new3 = FromHere $new3

$text = Replace-Once $text $old3 $new3
Write-Host "OK: start"

# ─── 4. kilder passage before }; of PASSAGES ────────────────────────────────
Write-Host "Step 4: kilder passage"
$kilderPassage = @'

// --------------------------------------------------------
'kilder': () => `
  <span class="p-tag">${LANG.current === 'en' ? 'SOURCES' : 'KILDER'} &nbsp;/&nbsp; PRIDE PARK 2026</span>
  <h1 class="p-title">${LANG.current === 'en' ? 'Sources' : 'Kilder'} <span class="creature-col">${LANG.current === 'en' ? '&amp; References' : 'og referanser'}</span></h1>
  <div class="p-body kilder-body">
    <p class="kilder-intro">${LANG.current === 'en'
      ? 'This game is rooted in Norwegian queer history and archival research. The sources below are the backbone of the narratives you have encountered in the forest.'
      : 'Dette spillet er forankret i norsk skeiv historie og arkivforskning. Kildene nedenfor er ryggraden i de fortellingene du har m&#248;tt i skogen.'
    }</p>

    <details class="kilder-section">
      <summary>${LANG.current === 'en' ? 'Primary Archives' : 'Prim&#230;rarkiv'}</summary>
      <ul class="kilder-list">
        <li><strong>Skeivt arkiv, Universitetsbiblioteket i Bergen</strong> &#8212; ${LANG.current === 'en' ? "Norway's national archive for LGBTQ+ history. All archival references in the creature texts point here." : 'Norges nasjonale arkiv for LHBT+-historie. Alle arkivhenvisninger i vesentekstene peker hit.'} <a href="https://skeivtarkiv.no" target="_blank" rel="noopener noreferrer">skeivtarkiv.no</a></li>
        <li><strong>Karen-Christine Friele-arkivet</strong> &#8212; ${LANG.current === 'en' ? "Documents from Norway's most prominent LGBTQ+ rights activist, preserved at Skeivt arkiv." : 'Dokumenter fra Norges fremste skeive rettighetsforkjemper, bevart ved Skeivt arkiv.'}</li>
        <li><strong>DNF-48 / FHO Bergen, 1970&#8211;</strong> &#8212; ${LANG.current === 'en' ? 'The Bergen chapter of the Norwegian Association of 1948, founded by Kenneth Brophy in Byparken, November 1970.' : 'Bergensavdelingen av Det Norske Forbundet av 1948, stiftet av Kenneth Brophy i Byparken, november 1970.'}</li>
      </ul>
    </details>

    <details class="kilder-section">
      <summary>${LANG.current === 'en' ? 'Norwegian Queer History' : 'Norsk skeiv historie'}</summary>
      <ul class="kilder-list">
        <li>Halsos, M. S. (2001). <em>Kj&#230;rlighet og frigj&#248;ring</em>. Bergen: Alma Mater.</li>
        <li>Jord&#229;en, R. (2010). <em>Fr&#229; synd til identitet</em>. PhD-avhandling, Universitetet i Bergen.</li>
        <li>Kristiansen, H. W. (2008). <em>Masker og motstand</em>. Oslo: Unipax.</li>
        <li>Skeivopedia &#8212; <a href="https://skeivopedia.no" target="_blank" rel="noopener noreferrer">skeivopedia.no</a></li>
      </ul>
    </details>

    <details class="kilder-section">
      <summary>${LANG.current === 'en' ? 'Theoretical Framework' : 'Teoretisk rammeverk'}</summary>
      <ul class="kilder-list">
        <li>Ahmed, S. (2006). <em>Queer Phenomenology</em>. Durham: Duke University Press.</li>
        <li>Mu&#241;oz, J. E. (1999). <em>Disidentifications</em>. Minneapolis: University of Minnesota Press.</li>
        <li>Mu&#241;oz, J. E. (2009). <em>Cruising Utopia</em>. New York: NYU Press.</li>
        <li>Butler, J. (1990). <em>Gender Trouble</em>. New York: Routledge.</li>
      </ul>
    </details>

    <details class="kilder-section">
      <summary>${LANG.current === 'en' ? 'Game Design &amp; Digital Narrative' : 'Spillteori og digital fortelling'}</summary>
      <ul class="kilder-list">
        <li>Murray, J. (1997). <em>Hamlet on the Holodeck</em>. Cambridge: MIT Press.</li>
        <li>Flanagan, M. (2009). <em>Critical Play</em>. Cambridge: MIT Press.</li>
        <li>Ruberg, B. (2019). <em>Video Games Have Always Been Queer</em>. New York: NYU Press.</li>
      </ul>
    </details>

    <details class="kilder-section">
      <summary>${LANG.current === 'en' ? 'Acknowledgements' : 'Takk til'}</summary>
      <ul class="kilder-list">
        <li>${LANG.current === 'en' ? 'Bergen Pride &#8212; for the space and the collaboration.' : 'Bergen Pride &#8212; for rommet og samarbeidet.'}</li>
        <li>${LANG.current === 'en' ? 'Skeivt arkiv, UiB &#8212; for access to the archive and invaluable guidance.' : 'Skeivt arkiv, UiB &#8212; for tilgang til arkivet og uvurderlig veiledning.'}</li>
        <li>${LANG.current === 'en' ? 'All the beings who kept their stories alive.' : 'Alle vesene som holdt historiene sine i live.'}</li>
      </ul>
    </details>

    <p class="kilder-footer">${LANG.current === 'en'
      ? 'Pride Park 2026 was created as part of the course DIKULT216 at the University of Bergen. All historical references are based on documented sources. Creative interpretation has been used where the archival record is silent.'
      : 'Pride Park 2026 ble laget som del av kurset DIKULT216 ved Universitetet i Bergen. Alle historiske henvisninger er basert p&#229; dokumenterte kilder. Kreativ tolkning er brukt der arkivmaterialet er taust.'
    }</p>
  </div>
  <div class="choices">
    <button class="choice back" data-go="start"><span class="arr">&#8592;</span>${LANG.current === 'en' ? 'Back to start' : 'Tilbake til start'}</button>
  </div>
`,
'@

$kilderPassage = $kilderPassage.Replace("`r`n","`n")

$old4 = "``," + "`n" + "};" + "`n" + "`n" + "// ============================================================" + "`n" + "// TAB CONTENT"
$new4 = "``," + "`n" + $kilderPassage + "`n" + "};" + "`n" + "`n" + "// ============================================================" + "`n" + "// TAB CONTENT"
$text = Replace-Once $text $old4 $new4
Write-Host "OK: kilder passage"

# ─── Save ────────────────────────────────────────────────────────────────────
$text = $text.Replace("`r`n","`n").Replace("`n","`r`n")
[System.IO.File]::WriteAllText($file, $text, $enc)
Write-Host "Saved. Chars: $($text.Length)"
