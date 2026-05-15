import { DateTime } from 'luxon';
import { formatTime } from './eventDisplay';
import { eventStartTimestamp } from './profileEventsByDay';

/** Portrait-friendly width for phone sharing (Stories / camera roll). */
const CANVAS_WIDTH = 1080;
const PAD = 80;
const GUTTER = 32;
const HEADER_BLOCK = 148;
const FOOTER_BLOCK = 108;
const CELL_MIN_H = 500;
const TUESDAY_BLOCK_MIN = 140;
const MAX_EVENTS_PER_CELL = 7;

const QUADRANT_LAYOUT = [
  { key: 'friday', col: 0, row: 0, label: 'Friday' },
  { key: 'saturday', col: 1, row: 0, label: 'Saturday' },
  { key: 'sunday', col: 0, row: 1, label: 'Sunday' },
  { key: 'monday', col: 1, row: 1, label: 'Monday' },
];

const DEFAULT_THEME = {
  bg: '#141418',
  cell: '#1e1e28',
  cellEmpty: '#18181f',
  title: '#f5f5f7',
  text: '#d4d4dc',
  muted: '#9898a8',
  primary: '#e91e8c',
  attending: '#22c55e',
  interested: '#f59e0b',
  footerBg: '#1c1c24',
  gridLine: 'rgba(255,255,255,0.08)',
};

function readTheme() {
  if (typeof document === 'undefined') return DEFAULT_THEME;
  const style = getComputedStyle(document.documentElement);
  const pick = (name, fallback) => {
    const v = style.getPropertyValue(name).trim();
    return v || fallback;
  };
  return {
    bg: pick('--color-background', DEFAULT_THEME.bg),
    cell: pick('--color-bg-dark', DEFAULT_THEME.cell),
    cellEmpty: pick('--color-bg-dark', DEFAULT_THEME.cellEmpty),
    title: pick('--color-title', DEFAULT_THEME.title),
    text: pick('--color-text', DEFAULT_THEME.text),
    muted: pick('--color-text-light', DEFAULT_THEME.muted),
    primary: pick('--color-primary', DEFAULT_THEME.primary),
    attending: '#22c55e',
    interested: '#f59e0b',
    footerBg: pick('--color-bg-dark', DEFAULT_THEME.footerBg),
    gridLine: DEFAULT_THEME.gridLine,
  };
}

export function scheduleShareSiteLabel() {
  const url = process.env.REACT_APP_OG_URL || 'https://movementparties.com';
  try {
    const host = new URL(url).hostname.replace(/^www\./, '');
    return `Generated at ${host}`;
  } catch {
    return 'Generated at movementparties.com';
  }
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
      timeZone: timeZone || 'America/New_York',
    });
  } catch {
    return formatTime(raw);
  }
}

function weekdayFromDayKey(dayKey, timeZone) {
  const dt = DateTime.fromISO(dayKey, { zone: timeZone || 'America/New_York' });
  return dt.isValid ? dt.weekday : null;
}

/**
 * Friday TL · Saturday TR · Sunday BL · Monday BR · Tuesday attending strip below.
 */
