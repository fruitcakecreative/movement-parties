import { DateTime } from 'luxon';
import { formatTime } from './eventDisplay';
import { eventStartTimestamp } from './profileEventsByDay';
import { WEEKEND_BADGE_ICON_GLYPHS, partitionProfileExtraForShare } from './profileExtraInfo';

const CANVAS_WIDTH = 1080;
const PAD = 64;
const GUTTER = 28;
const GRID_BOTTOM_GAP = 56;
const HEADER_BOTTOM_GAP = 28;
const FA_FONT_FAMILY = '"Font Awesome 6 Free"';
const BADGE_ICON_SIZE = 17;
const BADGE_ICON_GAP = 8;
const PRO_TIP_LABEL_PREFIX = 'Pro-tip ';
const PRO_TIP_LABEL_FONT = '700 16px system-ui, -apple-system, sans-serif';
const PRO_TIP_BODY_FONT = 'italic 400 15px system-ui, -apple-system, sans-serif';
const PRO_TIP_LINE_H = 22;
const PRO_TIP_BOX_PAD = 14;
const PRO_TIP_BOX_RADIUS = 10;
const PRO_TIP_BOX_MARGIN_TOP = 10;
const FOOTER_BLOCK = 48;
const FOOTER_FONT_SIZE = 32;
const AVATAR_SIZE = 196;
const AVATAR_GAP = 24;
const FACT_LINE_H = 26;
const WEEKEND_BADGE_H = 38;

const WEEKEND_BADGE_TIER_STYLES = {
  rookie: { bg: '#ede9fe', text: '#5c4a8a', border: '#8b5cf6' },
  regular: { bg: '#d1fae5', text: '#1d5c3a', border: '#10b981' },
  veteran: { bg: '#fef3c7', text: '#7a4a10', border: '#f59e0b' },
  king: { bg: '#fcd34d', text: '#92400e', border: '#d97706' },
};
const CELL_MIN_H = 420;
const TUESDAY_BLOCK_MIN = 120;
const MAX_EVENTS_PER_SECTION = 5;

const QUADRANT_LAYOUT = [
  { key: 'friday', col: 0, row: 0, label: 'Friday' },
  { key: 'saturday', col: 1, row: 0, label: 'Saturday' },
  { key: 'sunday', col: 0, row: 1, label: 'Sunday' },
  { key: 'monday', col: 1, row: 1, label: 'Monday' },
];

const DEFAULT_THEME = {
  bg: '#141418',
  cell: '#1e1e28',
  cellBorder: 'rgba(255,255,255,0.12)',
  cellEmpty: '#18181f',
  title: '#f5f5f7',
  text: '#d4d4dc',
  muted: '#9898a8',
  primary: '#e91e8c',
  attending: '#22c55e',
  interested: '#f59e0b',
};

function readTheme() {
  if (typeof document === 'undefined') return DEFAULT_THEME;
  const style = getComputedStyle(document.documentElement);
  const pick = (name, fallback) => {
    const v = style.getPropertyValue(name).trim();
    return v || fallback;
  };
  return {
    ...DEFAULT_THEME,
    bg: pick('--color-background', DEFAULT_THEME.bg),
    cell: pick('--color-bg-dark', DEFAULT_THEME.cell),
    title: pick('--color-title', DEFAULT_THEME.title),
    text: pick('--color-text', DEFAULT_THEME.text),
    muted: pick('--color-text-light', DEFAULT_THEME.muted),
    primary: pick('--color-primary', DEFAULT_THEME.primary),
    headingFont: pick('--font-heading', 'system-ui'),
    onPrimary: pick('--color-primary-contrast', '#ffffff'),
  };
}

