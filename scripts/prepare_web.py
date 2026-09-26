"""Fingerprint Web entry scripts and icon fonts so returning browsers load each release.

Cloudflare may serve static assets with a long browser cache TTL, so any file
whose content changes between releases must also change its URL.
"""
import hashlib
import json
import re
from pathlib import Path, PurePosixPath

web = Path(__file__).resolve().parent.parent / 'build' / 'web'


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()[:16]


# Icon fonts are tree-shaken per build, so their content changes with the code.
manifest_path = web / 'assets' / 'FontManifest.json'
manifest = json.loads(manifest_path.read_text())
for family in manifest:
    for font in family['fonts']:
        asset = PurePosixPath(font['asset'])
        if re.search(r'\.[0-9a-f]{16}$', asset.stem):
            continue  # already fingerprinted
        data = (web / 'assets' / asset).read_bytes()
        hashed = asset.with_name(f'{asset.stem}.{digest(data)}{asset.suffix}')
        (web / 'assets' / hashed).write_bytes(data)
        font['asset'] = str(hashed)
manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, separators=(',', ':')))

main = (web / 'main.dart.js').read_bytes()
main_name = f'main.{digest(main)}.dart.js'
(web / main_name).write_bytes(main)
bootstrap = (web / 'flutter_bootstrap.js').read_text().replace('"main.dart.js"', f'"{main_name}"')
bootstrap_name = f'flutter_bootstrap.{digest(bootstrap.encode())}.js'
(web / bootstrap_name).write_text(bootstrap)
index = (web / 'index.html').read_text().replace('src="flutter_bootstrap.js"', f'src="{bootstrap_name}"')
(web / 'index.html').write_text(index)
print('Prepared versioned Web entry scripts and icon fonts')