export function partitionEventsForShareGrid(eventsByDay, timeZone) {
  const zone = timeZone || 'America/New_York';
  const slots = {
    friday: { events: [] },
    saturday: { events: [] },
    sunday: { events: [] },
    monday: { events: [] },
    tuesdayAttending: { events: [] },
  };

  const push = (bucket, event, status) => {
    bucket.events.push({ event, status, timeLabel: eventTimeLabel(event, zone) });
  };

  for (const [dayKey, dayData] of eventsByDay || []) {
    const wd = weekdayFromDayKey(dayKey, zone);
    if (wd == null) continue;

    if (wd === 2) {
      for (const e of dayData.attending || []) push(slots.tuesdayAttending, e, 'attending');
      continue;
    }

    const slotKey = { 5: 'friday', 6: 'saturday', 7: 'sunday', 1: 'monday' }[wd];
    if (!slotKey) continue;

    for (const e of dayData.attending || []) push(slots[slotKey], e, 'attending');
    for (const e of dayData.interested || []) push(slots[slotKey], e, 'interested');
  }

  for (const key of Object.keys(slots)) {
    slots[key].events.sort(
      (a, b) => eventStartTimestamp(a.event) - eventStartTimestamp(b.event)
    );
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

function measureTuesdayBlockHeight(ctx, events, innerW) {
  if (!events.length) return 0;
  const rowH = 52;
  const headerH = 44;
  const cap = Math.min(events.length, MAX_EVENTS_PER_CELL);
  const extra = events.length > cap ? 28 : 16;
  return headerH + cap * rowH + extra + 20;
}

function measureCellContentHeight(ctx, events, innerW) {
  const rowH = 54;
  const headerH = 52;
  if (!events.length) return headerH + 36;
  const cap = Math.min(events.length, MAX_EVENTS_PER_CELL);
  const extra = events.length > cap ? 28 : 16;
  return headerH + cap * rowH + extra;
}

function layoutMetrics(slots, ctx, cellW, innerW) {
  let maxCellH = CELL_MIN_H;
  for (const q of QUADRANT_LAYOUT) {
    const h = measureCellContentHeight(ctx, slots[q.key].events, innerW);
    maxCellH = Math.max(maxCellH, h);
  }
  const tuesdayH =
    slots.tuesdayAttending.events.length > 0
      ? Math.max(TUESDAY_BLOCK_MIN, measureTuesdayBlockHeight(ctx, slots.tuesdayAttending.events, innerW))
      : 0;

  const gridH = maxCellH * 2 + GUTTER;
  const height =
    PAD + HEADER_BLOCK + gridH + (tuesdayH ? GUTTER + tuesdayH : 0) + FOOTER_BLOCK + PAD;

  return { height, cellH: maxCellH, tuesdayH, innerW: cellW - 36 };
}

function drawHeader(ctx, theme, y, userName, siteTitle) {
  const displayName = (userName || 'My').trim();
  const title = displayName.endsWith('s')
    ? `${displayName} schedule`
    : `${displayName}'s schedule`;

  ctx.fillStyle = theme.title;
  ctx.font = '800 48px system-ui, -apple-system, sans-serif';
  ctx.textAlign = 'center';
  ctx.fillText(title, CANVAS_WIDTH / 2, y + 52);

  ctx.fillStyle = theme.muted;
  ctx.font = '500 24px system-ui, -apple-system, sans-serif';
  ctx.fillText(
    siteTitle || process.env.REACT_APP_PAGE_TITLE || 'Movement Parties',
    CANVAS_WIDTH / 2,
    y + 92
  );

  ctx.textAlign = 'left';
}

function drawEventRows(ctx, theme, x, y, w, events, { compact = false } = {}) {
  const pad = 18;
  const innerW = w - pad * 2;
  const rowH = compact ? 50 : 54;
  const titleSize = compact ? 20 : 22;
  const metaSize = compact ? 16 : 17;
  let cy = y;

  const visible = events.slice(0, MAX_EVENTS_PER_CELL);
  for (const row of visible) {
    const accent = row.status === 'attending' ? theme.attending : theme.interested;
    const icon = row.status === 'attending' ? '✓' : '★';
    const title = row.event.short_title || row.event.title || 'Event';
    const meta = [row.event.venue?.name, row.timeLabel].filter(Boolean).join(' · ');

    ctx.fillStyle = accent;
    ctx.font = `700 ${titleSize}px system-ui, -apple-system, sans-serif`;
    ctx.fillText(icon, x + pad, cy + titleSize + 2);

    ctx.fillStyle = theme.title;
    ctx.font = `600 ${titleSize}px system-ui, -apple-system, sans-serif`;
    const titleText = truncateToWidth(ctx, title, innerW - 28);
    ctx.fillText(titleText, x + pad + 26, cy + titleSize + 2);

    if (meta) {
      ctx.fillStyle = theme.muted;
      ctx.font = `400 ${metaSize}px system-ui, -apple-system, sans-serif`;
      ctx.fillText(truncateToWidth(ctx, meta, innerW - 8), x + pad + 26, cy + titleSize + metaSize + 8);
    }

    cy += rowH;
  }

  if (events.length > MAX_EVENTS_PER_CELL) {
    ctx.fillStyle = theme.muted;
    ctx.font = '500 17px system-ui, -apple-system, sans-serif';
    ctx.fillText(
      `+${events.length - MAX_EVENTS_PER_CELL} more`,
      x + pad,
      cy + 18
    );
    cy += 28;
  }

  return cy;
}

function drawQuadrant(ctx, theme, x, y, w, h, label, events) {
  const hasEvents = events.length > 0;
  roundRect(ctx, x, y, w, h, 16);
  ctx.fillStyle = hasEvents ? theme.cell : theme.cellEmpty;
  ctx.fill();
  ctx.strokeStyle = theme.gridLine;
  ctx.lineWidth = 1;
  ctx.stroke();

  ctx.fillStyle = theme.primary;
  ctx.fillRect(x + 16, y + 18, 4, 28);

  ctx.fillStyle = theme.title;
  ctx.font = '700 28px system-ui, -apple-system, sans-serif';
  ctx.fillText(label, x + 28, y + 42);

  if (!hasEvents) {
    ctx.fillStyle = theme.muted;
    ctx.font = '400 20px system-ui, -apple-system, sans-serif';
    ctx.fillText('—', x + 28, y + 88);
    return;
  }

  drawEventRows(ctx, theme, x, y + 52, w, events);
}

function drawTuesdayBonus(ctx, theme, x, y, w, h, events) {
  roundRect(ctx, x, y, w, h, 16);
  ctx.fillStyle = theme.cell;
  ctx.fill();
  ctx.strokeStyle = theme.attending;
  ctx.globalAlpha = 0.35;
  ctx.lineWidth = 2;
  ctx.stroke();
  ctx.globalAlpha = 1;

  ctx.fillStyle = theme.attending;
  ctx.font = '700 22px system-ui, -apple-system, sans-serif';
  ctx.fillText('TUESDAY · ATTENDING', x + 24, y + 38);

  drawEventRows(ctx, theme, x, y + 48, w, events, { compact: true });
}

function drawFooter(ctx, theme, y, height, promo) {
  const footerTop = height - FOOTER_BLOCK - PAD;
  ctx.fillStyle = theme.footerBg;
  ctx.fillRect(0, footerTop, CANVAS_WIDTH, FOOTER_BLOCK + PAD);

  ctx.textAlign = 'center';
  ctx.fillStyle = theme.muted;
  ctx.font = '500 22px system-ui, -apple-system, sans-serif';
  ctx.fillText(promo, CANVAS_WIDTH / 2, footerTop + 40);

  ctx.fillStyle = theme.primary;
  ctx.font = '600 20px system-ui, -apple-system, sans-serif';
  ctx.fillText('Save your lineup →', CANVAS_WIDTH / 2, footerTop + 72);
  ctx.textAlign = 'left';
}

/**
 * Renders a shareable PNG — 2×2 weekend grid + optional Tuesday attending strip.
 * @returns {Promise<Blob>}
 */
export async function generateScheduleShareImage({
  eventsByDay,
  userName,
  timeZone,
  siteTitle,
}) {
  if (!eventsByDay?.length) {
    throw new Error('No events to share');
  }

  const theme = readTheme();
  const slots = partitionEventsForShareGrid(eventsByDay, timeZone);
  const promo = scheduleShareSiteLabel();
  const cellW = (CANVAS_WIDTH - PAD * 2 - GUTTER) / 2;

  const measureCanvas = document.createElement('canvas');
  measureCanvas.width = CANVAS_WIDTH;
  const measureCtx = measureCanvas.getContext('2d');
  const { height, cellH, tuesdayH } = layoutMetrics(slots, measureCtx, cellW, cellW - 36);

  const canvas = document.createElement('canvas');
  canvas.width = CANVAS_WIDTH;
  canvas.height = height;
  const ctx = canvas.getContext('2d');

  ctx.fillStyle = theme.bg;
  ctx.fillRect(0, 0, CANVAS_WIDTH, height);

  let y = PAD;
  drawHeader(ctx, theme, y, userName, siteTitle);
  y += HEADER_BLOCK;

  const gridX = PAD;
  const gridY = y;

  for (const q of QUADRANT_LAYOUT) {
    const x = gridX + q.col * (cellW + GUTTER);
    const cy = gridY + q.row * (cellH + GUTTER);
    drawQuadrant(ctx, theme, x, cy, cellW, cellH, q.label, slots[q.key].events);
  }

  y = gridY + cellH * 2 + GUTTER;

  if (slots.tuesdayAttending.events.length > 0) {
    drawTuesdayBonus(
      ctx,
      theme,
      PAD,
      y,
      CANVAS_WIDTH - PAD * 2,
      tuesdayH,
      slots.tuesdayAttending.events
    );
    y += tuesdayH + GUTTER;
  }

  drawFooter(ctx, theme, y, height, promo);

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
