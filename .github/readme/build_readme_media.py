"""Builds the README artwork (hero banner, section headers, feature cards) in the merathilisui.com style.

Usage: python .github/readme/build_readme_media.py [path-to-website-repo]
Needs Pillow. Fonts and screenshots are taken from the website repo (default E:/GIT/merathilisui-website).
Output goes to .github/media/readme/.
"""

import os
import sys

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
SITE = sys.argv[1] if len(sys.argv) > 1 else "E:/GIT/merathilisui-website"
OUT = os.path.join(REPO, ".github", "media", "readme")

FONT_DIR = os.path.join(SITE, "node_modules", "@fontsource", "rajdhani", "files")
SITE_MEDIA = os.path.join(SITE, "public", "media")

# Site design tokens (src/styles/global.css)
BG0 = (14, 13, 12)
PANEL = (23, 21, 20)
PANEL2 = (29, 27, 25)
PANEL3 = (37, 34, 31)
INK = (244, 242, 240)
INK_DIM = (205, 200, 195)
MUTED = (149, 141, 134)
GRAD = [(255, 154, 31), (242, 106, 18), (217, 58, 10)]
GRAD_TEXT = [(255, 179, 92), (255, 127, 26), (229, 71, 13)]

S = 2  # supersampling factor, everything is drawn at 2x and scaled down


def display(size, weight=700):
	return ImageFont.truetype(os.path.join(FONT_DIR, f"rajdhani-latin-{weight}-normal.woff"), size * S)


def body(size, bold=False):
	return ImageFont.truetype("C:/Windows/Fonts/" + ("segoeuib.ttf" if bold else "segoeui.ttf"), size * S)


def lerp(a, b, t):
	return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def gradient(w, h, stops, horizontal=False):
	n = w if horizontal else h
	line = Image.new("RGB", (n, 1) if horizontal else (1, n))
	for i in range(n):
		t = i / max(n - 1, 1) * (len(stops) - 1)
		k = min(int(t), len(stops) - 2)
		line.putpixel((i, 0) if horizontal else (0, i), lerp(stops[k], stops[k + 1], t - k))
	return line.resize((w, h), Image.NEAREST)


def panel_bg(w, h, top=PANEL2, bottom=PANEL):
	"""Panel gradient plus the diagonal stripe overlay MerathilisUI puts on its backdrops."""
	img = gradient(w, h, [top, bottom])
	stripes = Image.new("L", (w, h), 0)
	d = ImageDraw.Draw(stripes)
	step, thick = 7 * S, 2 * S
	for x in range(-h, w + h, step):
		d.line([(x, h), (x + h, 0)], fill=255, width=thick)
	white = Image.new("RGB", (w, h), (255, 255, 255))
	return Image.composite(white, img, stripes.point(lambda v: int(v * 0.018)))


def glow(img, center, radius, color, strength):
	w, h = img.size
	mask = Image.new("L", (w, h), 0)
	d = ImageDraw.Draw(mask)
	cx, cy = center
	d.ellipse([cx - radius, cy - radius * 0.7, cx + radius, cy + radius * 0.7], fill=int(255 * strength))
	mask = mask.filter(ImageFilter.GaussianBlur(radius * 0.45))
	return Image.composite(Image.new("RGB", (w, h), color), img, mask)


def frame(img):
	"""1px black ElvUI pixel border with a faint inner highlight."""
	d = ImageDraw.Draw(img)
	w, h = img.size
	d.rectangle([0, 0, w - 1, h - 1], outline=(0, 0, 0), width=S)
	d.rectangle([S, S, w - 1 - S, h - 1 - S], outline=(44, 42, 40), width=S)
	return img


def gradient_text(img, xy, text, font, stops=GRAD_TEXT, anchor="ls"):
	mask = Image.new("L", img.size, 0)
	ImageDraw.Draw(mask).text(xy, text, font=font, fill=255, anchor=anchor)
	box = mask.getbbox()
	if not box:
		return
	fill = Image.new("RGB", img.size)
	fill.paste(gradient(box[2] - box[0], box[3] - box[1], stops, horizontal=True), box[:2])
	img.paste(fill, (0, 0), mask)


def accent_bar(img, x, y, w, h):
	img.paste(gradient(w, h, GRAD), (x, y))


