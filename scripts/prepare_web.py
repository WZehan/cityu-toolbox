"""Fingerprint the Web entry scripts so returning browsers load each release."""
import hashlib
from pathlib import Path

web = Path(__file__).resolve().parent.parent / 'build' / 'web'
main = (web / 'main.dart.js').read_bytes()
main_name = f'main.{hashlib.sha256(main).hexdigest()[:16]}.dart.js'
(web / main_name).write_bytes(main)
bootstrap = (web / 'flutter_bootstrap.js').read_text().replace('"main.dart.js"', f'"{main_name}"')
bootstrap_name = f'flutter_bootstrap.{hashlib.sha256(bootstrap.encode()).hexdigest()[:16]}.js'
(web / bootstrap_name).write_text(bootstrap)
index = (web / 'index.html').read_text().replace('src="flutter_bootstrap.js"', f'src="{bootstrap_name}"')
(web / 'index.html').write_text(index)
print('Prepared versioned Web entry scripts')