async function ensureShareFontsLoaded(theme) {
  if (typeof document === 'undefined' || !document.fonts?.load) return;
  const loads = [
    document.fonts.load(`900 ${BADGE_ICON_SIZE}px ${FA_FONT_FAMILY}`),
  ];
  const family = theme.headingFont?.split(',')[0]?.trim().replace(/^['"]|['"]$/g, '');
  if (family && family !== 'inherit' && family !== 'system-ui') {
    loads.push(
      document.fonts.load(`700 40px "${family}"`),
      document.fonts.load(`700 28px "${family}"`)
    );
  }
  try {
    await Promise.all(loads);
  } catch {
    /* fall back to system fonts in canvas */
  }
}

function measureFaSolid(ctx, glyph, size) {
  if (!glyph) return 0;
  ctx.font = `900 ${size}px ${FA_FONT_FAMILY}`;
  return ctx.measureText(glyph).width;
}

function drawFaSolid(ctx, glyph, x, y, size, color) {
  if (!glyph) return;
  ctx.save();
  ctx.font = `900 ${size}px ${FA_FONT_FAMILY}`;
  ctx.fillStyle = color;
  ctx.textBaseline = 'middle';
  ctx.textAlign = 'left';
  ctx.fillText(glyph, x, y);
  ctx.restore();
}

function withAlpha(color, alpha) {
  const hex = String(color || '').trim();
  if (/^#[0-9a-f]{6}$/i.test(hex)) {
    const a = Math.round(Math.min(1, Math.max(0, alpha)) * 255)
      .toString(16)
      .padStart(2, '0');
    return `${hex}${a}`;
  }
  return `rgba(233, 30, 140, ${alpha})`;
}

export function scheduleShareSiteLabel() {
  return 'generated at movementparties.com';
}

/** First token of display name (names are often a single word). */
export function firstNameFromUserName(name) {
  const s = String(name || '').trim();
  if (!s) return 'My';
  return s.split(/\s+/)[0] || 'My';
}

export function scheduleShareTitle(userName) {
  const first = firstNameFromUserName(userName);
  const possessive = first.endsWith('s') ? `${first}'` : `${first}'s`;
  return `${possessive} Movement Schedule`;
}

function loadAvatarImage(url) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.crossOrigin = 'anonymous';
    img.onload = () => resolve(img);
    img.onerror = () => reject(new Error('Could not load avatar'));
    img.src = url;
  });
}

function eventTimeLabel(event, timeZone) {
  const raw = event?.formatted_start_time || event?.start_time;
  if (!raw) return '';
  try {
    const d = new Date(raw);
    if (Number.isNaN(d.getTime())) return formatTime(raw);
    return d.toLocaleString('en-US', {
      hour: 'numeric',
      minute: '2-digit',
      timeZone: timeZone || 'America/Detroit',
    });
  } catch {
    return formatTime(raw);
  }
}

function weekdayFromDayKey(dayKey, timeZone) {
  const dt = DateTime.fromISO(dayKey, { zone: timeZone || 'America/Detroit' });
  return dt.isValid ? dt.weekday : null;
}

function daySubtitle(dayKey, timeZone) {
  const dt = DateTime.fromISO(dayKey, { zone: timeZone || 'America/Detroit' });
  return dt.isValid ? dt.toFormat('MMM d') : '';
}

function mapEvent(event, timeZone) {
  return {
    event,
    timeLabel: eventTimeLabel(event, timeZone),
  };
}

function sortEvents(list) {
  return [...list].sort((a, b) => eventStartTimestamp(a.event) - eventStartTimestamp(b.event));
}

function emptySlot() {
  return { attending: [], interested: [], dateSubtitle: '' };
}

/**
 * Friday TL · Saturday TR · Sunday BL · Monday BR · Tuesday strip below.
 * Each slot keeps attending and interested in separate lists.
 */
export function partitionEventsForShareGrid(eventsByDay, timeZone) {
  const zone = timeZone || 'America/Detroit';
  const slots = {
    friday: emptySlot(),
    saturday: emptySlot(),
    sunday: emptySlot(),
    monday: emptySlot(),
    tuesday: emptySlot(),
  };

  for (const [dayKey, dayData] of eventsByDay || []) {
    const wd = weekdayFromDayKey(dayKey, zone);
    if (wd == null) continue;

    const subtitle = daySubtitle(dayKey, zone);

    if (wd === 2) {
      const slot = slots.tuesday;
      if (!slot.dateSubtitle) slot.dateSubtitle = subtitle;
      for (const e of dayData.attending || []) slot.attending.push(mapEvent(e, zone));
      for (const e of dayData.interested || []) slot.interested.push(mapEvent(e, zone));
      continue;
    }

    const slotKey = { 5: 'friday', 6: 'saturday', 7: 'sunday', 1: 'monday' }[wd];
    if (!slotKey) continue;

    const slot = slots[slotKey];
    if (!slot.dateSubtitle) slot.dateSubtitle = subtitle;
    for (const e of dayData.attending || []) slot.attending.push(mapEvent(e, zone));
    for (const e of dayData.interested || []) slot.interested.push(mapEvent(e, zone));
  }

  for (const key of Object.keys(slots)) {
    slots[key].attending = sortEvents(slots[key].attending);
    slots[key].interested = sortEvents(slots[key].interested);
  }

  return slots;
}

function roundRect(ctx, x, y, w, h, r) {
  const radius = Math.min(r, w / 2, h / 2);
  ctx.beginPath();
  ctx.moveTo(x + radius, y);
  ctx.arcTo(x + w, y, x + w, y + h, radius);
  ctx.arcTo(x + w, y + h, x, y + h, radius);
  ctx.arcTo(x, y + h, x, y, radius);
  ctx.arcTo(x, y, x + w, y, radius);
  ctx.closePath();
}

