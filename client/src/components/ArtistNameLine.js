import React from 'react';

/** Artist name with optional pronouns for list-style layouts. */
function ArtistNameLine({ artist }) {
  const raw = artist?.pronouns;
  const pronouns =
    raw != null && String(raw).trim() !== '' ? String(raw).trim() : '';
  return (
    <>
      {artist?.name}
      {pronouns ? <span className="artist-pronouns"> ({pronouns})</span> : null}
    </>
  );
}

export default ArtistNameLine;
