Add-Type -AssemblyName System.Drawing

# DIN A4 bei 300 DPI
$dpi      = 300
$widthPx  = [int](210 / 25.4 * $dpi)   # 2480
$heightPx = [int](297 / 25.4 * $dpi)   # 3508

$bmp = New-Object System.Drawing.Bitmap($widthPx, $heightPx)
$bmp.SetResolution($dpi, $dpi)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.Clear([System.Drawing.Color]::White)

# Farben (Tailwind medical/slate-Palette aus der Webseite)
$medical900 = [System.Drawing.Color]::FromArgb(19, 78, 74)
$medical700 = [System.Drawing.Color]::FromArgb(15, 118, 110)
$medical600 = [System.Drawing.Color]::FromArgb(13, 148, 136)
$medical500 = [System.Drawing.Color]::FromArgb(20, 184, 166)
$slate800   = [System.Drawing.Color]::FromArgb(30, 41, 59)
$slate600   = [System.Drawing.Color]::FromArgb(71, 85, 105)
$slate400   = [System.Drawing.Color]::FromArgb(148, 163, 184)

$brushDark    = New-Object System.Drawing.SolidBrush($slate800)
$brushMid     = New-Object System.Drawing.SolidBrush($slate600)
$brushLight   = New-Object System.Drawing.SolidBrush($slate400)
$brushAccent  = New-Object System.Drawing.SolidBrush($medical700)
$brushAccent2 = New-Object System.Drawing.SolidBrush($medical600)
$brushWhite   = [System.Drawing.Brushes]::White

# Layout-Maße (300 DPI: 1 cm = ~118 px)
$mLeft  = 240   # 2 cm
$mRight = 240

# ---------------- KOPFZEILE ----------------
$logoSize = 230
$logoX    = $mLeft
$logoY    = 220

# Beispiel-Logo: Kreis in medical-700 mit weißem Äskulapstab-Symbol (stilisiert: Stab + Kreuz)
$g.FillEllipse($brushAccent, $logoX, $logoY, $logoSize, $logoSize)
# innerer dünner Rand
$ringPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 255, 255), 4)
$g.DrawEllipse($ringPen, $logoX + 14, $logoY + 14, $logoSize - 28, $logoSize - 28)

# Stilisiertes Kreuz innen (weiß)
$crossW = 28
$cx = $logoX + [int]($logoSize/2)
$cy = $logoY + [int]($logoSize/2)
$crossArmLen = 65
$g.FillRectangle($brushWhite, $cx - [int]($crossW/2), $cy - $crossArmLen, $crossW, $crossArmLen * 2)
$g.FillRectangle($brushWhite, $cx - $crossArmLen, $cy - [int]($crossW/2), $crossArmLen * 2, $crossW)

# Textblock rechts neben Logo
$titleFont   = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Bold)
$kickerFont  = New-Object System.Drawing.Font("Segoe UI", 9,  [System.Drawing.FontStyle]::Bold)
$subFont     = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$specFont    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)

$tx = $logoX + $logoSize + 50
$ty = $logoY + 12

# Kicker
$g.DrawString("HAUSÄRZTLICHE GEMEINSCHAFTSPRAXIS · KÖLN-LINDENTHAL", $kickerFont, $brushAccent2, $tx, $ty)
# Praxisname
$g.DrawString("Praxis am Stadtpark", $titleFont, $brushDark, $tx, $ty + 38)
# Ärzte-Zeile
$g.DrawString("Dr. med. Julia Sommer  ·  Dr. med. Thomas Weber  ·  Dr. med. Elif Yilmaz", $subFont, $brushMid, $tx, $ty + 168)
# Fachgebiete
$g.DrawString("Allgemeinmedizin  ·  Innere Medizin  ·  Chirotherapie", $specFont, $brushLight, $tx, $ty + 210)

# Trennlinie unter dem Header
$linePen = New-Object System.Drawing.Pen($medical500, 3)
$g.DrawLine($linePen, $mLeft, $logoY + $logoSize + 60, $widthPx - $mRight, $logoY + $logoSize + 60)

# Schmaler Akzent-Strich (kürzer, oberhalb des Hauptstrichs)
$accentPen = New-Object System.Drawing.Pen($medical700, 8)
$g.DrawLine($accentPen, $mLeft, $logoY + $logoSize + 60, $mLeft + 360, $logoY + $logoSize + 60)