function truncateToWidth(ctx, text, maxWidth) {
  const s = String(text || '');
  if (!s) return '';
  if (ctx.measureText(s).width <= maxWidth) return s;
  let t = s;
  while (t.length > 1 && ctx.measureText(`${t}…`).width > maxWidth) {
    t = t.slice(0, -1);
  }
  return `${t}…`;
}

function slotHasEvents(slot) {
  return (slot?.attending?.length || 0) + (slot?.interested?.length || 0) > 0;
}

/** Left accent bar beside weekday + date — shared with drawDayHeading for alignment */
const DAY_ACCENT = { insetX: 16, top: 20, width: 4, height: 26 };
const DAY_TEXT_X = DAY_ACCENT.insetX + DAY_ACCENT.width + 10;
/** Nudge heading font — visually centers better vs the accent bar */
const DAY_HEADING_TEXT_OFFSET_Y = 3;

const LAYOUT = {
  cellPad: 18,
  dayHeader: 56,
  dayToSectionsGap: 20,
  sectionGap: 12,
  sectionHeading: 24,
  sectionPad: 4,
  moreLine: 28,
};

function measureSectionHeight(events, compact) {
  if (!events.length) return 0;
  const rowH = compact ? 50 : 54;
  const cap = Math.min(events.length, MAX_EVENTS_PER_SECTION);
  let h = LAYOUT.sectionHeading + LAYOUT.sectionPad;
  h += cap * rowH;
  if (events.length > cap) h += LAYOUT.moreLine;
  return h;
}

function measureSlotHeight(slot, { compact = false } = {}) {
  const hasA = slot.attending.length > 0;
  const hasI = slot.interested.length > 0;
  if (!hasA && !hasI) return LAYOUT.dayHeader + 28;

  let h = LAYOUT.dayHeader + LAYOUT.dayToSectionsGap;
  if (hasA) h += measureSectionHeight(slot.attending, compact);
  if (hasA && hasI) h += LAYOUT.sectionGap;
  if (hasI) h += measureSectionHeight(slot.interested, compact);
  return h + LAYOUT.cellPad;
}

function wrapTextLines(ctx, text, maxWidth) {
  const words = String(text || '').trim().split(/\s+/).filter(Boolean);
  if (!words.length) return [];
  const lines = [];
  let line = words[0];
  for (let i = 1; i < words.length; i += 1) {
    const next = `${line} ${words[i]}`;
    if (ctx.measureText(next).width <= maxWidth) {
      line = next;
    } else {
      lines.push(line);
      line = words[i];
    }
  }
  lines.push(line);
  return lines;
}

function profileTextColumnWidth(hasAvatar) {
  const textX = hasAvatar ? PAD + AVATAR_SIZE + AVATAR_GAP : PAD;
  return CANVAS_WIDTH - PAD - textX;
}

const FACT_CHUNK_SEP = ' · ';

function measureFactChunk(ctx, fact) {
  const labelText = `${fact.shortLabel} · `;
  ctx.font = '600 16px system-ui, -apple-system, sans-serif';
  const labelW = ctx.measureText(labelText).width;
  ctx.font = '500 17px system-ui, -apple-system, sans-serif';
  const valueW = ctx.measureText(fact.value).width;
  return {
    shortLabel: fact.shortLabel,
    value: fact.value,
    labelText,
    labelW,
    valueW,
    totalW: labelW + valueW,
  };
}

function wrapValueWithLabel(ctx, value, firstLineW, fullLineW) {
  const words = String(value || '').trim().split(/\s+/).filter(Boolean);
  if (!words.length) return [''];

  ctx.font = '500 17px system-ui, -apple-system, sans-serif';
  const lines = [];
  let line = '';
  let limit = Math.max(40, firstLineW);

  for (const word of words) {
    const next = line ? `${line} ${word}` : word;
    if (ctx.measureText(next).width <= limit) {
      line = next;
    } else {
      if (line) lines.push(line);
      line = word;
      limit = fullLineW;
    }
  }
  if (line) lines.push(line);
  return lines;
}

function measureFactChunkHeight(ctx, chunk, maxW) {
  if (chunk.totalW <= maxW) return FACT_LINE_H;
  const valueLines = wrapValueWithLabel(
    ctx,
    chunk.value,
    maxW - chunk.labelW,
    maxW
  );
  return valueLines.length * FACT_LINE_H;
}

