export default function formatVenueName(venue) {
  if (typeof venue === 'string') {
    return venue
      .toLowerCase()
      .replace(/[\s']/g, '')
      .replace(/[^a-z0-9]/g, '');
  } else {
    console.error('Expected a string for venue name, but received:', venue);
    return 'unknownvenue';
  }
}
