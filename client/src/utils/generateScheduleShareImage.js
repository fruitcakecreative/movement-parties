import { formatTime } from './eventDisplay';

const CANVAS_WIDTH = 1080;
const PADDING = 56;
const CONTENT_WIDTH = CANVAS_WIDTH - PADDING * 2;

const DEFAULT_THEME = {
  bg: '#141418',
  card: '#22222c',
  title: '#f5f5f7',
  text: '#d4d4dc',
  muted: '#9898a8',
  primary: '#e91e8c',
  attending: '#22c55e',
  interested: '#f59e0b',
  footerBg: '#1c1c24',
};

function readTheme() {
  if (typeof document === 'undefined') return DEFAULT_THEME;
  const root = document.documentElement;
  const style = getComputedStyle(root);
  const pick = (name, fallback) => {
    const v = style.getPropertyValue(name).trim();
    return v || fallback;
  };
  return {
    bg: pick('--color-background', DEFAULT_THEME.bg),
    card: pick('--color-bg-dark', DEFAULT_THEME.card),
    title: pick('--color-title', DEFAULT_THEME.title),
    text: pick('--color-text', DEFAULT_THEME.text),
    muted: pick('--color-text-light', DEFAULT_THEME.muted),
    primary: pick('--color-primary', DEFAULT_THEME.primary),
    attending: '#22c55e',
    interested: '#f59e0b',
    footerBg: pick('--color-bg-dark', DEFAULT_THEME.footerBg),
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

function wrapText(ctx, text, maxWidth) {
  if (!text) return [];
  const words = String(text).split(/\s+/);
  const lines = [];
  let line = '';
  for (const word of words) {
    const test = line ? `${line} ${word}` : word;
    if (ctx.measureText(test).width > maxWidth && line) {
      lines.push(line);
      line = word;
    } else {
      line = test;
    }
  }
  if (line) lines.push(line);
  return lines.length ? lines : [''];
}

function measureLayout(ctx, rows) {
  let y = PADDING;
  const gap = 12;
  const dayGap = 28;
  const sectionGap = 8;
  const eventPad = 16;
  const eventInner = CONTENT_WIDTH - eventPad * 2 - 8;

  y += 52; // main title
  y += 28; // subtitle
  y += 32;

  for (const row of rows) {
    if (row.type === 'day') {
      y += dayGap;
      ctx.font = 'bold 30px system-ui, -apple-system, sans-serif';
      y += 36;
    } else if (row.type === 'status') {
      y += sectionGap;
      ctx.font = '600 18px system-ui, -apple-system, sans-serif';
      y += 24;
    } else if (row.type === 'event') {
      const titleLines = wrapText(
        ctx,
        row.event.short_title || row.event.title || 'Event',
        eventInner - 36
      );
      ctx.font = '600 24px system-ui, -apple-system, sans-serif';
      const titleH = titleLines.length * 30;
      ctx.font = '400 20px system-ui, -apple-system, sans-serif';
      const meta = [row.event.venue?.name, row.timeLabel].filter(Boolean).join(' · ');
      const metaLines = wrapText(ctx, meta, eventInner - 36);
      const metaH = meta ? metaLines.length * 26 : 0;
      y += eventPad * 2 + titleH + metaH + gap;
    }
  }

  y += 24;
  y += 72; // footer
  return Math.ceil(y + PADDING);
}

function buildRows(eventsByDay, timeZone) {
  const rows = [];
  for (const [, dayData] of eventsByDay) {
    rows.push({ type: 'day', label: dayData.label });
    if (dayData.attending.length > 0) {
      rows.push({ type: 'status', label: 'Attending', tone: 'attending' });
      for (const event of dayData.attending) {
        rows.push({
          type: 'event',
          status: 'attending',
          event,
          timeLabel: eventTimeLabel(event, timeZone),
        });
      }
    }
    if (dayData.interested.length > 0) {
      rows.push({ type: 'status', label: 'Interested', tone: 'interested' });
      for (const event of dayData.interested) {
        rows.push({
          type: 'event',
          status: 'interested',
          event,
          timeLabel: eventTimeLabel(event, timeZone),
        });
      }
    }
  }
  return rows;
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

/**
 * Renders a shareable PNG of the user's schedule (attending + interested).
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
  const rows = buildRows(eventsByDay, timeZone);
  const promo = scheduleShareSiteLabel();
  const displayName = (userName || 'My').trim();
  const headerTitle = displayName.endsWith('s')
    ? `${displayName} schedule`
    : `${displayName}'s schedule`;
  const subtitle = siteTitle || process.env.REACT_APP_PAGE_TITLE || 'Movement Parties';

  const measureCanvas = document.createElement('canvas');
  measureCanvas.width = CANVAS_WIDTH;
  const measureCtx = measureCanvas.getContext('2d');
  const height = measureLayout(measureCtx, rows, theme);

  const canvas = document.createElement('canvas');
  canvas.width = CANVAS_WIDTH;
  canvas.height = height;
  const ctx = canvas.getContext('2d');

  ctx.fillStyle = theme.bg;
  ctx.fillRect(0, 0, CANVAS_WIDTH, height);

  let y = PADDING;

  ctx.fillStyle = theme.title;
  ctx.font = '800 42px system-ui, -apple-system, sans-serif';
  ctx.fillText(headerTitle, PADDING, y + 40);

  y += 52;
  ctx.fillStyle = theme.muted;
  ctx.font = '500 22px system-ui, -apple-system, sans-serif';
  ctx.fillText(subtitle, PADDING, y + 20);

  y += 28 + 32;

  const gap = 12;
  const dayGap = 28;
  const sectionGap = 8;
  const eventPad = 16;
  const eventInner = CONTENT_WIDTH - eventPad * 2 - 8;

  for (const row of rows) {
    if (row.type === 'day') {
      y += dayGap;
      ctx.fillStyle = theme.primary;
      ctx.fillRect(PADDING, y, 4, 28);
      ctx.fillStyle = theme.title;
      ctx.font = 'bold 30px system-ui, -apple-system, sans-serif';
      ctx.fillText(row.label, PADDING + 16, y + 24);
      y += 36;
    } else if (row.type === 'status') {
      y += sectionGap;
      ctx.fillStyle = row.tone === 'attending' ? theme.attending : theme.interested;
      ctx.font = '600 18px system-ui, -apple-system, sans-serif';
      ctx.fillText(row.label.toUpperCase(), PADDING, y + 16);
      y += 24;
    } else if (row.type === 'event') {
      const accent =
        row.status === 'attending' ? theme.attending : theme.interested;
      const title = row.event.short_title || row.event.title || 'Event';
      ctx.font = '600 24px system-ui, -apple-system, sans-serif';
      const titleLines = wrapText(ctx, title, eventInner - 36);
      const titleH = titleLines.length * 30;
      const meta = [row.event.venue?.name, row.timeLabel].filter(Boolean).join(' · ');
      ctx.font = '400 20px system-ui, -apple-system, sans-serif';
      const metaLines = meta ? wrapText(ctx, meta, eventInner - 36) : [];
      const metaH = metaLines.length * 26;
      const blockH = eventPad * 2 + titleH + metaH;

      roundRect(ctx, PADDING, y, CONTENT_WIDTH, blockH, 12);
      ctx.fillStyle = theme.card;
      ctx.fill();
      ctx.strokeStyle = `${accent}44`;
      ctx.lineWidth = 1;
      ctx.stroke();

      ctx.fillStyle = accent;
      ctx.font = '700 22px system-ui, -apple-system, sans-serif';
      ctx.fillText(row.status === 'attending' ? '✓' : '★', PADDING + eventPad, y + eventPad + 22);

      let innerY = y + eventPad;
      ctx.fillStyle = theme.title;
      ctx.font = '600 24px system-ui, -apple-system, sans-serif';
      for (const line of titleLines) {
        ctx.fillText(line, PADDING + eventPad + 28, innerY + 22);
        innerY += 30;
      }
      if (metaLines.length) {
        ctx.fillStyle = theme.muted;
        ctx.font = '400 20px system-ui, -apple-system, sans-serif';
        for (const line of metaLines) {
          ctx.fillText(line, PADDING + eventPad + 28, innerY + 20);
          innerY += 26;
        }
      }
      y += blockH + gap;
    }
  }

  y += 24;
  const footerH = 72;
  ctx.fillStyle = theme.footerBg;
  ctx.fillRect(0, height - footerH - PADDING, CANVAS_WIDTH, footerH + PADDING);
  ctx.fillStyle = theme.muted;
  ctx.font = '500 20px system-ui, -apple-system, sans-serif';
  const promoW = ctx.measureText(promo).width;
  ctx.fillText(promo, (CANVAS_WIDTH - promoW) / 2, height - PADDING - 28);
  ctx.fillStyle = theme.primary;
  ctx.font = '600 18px system-ui, -apple-system, sans-serif';
  const tagline = 'Save your lineup →';
  const tagW = ctx.measureText(tagline).width;
  ctx.fillText(tagline, (CANVAS_WIDTH - tagW) / 2, height - PADDING - 8);

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