/** Each fact (label + value) wraps as one unit; sep between facts on a row. */
function layoutFactChunkRows(ctx, facts, maxW) {
  const chunks = facts.map((f) => measureFactChunk(ctx, f));
  ctx.font = '600 16px system-ui, -apple-system, sans-serif';
  const sepW = ctx.measureText(FACT_CHUNK_SEP).width;

  const rows = [];
  let row = [];
  let rowW = 0;
  let rowH = 0;

  chunks.forEach((chunk, i) => {
    const leadingSep = i > 0;
    const chunkH = measureFactChunkHeight(ctx, chunk, maxW);
    const addW = chunk.totalW + (leadingSep ? sepW : 0);

    if (row.length && rowW + addW > maxW) {
      rows.push({ items: row, height: rowH });
      row = [{ chunk, leadingSep: false }];
      rowW = chunk.totalW;
      rowH = chunkH;
    } else {
      if (leadingSep) rowW += sepW;
      row.push({ chunk, leadingSep });
      rowW += chunk.totalW;
      rowH = Math.max(rowH, chunkH);
    }
  });

  if (row.length) rows.push({ items: row, height: rowH });
  return rows;
}

function measureInlineFactsHeight(ctx, facts, maxW) {
  if (!facts.length) return 0;
  const rows = layoutFactChunkRows(ctx, facts, maxW);
  return rows.reduce((sum, row) => sum + row.height, 0);
}

function drawFactChunk(ctx, theme, chunkX, y, chunkMaxW, chunk) {
  const wrapW = Math.max(40, chunkMaxW);

  if (chunk.totalW <= wrapW) {
    ctx.fillStyle = theme.primary;
    ctx.font = '600 16px system-ui, -apple-system, sans-serif';
    ctx.fillText(chunk.labelText, chunkX, y + 18);

    ctx.fillStyle = theme.text;
    ctx.font = '500 17px system-ui, -apple-system, sans-serif';
    ctx.fillText(chunk.value, chunkX + chunk.labelW, y + 18);
    return FACT_LINE_H;
  }

  const valueLines = wrapValueWithLabel(
    ctx,
    chunk.value,
    wrapW - chunk.labelW,
    wrapW
  );

  ctx.fillStyle = theme.primary;
  ctx.font = '600 16px system-ui, -apple-system, sans-serif';
  ctx.fillText(chunk.labelText, chunkX, y + 18);

  ctx.fillStyle = theme.text;
  ctx.font = '500 17px system-ui, -apple-system, sans-serif';
  ctx.fillText(valueLines[0] || '', chunkX + chunk.labelW, y + 18);

  let cy = y + FACT_LINE_H;
  for (let i = 1; i < valueLines.length; i += 1) {
    ctx.fillText(valueLines[i], chunkX, cy + 18);
    cy += FACT_LINE_H;
  }

  return valueLines.length * FACT_LINE_H;
}

function measureProfileHeaderHeight(ctx, theme, userName, hasAvatar, profileParts) {
  const maxW = profileTextColumnWidth(hasAvatar);
  let stackH = 0;

  ctx.font = titleFont(theme, 40);
  stackH += 48;

  if (profileParts.weekend?.label) {
    stackH += WEEKEND_BADGE_H + 12;
  }

  if (profileParts.facts.length) {
    stackH += measureInlineFactsHeight(ctx, profileParts.facts, maxW);
  }

  if (profileParts.proTip) {
    stackH += PRO_TIP_BOX_MARGIN_TOP + measureProTipBox(ctx, profileParts.proTip, maxW);
  }

  const avatarH = hasAvatar ? AVATAR_SIZE + 8 : 0;
  return Math.max(avatarH, stackH) + 12;
}

function measureProTipLabelWidth(ctx) {
  ctx.font = PRO_TIP_LABEL_FONT;
  return ctx.measureText(PRO_TIP_LABEL_PREFIX).width;
}

function wrapProTipLines(ctx, proTip, innerW, prefixW) {
  const words = String(proTip || '').trim().split(/\s+/).filter(Boolean);
  if (!words.length) return [''];

  ctx.font = PRO_TIP_BODY_FONT;
  const lines = [];
  let line = '';
  let limit = Math.max(40, innerW - prefixW);

  for (const word of words) {
    const next = line ? `${line} ${word}` : word;
    if (ctx.measureText(next).width <= limit) {
      line = next;
    } else {
      if (line) lines.push(line);
      line = word;
      limit = innerW;
    }
  }
  if (line) lines.push(line);
  return lines;
}

function measureProTipBox(ctx, proTip, boxW) {
  const innerW = Math.max(80, boxW - PRO_TIP_BOX_PAD * 2);
  const prefixW = measureProTipLabelWidth(ctx);
  const lines = wrapProTipLines(ctx, proTip, innerW, prefixW);
  return Math.max(1, lines.length) * PRO_TIP_LINE_H + PRO_TIP_BOX_PAD * 2;
}

