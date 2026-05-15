import { normalizeEventId } from './eventId';

describe('normalizeEventId', () => {
  it('parses numeric ids', () => {
    expect(normalizeEventId(1670)).toBe(1670);
    expect(normalizeEventId('1697')).toBe(1697);
  });

  it('parses planby composite row ids', () => {
    expect(normalizeEventId('123_row_0')).toBe(123);
    expect(normalizeEventId('123_row_2')).toBe(123);
  });

  it('rejects invalid values', () => {
    expect(normalizeEventId(null)).toBeNull();
    expect(normalizeEventId('')).toBeNull();
    expect(normalizeEventId('abc')).toBeNull();
    expect(normalizeEventId(NaN)).toBeNull();
  });
});
