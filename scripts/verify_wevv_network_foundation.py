#!/usr/bin/env python3
"""Compile and run URLProtocol contract fixtures against the actual native transport. Offline."""
from wevv_swift_source import STRING_HELPER, SUPPORT_SOURCES
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='wevv-network-check-') as folder:
    root = Path(folder)
    binary = root / 'verify'
    subprocess.run(['xcrun', 'swiftc', str(STRING_HELPER), '-swift-version', '5', '-module-cache-path', str(root / 'cache'),
                    '-parse-as-library', str(SUPPORT_SOURCES / 'NertyuChoiceStackLayer.swift'),
                    str(ROOT / 'scripts/WevVGlazeNetworkVerification.swift'), '-o', str(binary)], check=True)
    subprocess.run([str(binary)], check=True)