function layoutMetrics(slots, profileParts, ctx, theme, userName, hasAvatar) {
  let maxCellH = CELL_MIN_H;
  for (const q of QUADRANT_LAYOUT) {
    maxCellH = Math.max(maxCellH, measureSlotHeight(slots[q.key]));
  }

  const tuesdayH = slotHasEvents(slots.tuesday)
    ? Math.max(TUESDAY_BLOCK_MIN, measureSlotHeight(slots.tuesday, { compact: true }) + 36)
    : 0;

  const headerH = measureProfileHeaderHeight(ctx, theme, userName, hasAvatar, profileParts);
  const gridH = maxCellH * 2 + GUTTER;
  const height =
    PAD +
    headerH +
    HEADER_BOTTOM_GAP +
    gridH +
    GRID_BOTTOM_GAP +
    (tuesdayH ? GUTTER + tuesdayH : 0) +
    FOOTER_BLOCK +
    PAD;

  return { height, cellH: maxCellH, tuesdayH, headerH };
}

function drawWeekendBadgePill(ctx, theme, x, y, label, tier) {
  const style = WEEKEND_BADGE_TIER_STYLES[tier] || WEEKEND_BADGE_TIER_STYLES.regular;
  const glyph = WEEKEND_BADGE_ICON_GLYPHS[tier] || '';
  ctx.font = '700 17px system-ui, -apple-system, sans-serif';
  const textW = ctx.measureText(label).width;
  const iconW = glyph ? measureFaSolid(ctx, glyph, BADGE_ICON_SIZE) + BADGE_ICON_GAP : 0;
  const padX = 16;
  const innerW = iconW + textW;
  const w = Math.min(innerW + padX * 2, CANVAS_WIDTH - PAD - x);
  const h = WEEKEND_BADGE_H;

  roundRect(ctx, x, y, w, h, h / 2);
  ctx.fillStyle = style.bg;
  ctx.fill();
  ctx.strokeStyle = style.border;
  ctx.lineWidth = 1.5;
  ctx.stroke();

  let tx = x + padX;
  const midY = y + h / 2 + 1;
  if (glyph) {
    drawFaSolid(ctx, glyph, tx, midY, BADGE_ICON_SIZE, style.text);
    tx += measureFaSolid(ctx, glyph, BADGE_ICON_SIZE) + BADGE_ICON_GAP;
  }

  ctx.fillStyle = style.text;
  ctx.font = '700 17px system-ui, -apple-system, sans-serif';
  ctx.textBaseline = 'middle';
  ctx.fillText(truncateToWidth(ctx, label, w - padX * 2 - iconW), tx, midY);
  ctx.textBaseline = 'alphabetic';

  return { w, h };
}

function drawInlineFacts(ctx, theme, x, y, maxW, facts) {
  if (!facts.length) return 0;

  const rows = layoutFactChunkRows(ctx, facts, maxW);
  let cy = y;

  ctx.font = '600 16px system-ui, -apple-system, sans-serif';
  const sepW = ctx.measureText(FACT_CHUNK_SEP).width;

  for (const row of rows) {
    let cx = x;
    let rowTop = cy;

    for (const { chunk, leadingSep } of row.items) {
      if (leadingSep) {
        ctx.fillStyle = theme.primary;
        ctx.font = '600 16px system-ui, -apple-system, sans-serif';
        ctx.fillText(FACT_CHUNK_SEP, cx, rowTop + 18);
        cx += sepW;
      }
      const chunkMaxW = Math.min(chunk.totalW, maxW - (cx - x));
      drawFactChunk(ctx, theme, cx, rowTop, chunkMaxW, chunk);
      cx += chunk.totalW;
    }

    cy += row.height;
  }

  return cy - y;
}

function drawProfileHeader(ctx, theme, y, userName, avatarImage, profileParts) {
  const hasAvatar = !!avatarImage;
  const textX = hasAvatar ? PAD + AVATAR_SIZE + AVATAR_GAP : PAD;
  const maxW = CANVAS_WIDTH - PAD - textX;
  let cy = y + 10;

  if (hasAvatar) {
    drawAvatar(ctx, theme, avatarImage, PAD, y + 6);
  }

  ctx.textAlign = 'left';
  ctx.fillStyle = theme.title;
  ctx.font = titleFont(theme, 40);
  ctx.fillText(truncateToWidth(ctx, scheduleShareTitle(userName), maxW), textX, cy + 38);
  cy += 52;

  if (profileParts.weekend?.label && profileParts.weekend.tier) {
    const badge = drawWeekendBadgePill(
      ctx,
      theme,
      textX,
      cy,
      profileParts.weekend.label,
      profileParts.weekend.tier
    );
    cy += badge.h + 12;
  }

  if (profileParts.facts.length) {
    cy += drawInlineFacts(ctx, theme, textX, cy, maxW, profileParts.facts);
  }

  if (profileParts.proTip) {
    cy += PRO_TIP_BOX_MARGIN_TOP;
    cy += drawProTipBox(ctx, theme, textX, cy, maxW, profileParts.proTip);
  }

  const blockH = Math.max(hasAvatar ? AVATAR_SIZE + 14 : 0, cy - y);
  return blockH + 8;
}

