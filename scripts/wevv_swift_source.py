"""Locate runtime string expressions and compile the shipping string decoder in fixtures."""
from pathlib import Path
import re

APP_SOURCES = Path(__file__).resolve().parents[1] / 'WevSweetgd/WevSweetgd'
STRING_HELPER, = APP_SOURCES.rglob('wevVGlazeCrumbRibbonFolded.swift')
SUPPORT_SOURCES = STRING_HELPER.parent
STRING_PATTERN = r'"(?:[^"\\]|\\.)*"'


def literal_value(source):
    if not source.startswith('"') or not source.endswith('"'):
        raise ValueError('Expected a Swift string literal')
    text, result, cursor = source[1:-1], [], 0
    escapes = {'0': '\0', 'n': '\n', 'r': '\r', 't': '\t', '\\': '\\', '"': '"', "'": "'"}
    while cursor < len(text):
        character = text[cursor]
        cursor += 1
        if character != '\\':
            result.append(character)
            continue
        if cursor >= len(text):
            raise ValueError('Truncated Swift escape')
        character = text[cursor]
        cursor += 1
        if character == 'u' and cursor < len(text) and text[cursor] == '{':
            closing = text.index('}', cursor)
            result.append(chr(int(text[cursor + 1:closing], 16)))
            cursor = closing + 1
        elif character in escapes:
            result.append(escapes[character])
        else:
            raise ValueError('Unsupported Swift escape')
    return ''.join(result)


def literal(source, value):
    for match in re.finditer(STRING_PATTERN + r'\.wevVPastryCrumbBloomRestored', source):
        try:
            if literal_value(match[0].split('.wevVPastryCrumbBloomRestored')[0])[::2] == value:
                return match[0]
        except ValueError:
            continue
    for match in re.finditer(STRING_PATTERN, source):
        try:
            if literal_value(match[0]) == value:
                return match[0]
        except ValueError:
            continue
    raise ValueError('Expected Swift string expression is missing')


def bundle_resource(source, suffix=''):
    for match in re.finditer(r'Bundle\.main\.url\(forResource: sugarPalette\.sdkArchiveName[^\n)]*\)', source):
        expression = match[0]
        try:
            extension = literal(expression, 'data')
            if suffix:
                expected = 'Bundle.main.url(forResource: sugarPalette.sdkArchiveName + ' + literal(expression, suffix) + ', withExtension: ' + extension + ')'
            else:
                expected = 'Bundle.main.url(forResource: sugarPalette.sdkArchiveName, withExtension: ' + extension + ')'
            if expression == expected:
                return expression
        except ValueError:
            pass
    raise ValueError('Expected resource lookup boundary is missing')
