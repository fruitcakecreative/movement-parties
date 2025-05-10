const EventModalStandalone = ({ event, venueHex, fontHex }) => {

  const {
    event_url,
    ticket_url,
    description,
    event_bg_color,
    event_font_color,
    ticket_price,
    ticket_tier,
    ticket_wave,
    genres = [],
    top_artists = [],
    artists = [],
    venue,
    venue_hex,
    venue_font_hex,
    formatted_start_time,
    formatted_end_time,
  } = event;

  const formatTime = (timeStr) => {
    const date = new Date(timeStr);
    return date
      .toLocaleTimeString([], {
        hour: "numeric",
        minute: "2-digit",
        hour12: true,
      })
      .replace(":00", "")
      .replace(" ", "")
      .toLowerCase();
  };

  const sinceTime = formatTime(formatted_start_time);
  const tillTime = formatTime(formatted_end_time);
  const ticketLabel = ticket_price === "0.0" ? "FREE" : `$${ticket_price}`;

  let ticketTier = ticket_tier ? `– ${ticket_tier}` : "";
  if (ticket_wave) {
    const [current, total] = ticket_wave.split(" of ").map(Number);
    if (current === total) ticketTier = "– Final release";
  }
  const venueName = typeof venue === "string" ? venue : venue?.name || "";
  const isTBA = venueName.toLowerCase().includes("tba") || venueName.toLowerCase().includes("secret");

  const allArtists = artists.length ? artists : top_artists;

  return (
  <div
    className="standalone-program-modal"
    style={{ color: 'white' }}
  >

      <p className="venue"><i className="fa-solid fa-map-pin"></i> {venueName}</p>
      <p className="time"><i className="fa-solid fa-clock"></i> {sinceTime}–{tillTime}</p>

      <p className="tickets">
        <span className="emoji"><i className="fa-solid fa-ticket"></i></span> {ticketLabel}
        <span className="tier"> {ticketTier}</span>
      </p>



      {ticket_url ? (
        <>
          <a className="btn t" style={{ backgroundColor: venueHex, color: fontHex }} href={ticket_url} target="_blank" rel="noopener noreferrer">Ticket Link</a>
          <a className="btn t" style={{ backgroundColor: venueHex, color: fontHex }} href={event_url} target="_blank" rel="noopener noreferrer">Event Link</a>
        </>
      ) : (
        <a className="btn test" id={venueHex} href={event_url} style={{ backgroundColor: venueHex, color: fontHex }} target="_blank" rel="noopener noreferrer">Ticket/Event Link</a>
      )}

      {allArtists.length > 0 && (
        <div className="artists-list">
          <p><i className="fa-solid fa-headphones"></i> Artists:</p>
          <ul>
            {allArtists.map((artist, i) => (
              <li key={i}>{artist.name}</li>
            ))}
          </ul>
        </div>
      )}

      <p className="genre-tags">
        {genres.map((genre, i) => (
          <span
            key={i}
            className={`genre-pill ${genre.name}`}
            style={{
              borderColor: genre.hex_color,
              backgroundColor: genre.hex_color || "#ccc",
              color: genre.font_color || "#fff",
              marginRight: 6,
            }}
          >
            {genre.short_name || genre.name}
          </span>
        ))}
      </p>

      {description && (
        <p
          className="event-desc"
          dangerouslySetInnerHTML={{
            __html: description.replace(/\n/g, "<br/>"),
          }}
        />
      )}
    </div>
  );
};

export default EventModalStandalone;