function drawProTipBox(ctx, theme, x, y, boxW, proTip) {
  const innerW = Math.max(80, boxW - PRO_TIP_BOX_PAD * 2);
  const prefixW = measureProTipLabelWidth(ctx);
  const lines = wrapProTipLines(ctx, proTip, innerW, prefixW);
  const boxH = Math.max(1, lines.length) * PRO_TIP_LINE_H + PRO_TIP_BOX_PAD * 2;

  roundRect(ctx, x, y, boxW, boxH, PRO_TIP_BOX_RADIUS);
  ctx.fillStyle = withAlpha(theme.text, 0.06);
  ctx.fill();
  ctx.strokeStyle = withAlpha(theme.text, 0.14);
  ctx.lineWidth = 1;
  ctx.stroke();

  const tx = x + PRO_TIP_BOX_PAD;
  let lineY = y + PRO_TIP_BOX_PAD + 16;

  ctx.textAlign = 'left';
  ctx.font = PRO_TIP_LABEL_FONT;
  ctx.fillStyle = theme.primary;
  ctx.fillText(PRO_TIP_LABEL_PREFIX, tx, lineY);

  ctx.font = PRO_TIP_BODY_FONT;
  ctx.fillStyle = withAlpha(theme.text, 0.9);
  if (lines.length) {
    ctx.fillText(lines[0], tx + prefixW, lineY);
    for (let i = 1; i < lines.length; i += 1) {
      lineY += PRO_TIP_LINE_H;
      ctx.fillText(lines[i], tx, lineY);
    }
  }

  return boxH;
}

function drawBackground(ctx, theme, height) {
  ctx.fillStyle = theme.bg;
  ctx.fillRect(0, 0, CANVAS_WIDTH, height);
}

function drawCoverImageInCircle(ctx, img, cx, cy, diameter) {
  const r = diameter / 2;
  const iw = img.naturalWidth || img.width;
  const ih = img.naturalHeight || img.height;
  if (!iw || !ih) return;

  const scale = Math.max(diameter / iw, diameter / ih);
  const sw = diameter / scale;
  const sh = diameter / scale;
  const sx = (iw - sw) / 2;
  const sy = (ih - sh) / 2;

  ctx.save();
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.closePath();
  ctx.clip();
  ctx.drawImage(img, sx, sy, sw, sh, cx - r, cy - r, diameter, diameter);
  ctx.restore();
}

function drawAvatar(ctx, theme, img, x, y) {
  const d = AVATAR_SIZE;
  const r = d / 2;
  const cx = x + r;
  const cy = y + r;

  ctx.save();
  ctx.shadowColor = withAlpha(theme.primary, 0.55);
  ctx.shadowBlur = 22;
  ctx.shadowOffsetY = 2;
  ctx.beginPath();
  ctx.arc(cx, cy, r + 3, 0, Math.PI * 2);
  ctx.strokeStyle = theme.primary;
  ctx.lineWidth = 3;
  ctx.stroke();
  ctx.restore();

  drawCoverImageInCircle(ctx, img, cx, cy, d);

  ctx.strokeStyle = withAlpha(theme.title, 0.85);
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.arc(cx, cy, r, 0, Math.PI * 2);
  ctx.stroke();
}

function titleFont(theme, sizePx, weight = 700) {
  const family = theme.headingFont || 'system-ui';
  return `${weight} ${sizePx}px ${family}, system-ui, -apple-system, sans-serif`;
}

function drawSectionHeading(ctx, theme, x, y, label, accent) {
  ctx.fillStyle = accent;
  ctx.font = '700 17px system-ui, -apple-system, sans-serif';
  ctx.fillText(label, x, y + 15);
  return y + LAYOUT.sectionHeading;
}