def save(img, name, fmt="PNG"):
	out = img.resize((img.width // S, img.height // S), Image.LANCZOS)
	path = os.path.join(OUT, name)
	if fmt == "WEBP":
		out.save(path, "WEBP", quality=88, method=6)
	else:
		out.save(path, optimize=True)
	print("wrote", os.path.relpath(path, REPO), out.size)


# ---------------------------------------------------------------------------------------------------------------------


def hero():
	W, H = 1280 * S, 420 * S
	img = panel_bg(W, H, top=(20, 18, 17), bottom=BG0)
	img = glow(img, (300 * S, 210 * S), 330 * S, (90, 34, 8), 0.75)
	img = glow(img, (300 * S, 210 * S), 170 * S, (150, 58, 12), 0.35)

	logo = Image.open(os.path.join(SITE_MEDIA, "logo.png")).convert("RGBA")
	size = 300 * S
	logo = logo.resize((size, size), Image.LANCZOS)
	shadow = Image.new("RGBA", logo.size, (255, 110, 20, 0))
	shadow.putalpha(logo.getchannel("A").point(lambda a: int(a * 0.55)))
	shadow = shadow.filter(ImageFilter.GaussianBlur(14 * S))
	lx, ly = 150 * S, 60 * S
	img.paste(shadow, (lx, ly), shadow)
	img.paste(logo, (lx, ly), logo)

	x = 520 * S
	d = ImageDraw.Draw(img)
	d.text((x, 118 * S), "ELVUI PLUGIN FOR WORLD OF WARCRAFT", font=display(20, 600), fill=MUTED, anchor="ls")
	gradient_text(img, (x - 4 * S, 212 * S), "MerathilisUI", display(104, 700))
	d.text(
		(x, 258 * S), "A complete, polished look for ElvUI.", font=body(24, True), fill=INK, anchor="ls"
	)
	d.text((x, 292 * S), "Plus everything it doesn't ship.", font=body(24), fill=INK_DIM, anchor="ls")

	# platform chips
	cx = x
	for label in ("RETAIL", "WOW FOREVER"):
		f = display(18, 700)
		tw = d.textlength(label, font=f)
		pw, ph = int(tw + 30 * S), 34 * S
		cy = 330 * S
		d.rectangle([cx, cy, cx + pw, cy + ph], fill=PANEL3, outline=(0, 0, 0), width=S)
		accent_bar(img, cx + S, cy + S, 3 * S, ph - S)
		d.text((cx + 17 * S, cy + ph // 2 + S), label, font=f, fill=INK, anchor="lm")
		cx += pw + 10 * S

	accent_bar(img, 0, H - 4 * S, W, 4 * S)
	save(frame(img), "hero.png")


def header(slug, title, subtitle):
	W, H = 1280 * S, 96 * S
	img = panel_bg(W, H)
	img = glow(img, (60 * S, H // 2), 260 * S, (70, 28, 8), 0.55)
	accent_bar(img, 0, 0, 6 * S, H)
	d = ImageDraw.Draw(img)
	gradient_text(img, (36 * S, 54 * S), title.upper(), display(40, 700))
	tw = d.textlength(title.upper(), font=display(40, 700))
	d.text((36 * S + tw + 22 * S, 52 * S), subtitle, font=body(18), fill=MUTED, anchor="ls")
	# thin rule to the right edge
	ImageDraw.Draw(img).line([(36 * S, H - 18 * S), (W - 36 * S, H - 18 * S)], fill=(40, 37, 34), width=S)
	accent_bar(img, 36 * S, H - 18 * S - S // 2, 80 * S, 2 * S)
	save(frame(img), f"header-{slug}.png")


def card(slug, src, title, subtitle, tag=None):
	W, H = 800 * S, 500 * S
	bar = 92 * S
	img = panel_bg(W, H)
	area_h = H - bar
	img = glow(img, (W // 2, area_h // 2), 340 * S, (52, 22, 8), 0.6)

	shot = Image.open(os.path.join(SITE_MEDIA, src)).convert("RGBA")
	pad = 28 * S
	maxw, maxh = W - 2 * pad, area_h - 2 * pad
	scale = min(maxw / shot.width, maxh / shot.height, 1.6 * S)
	shot = shot.resize((int(shot.width * scale), int(shot.height * scale)), Image.LANCZOS)
	sx, sy = (W - shot.width) // 2, (area_h - shot.height) // 2
	sh = Image.new("RGBA", (shot.width + 40 * S, shot.height + 40 * S), (0, 0, 0, 0))
	ImageDraw.Draw(sh).rectangle([20 * S, 20 * S, 20 * S + shot.width, 20 * S + shot.height], fill=(0, 0, 0, 200))
	sh = sh.filter(ImageFilter.GaussianBlur(10 * S))
	img.paste(sh, (sx - 20 * S, sy - 20 * S), sh)
	img.paste(shot, (sx, sy), shot)
	ImageDraw.Draw(img).rectangle([sx - S, sy - S, sx + shot.width, sy + shot.height], outline=(0, 0, 0), width=S)

	# caption bar
	d = ImageDraw.Draw(img)
	d.rectangle([0, area_h, W, H], fill=PANEL3)
	d.line([(0, area_h), (W, area_h)], fill=(0, 0, 0), width=S)
	accent_bar(img, 0, area_h + S, 5 * S, bar - S)
	d.text((28 * S, area_h + 44 * S), title.upper(), font=display(32, 700), fill=INK, anchor="ls")
	if tag:
		tw = d.textlength(title.upper(), font=display(32, 700))
		f = display(15, 700)
		px = 28 * S + tw + 14 * S
		pw = d.textlength(tag, font=f) + 16 * S
		py = area_h + 22 * S
		img.paste(gradient(int(pw), 22 * S, GRAD), (int(px), py))
		d.text((px + 8 * S, py + 11 * S + S), tag, font=f, fill=(20, 12, 6), anchor="lm")
	d.text((28 * S, area_h + 74 * S), subtitle, font=body(17), fill=INK_DIM, anchor="ls")
	save(frame(img), f"feature-{slug}.webp", "WEBP")


def main():
	os.makedirs(OUT, exist_ok=True)
	hero()

	header("features", "Features", "More than a skin")
	header("presets", "Make it your own", "Layouts and presets")
	header("installation", "Installation", "Up and running in three steps")
	header("requirements", "Requirements", "What you need next to MerathilisUI")
	header("addons", "Supported AddOns", "Profiles and skins included")
	header("support", "Community & Support", "Bugs, ideas and help")
	header("credits", "Credits", "Standing on the shoulders of giants")

	card("armory", "features/armory.webp", "Armory", "Character and inspect frame with enchants, gems and stats")
	card("bags", "features/bags.webp", "Categorized Bags", "Category sidebar, pinned and recent items, stack merge")
	card("addon-manager", "features/addon-manager.webp", "AddOn Manager", "Addon profiles, per-instance switching, faulty addon finder", "NEW")
	card("loadout-manager", "features/loadout-manager.webp", "Loadout Manager", "Gear set and talents swap per instance and difficulty", "NEW")
	card("portraits", "features/portraits.webp", "Unit Portraits", "Portraits with class and reaction rings", "NEW")
	card("hovercast", "features/hovercast.webp", "HoverCast", "Click-casting on any unit frame")
	card("unlock-mode", "features/unlock-mode.webp", "Unlock Mode", "Snap, guides, arrow nudge and revert for movers")
	card("chat", "features/chat.webp", "Chat Sidebar", "Friends, guild, durability and more next to your chat")
	card("minimap", "features/minimap.webp", "Minimap", "Location panel, coordinates and a button collector")
	card("notifications", "features/notifications.webp", "Notifications", "Rares, mail, Great Vault and more as toasts")
	card("game-menu", "features/game-menu.webp", "Game Menu", "Styled game menu, AFK screen and cursor ring")
	card("quick-grid", "features/quick-grid.webp", "Quick Grid", "Hold-to-open 3x3 action grid")

	for p, t, s in (
		("gradient", "Gradient", "Class-colored gradients"),
		("dark", "Dark", "Dark bars, colored text"),
		("minimal", "Minimal", "Less chrome, more world"),
		("healer", "Healer", "Raid frames front and center"),
	):
		card("preset-" + p, "presets/" + p + ".webp", t, s)


if __name__ == "__main__":
	main()
