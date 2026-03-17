/**
 * Formats description text for HTML display.
 * Converts newlines to <br/> so paragraphs and line breaks render correctly.
 */
export function formatDescription(description) {
  if (!description || typeof description !== 'string') return '';
  return description
    .replace(/\r\n/g, '\n')
    .replace(/\r/g, '\n')
    .replace(/\n/g, '<br/>');
}