/** ✓ or ★ + title, then venue · time on the line below (classic share layout). */
function drawEventRows(ctx, theme, x, y, w, events, status, { compact = false } = {}) {
  const pad = LAYOUT.cellPad;
  const innerW = w - pad * 2;
  const rowH = compact ? 50 : 54;
  const titleSize = compact ? 20 : 22;
  const metaSize = compact ? 16 : 17;
  const accent = status === 'attending' ? theme.attending : theme.interested;
  const icon = status === 'attending' ? '✓' : '★';
  let cy = y;

  const visible = events.slice(0, MAX_EVENTS_PER_SECTION);
  for (const row of visible) {
    const title = row.event.short_title || row.event.title || 'Event';
    const meta = [row.event.venue?.name, row.timeLabel].filter(Boolean).join(' · ');

    ctx.fillStyle = accent;
    ctx.font = `700 ${titleSize}px system-ui, -apple-system, sans-serif`;
    ctx.fillText(icon, x + pad, cy + titleSize + 2);

    ctx.fillStyle = theme.title;
    ctx.font = `600 ${titleSize}px system-ui, -apple-system, sans-serif`;
    ctx.fillText(
      truncateToWidth(ctx, title, innerW - 28),
      x + pad + 26,
      cy + titleSize + 2
    );

    if (meta) {
      ctx.fillStyle = theme.muted;
      ctx.font = `400 ${metaSize}px system-ui, -apple-system, sans-serif`;
      ctx.fillText(
        truncateToWidth(ctx, meta, innerW - 8),
        x + pad + 26,
        cy + titleSize + metaSize + 8
      );
    }

    cy += rowH;
  }

  if (events.length > MAX_EVENTS_PER_SECTION) {
    ctx.fillStyle = theme.muted;
    ctx.font = '500 17px system-ui, sans-serif';
    ctx.fillText(
      `+${events.length - MAX_EVENTS_PER_SECTION} more`,
      x + pad,
      cy + 18
    );
    cy += LAYOUT.moreLine;
  }

  return cy;
}

function drawStatusSections(ctx, theme, x, y, w, slot, { compact = false } = {}) {
  let cy = y;
  const hasA = slot.attending.length > 0;
  const hasI = slot.interested.length > 0;
  const textX = x + LAYOUT.cellPad;

  if (hasA) {
    cy = drawSectionHeading(ctx, theme, textX, cy, 'ATTENDING', theme.attending);
    cy += LAYOUT.sectionPad;
    cy = drawEventRows(ctx, theme, x, cy, w, slot.attending, 'attending', { compact });
  }

  if (hasA && hasI) cy += LAYOUT.sectionGap;

  if (hasI) {
    cy = drawSectionHeading(ctx, theme, textX, cy, 'INTERESTED', theme.interested);
    cy += LAYOUT.sectionPad;
    cy = drawEventRows(ctx, theme, x, cy, w, slot.interested, 'interested', { compact });
  }

  return cy;
}

function drawCellCard(ctx, theme, x, y, w, h, hasEvents) {
  ctx.save();
  ctx.shadowColor = withAlpha(theme.primary, hasEvents ? 0.22 : 0.1);
  ctx.shadowBlur = 14;
  ctx.shadowOffsetY = 3;
  roundRect(ctx, x, y, w, h, 18);
  ctx.fillStyle = hasEvents ? theme.cell : theme.cellEmpty;
  ctx.fill();
  ctx.restore();

  roundRect(ctx, x, y, w, h, 18);
  ctx.strokeStyle = withAlpha(theme.primary, hasEvents ? 0.45 : 0.2);
  ctx.lineWidth = 1.5;
  ctx.stroke();

  ctx.fillStyle = theme.primary;
  ctx.fillRect(
    x + DAY_ACCENT.insetX,
    y + DAY_ACCENT.top,
    DAY_ACCENT.width,
    DAY_ACCENT.height
  );
}

function drawDayHeading(ctx, theme, x, y, dayLine, sizePx) {
  const barCenterY = y + DAY_ACCENT.top + DAY_ACCENT.height / 2;

  ctx.fillStyle = theme.title;
  ctx.font = titleFont(theme, sizePx);
  ctx.textBaseline = 'middle';
  ctx.fillText(dayLine, x + DAY_TEXT_X, barCenterY + DAY_HEADING_TEXT_OFFSET_Y);
  ctx.textBaseline = 'alphabetic';
}

function drawQuadrant(ctx, theme, x, y, w, h, label, slot) {
  const hasEvents = slotHasEvents(slot);
  drawCellCard(ctx, theme, x, y, w, h, hasEvents);

  const dayLine = slot.dateSubtitle ? `${label} · ${slot.dateSubtitle}` : label;
  drawDayHeading(ctx, theme, x, y, dayLine, 28);

  if (!hasEvents) {
    ctx.fillStyle = theme.muted;
    ctx.font = '400 20px system-ui, sans-serif';
    ctx.fillText('—', x + DAY_TEXT_X, y + 96);
    return;
  }

  drawStatusSections(
    ctx,
    theme,
    x,
    y + LAYOUT.dayHeader + LAYOUT.dayToSectionsGap,
    w,
    slot
  );
}

