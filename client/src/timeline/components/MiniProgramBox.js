import React from 'react';

const MiniProgramBox = ({ event, onClick }) => {
  const {
    title,
    short_title,
    formatted_start_time,
    formatted_end_time,
    ticket_price,
    ticket_tier,
    ticket_wave,
    venue,
    genres = [],
    top_artists = [],
    artists = [],
  } = event;

  const formatTime = (timeStr) => {
    const date = new Date(timeStr);
    return date
      .toLocaleTimeString([], {
        hour: 'numeric',
        minute: '2-digit',
        hour12: true,
      })
      .replace(':00', '')
      .replace(' ', '')
      .toLowerCase();
  };

  const start = formatTime(formatted_start_time);
  const end = formatTime(formatted_end_time);
  const displayTitle = short_title || title;
  const ticketLabel = ticket_price === '0.0' ? 'FREE' : `$${ticket_price}`;
  const allArtists = artists.length ? artists : top_artists;
  const bgColor = venue?.bg_color || '#ccc';
  const fontColor = venue?.font_color || '#000';

  let ticketTier = ticket_tier ? `– ${ticket_tier}` : '';
  if (ticket_wave) {
    const [current, total] = ticket_wave.split(' of ').map(Number);
    if (current === total) ticketTier = '– Final release';
  }

  return (
    <div onClick={onClick} style={{ cursor: 'pointer' }}>
      <div className="party-box">
        <div
          className="party-content"
          style={{
            backgroundColor: bgColor,
            color: fontColor,
            borderColor: bgColor,
            borderWidth: '3px',
          }}
        >
          <div className="title-wrapper">
            <p className="title">{displayTitle}</p>
          </div>

          <p className="time-venue">
            <span className="emoji">
              <i className="fa-solid fa-clock"></i>&nbsp;
            </span>
            <span className="time">
              {' '}
              {start}-{end}
            </span>
          </p>

          <div className="bottom-half">
            <div className="left-side" style={{ borderColor: fontColor }}>
              <p className="top-artists">
                <i className="fa-solid fa-headphones"></i>&nbsp;&nbsp;
                {allArtists.length > 0 ? (
                  allArtists.map((artist, i) => (
                    <span key={i} className="artist-name">
                      {artist.name}
                      {i < allArtists.length - 1 ? ', ' : ''}
                    </span>
                  ))
                ) : (
                  <span className="artist-name">TBA</span>
                )}
              </p>
              <p className="ticket-info">
                <span className="emoji">
                  <i className="fa-solid fa-ticket"></i>
                </span>
                &nbsp; {ticketLabel}
                <span className="tier">{ticketTier}</span>
              </p>
              <p className="genre-tags">
                {genres.map((genre, i) => (
                  <span
                    key={i}
                    className="genre-pill"
                    style={{
                      backgroundColor: genre.hex_color || '#ccc',
                      color: genre.font_color || '#fff',
                      borderColor: genre.hex_color,
                    }}
                  >
                    {genre.short_name || genre.name}
                  </span>
                ))}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MiniProgramBox;