# ---------------- ABSENDERZEILE (kleine Zeile über Anschriftenfeld) ----------------
# Standardposition für DIN-5008 Absenderzeile (klein, unterstrichen, oberhalb des Briefkopf-Sichtfensters)
# Praxis am Stadtpark · Aachener Straße 500 · 50933 Köln
$senderFont = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Underline)
$senderY = 580   # ca. 4,9 cm ab Oberkante (DIN-5008-konform oberhalb Anschriftenfeld)
$g.DrawString("Praxis am Stadtpark  ·  Aachener Straße 500  ·  50933 Köln", $senderFont, $brushLight, $mLeft, $senderY)

# ---------------- FUSSZEILE ----------------
# Fußzeile beginnt ca. 3,5 cm vom unteren Rand
$footerTopY  = $heightPx - 470
$footerLineY = $footerTopY - 30

# Trennlinie über Fußzeile
$footerLinePen = New-Object System.Drawing.Pen($medical500, 2)
$g.DrawLine($footerLinePen, $mLeft, $footerLineY, $widthPx - $mRight, $footerLineY)
# Akzent rechts
$g.DrawLine($accentPen, $widthPx - $mRight - 360, $footerLineY, $widthPx - $mRight, $footerLineY)

$footerHdrFont = New-Object System.Drawing.Font("Segoe UI", 9,  [System.Drawing.FontStyle]::Bold)
$footerFont    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$footerStrong  = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$colWidth = [int](($widthPx - $mLeft - $mRight) / 3)

# Spalte 1 — Praxis / Anschrift
$c1 = $mLeft
$g.DrawString("PRAXIS", $footerHdrFont, $brushAccent, $c1, $footerTopY)
$g.DrawString("Praxis am Stadtpark", $footerStrong, $brushDark, $c1, $footerTopY + 36)
$g.DrawString("Aachener Straße 500", $footerFont, $brushMid, $c1, $footerTopY + 70)
$g.DrawString("50933 Köln-Lindenthal", $footerFont, $brushMid, $c1, $footerTopY + 100)

# Sprechzeiten (kompakt unter Adresse)
$g.DrawString("Mo-Fr  08:00 - 12:00 Uhr", $footerFont, $brushLight, $c1, $footerTopY + 150)
$g.DrawString("Mo, Di, Do  15:00 - 18:00 Uhr", $footerFont, $brushLight, $c1, $footerTopY + 180)

# Spalte 2 — Kontakt
$c2 = $mLeft + $colWidth
$g.DrawString("KONTAKT", $footerHdrFont, $brushAccent, $c2, $footerTopY)
$g.DrawString("Telefon  0221 60 60 006", $footerFont, $brushMid, $c2, $footerTopY + 36)
$g.DrawString("Telefax  0221 60 60 007", $footerFont, $brushMid, $c2, $footerTopY + 70)
$g.DrawString("info@praxis-stadtpark-koeln.de", $footerFont, $brushMid, $c2, $footerTopY + 100)
$g.DrawString("www.praxis-stadtpark-koeln.de", $footerFont, $brushMid, $c2, $footerTopY + 130)

# Spalte 3 — Bankverbindung
$c3 = $mLeft + 2 * $colWidth
$g.DrawString("BANKVERBINDUNG", $footerHdrFont, $brushAccent, $c3, $footerTopY)
$g.DrawString("Sparkasse KölnBonn", $footerStrong, $brushDark, $c3, $footerTopY + 36)
$g.DrawString("IBAN  DE89 3705 0198 1234 5678 90", $footerFont, $brushMid, $c3, $footerTopY + 70)
$g.DrawString("BIC    COLSDE33XXX", $footerFont, $brushMid, $c3, $footerTopY + 100)
$g.DrawString("Steuer-Nr.  217/5832/1947", $footerFont, $brushLight, $c3, $footerTopY + 150)
$g.DrawString("USt-IdNr.   DE298471562", $footerFont, $brushLight, $c3, $footerTopY + 180)

# ---------------- SPEICHERN ALS JPG (Qualität 95) ----------------
$encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 95L)

$outPath = Join-Path $PSScriptRoot "Briefpapier_DemoPraxis.jpg"
$bmp.Save($outPath, $encoder, $encoderParams)

$g.Dispose()
$bmp.Dispose()

Write-Output ("Erstellt: " + $outPath)
Write-Output ("Größe   : " + $widthPx + " x " + $heightPx + " px @ " + $dpi + " DPI")