function drawTuesdayStrip(ctx, theme, x, y, w, h, slot) {
  drawCellCard(ctx, theme, x, y, w, h, true);

  const sub = slot.dateSubtitle ? ` · ${slot.dateSubtitle}` : '';
  drawDayHeading(ctx, theme, x, y, `Tuesday${sub}`, 24);

  drawStatusSections(
    ctx,
    theme,
    x,
    y + LAYOUT.dayHeader + LAYOUT.dayToSectionsGap,
    w,
    slot,
    { compact: true }
  );
}

function drawFooter(ctx, theme, height, promo) {
  const barTop = height - FOOTER_BLOCK - PAD;
  const barH = FOOTER_BLOCK + PAD;

  ctx.fillStyle = theme.primary;
  ctx.fillRect(0, barTop, CANVAS_WIDTH, barH);

  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillStyle = theme.onPrimary;
  ctx.font = `600 ${FOOTER_FONT_SIZE}px system-ui, -apple-system, sans-serif`;
  ctx.fillText(promo, CANVAS_WIDTH / 2, barTop + barH / 2);
  ctx.textAlign = 'left';
  ctx.textBaseline = 'alphabetic';
}

/**
 * Renders a shareable PNG — 2×2 weekend grid + optional Tuesday strip.
 * @returns {Promise<Blob>}
 */
export async function generateScheduleShareImage({
  eventsByDay,
  userName,
  avatarUrl,
  profileExtra,
  timeZone,
}) {
  if (!eventsByDay?.length) {
    throw new Error('No events to share');
  }

  const theme = readTheme();
  await ensureShareFontsLoaded(theme);
  const slots = partitionEventsForShareGrid(eventsByDay, timeZone);
  const promo = scheduleShareSiteLabel();
  const cellW = (CANVAS_WIDTH - PAD * 2 - GUTTER) / 2;

  let avatarImage = null;
  if (avatarUrl) {
    try {
      avatarImage = await loadAvatarImage(avatarUrl);
    } catch {
      avatarImage = null;
    }
  }

  const profileParts = partitionProfileExtraForShare(profileExtra);
  const hasAvatar = !!avatarImage;

  const measureCanvas = document.createElement('canvas');
  measureCanvas.width = CANVAS_WIDTH;
  const measureCtx = measureCanvas.getContext('2d');
  const { height, cellH, tuesdayH } = layoutMetrics(
    slots,
    profileParts,
    measureCtx,
    theme,
    userName,
    hasAvatar
  );

  const canvas = document.createElement('canvas');
  canvas.width = CANVAS_WIDTH;
  canvas.height = height;
  const ctx = canvas.getContext('2d');

  drawBackground(ctx, theme, height);

  let y = PAD;
  y += drawProfileHeader(ctx, theme, y, userName, avatarImage, profileParts);
  y += HEADER_BOTTOM_GAP;

  const gridX = PAD;
  const gridY = y;

  for (const q of QUADRANT_LAYOUT) {
    const x = gridX + q.col * (cellW + GUTTER);
    const cy = gridY + q.row * (cellH + GUTTER);
    drawQuadrant(ctx, theme, x, cy, cellW, cellH, q.label, slots[q.key]);
  }

  y = gridY + cellH * 2 + GUTTER + GRID_BOTTOM_GAP;

  if (slotHasEvents(slots.tuesday)) {
    drawTuesdayStrip(ctx, theme, PAD, y, CANVAS_WIDTH - PAD * 2, tuesdayH, slots.tuesday);
    y += tuesdayH + GUTTER;
  }

  drawFooter(ctx, theme, height, promo);

  return new Promise((resolve, reject) => {
    canvas.toBlob(
      (blob) => {
        if (blob) resolve(blob);
        else reject(new Error('Could not create image'));
      },
      'image/png',
      1
    );
  });
}

export function downloadScheduleShareBlob(blob, filename = 'my-schedule.png') {
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.rel = 'noopener';
  document.body.appendChild(a);
  a.click();
  a.remove();
  window.setTimeout(() => URL.revokeObjectURL(url), 2000);
}

export async function shareScheduleShareBlob(blob, title) {
  const file = new File([blob], 'my-schedule.png', { type: 'image/png' });
  if (navigator.share && navigator.canShare?.({ files: [file] })) {
    await navigator.share({
      files: [file],
      title: title || 'My event schedule',
    });
    return true;
  }
  return false;
}
