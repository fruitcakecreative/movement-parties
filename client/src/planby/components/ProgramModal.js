import ModalLayout from "../../components/ModalLayout";
import formatVenueName from "../../helpers/formatVenueName"


const EventModal = ({isOpen, onClose, data}) => {

    const {
      id,
      title,
      start_time,
      end_time,
      event_url,
      ticket_url,
      description,
      bg_color,
      font_color,
      event_age,
      ticket_label,
      ticket_tier,
      genres = [],
      top_artists = [],
      venue =[],
    } = data;

    const friends = [];

  return (

    <ModalLayout
      isOpen={isOpen}
      onClose={onClose}
      parent='event'
      className={formatVenueName(data.venue.name)}
      innerStyle={{ borderColor: data.bg_color, scrollBarColor: bg_color }}
      topRowStyle={{ borderColor: bg_color, backgroundColor: bg_color, color: font_color }}
      header={<h3 style={{ color: font_color }}>{title}</h3>}
    >



      <p className="venue"><i className="fa-solid fa-map-pin"></i> {venue.name}</p>
      <p className="time"><i className="fa-solid fa-clock"></i> {start_time}-{end_time}</p>
      <p className="tickets">
        <span className="emoji"><i className="fa-solid fa-ticket"></i></span> {ticket_label}
        <span className="tier"> — {ticket_tier}</span>
      </p>

      {event_age && (
          <p className="age">
            <i className="fa-solid fa-id-card"></i> {event_age}
          </p>
        )}

    {friends.length > 0 && (
      <p><i className="fa-solid fa-people-group"></i> Friends Attending: &nbsp;
        {friends.map(f => f.username).join(", ")}</p>
      )}

      {ticket_url ? (
        <>
          <a className="btn" style={{ backgroundColor: bg_color, color: font_color }} href={ticket_url} target="_blank" rel="noopener noreferrer">Ticket Link</a>
          <a className="btn" style={{ backgroundColor: bg_color, color: font_color }} href={event_url} target="_blank" rel="noopener noreferrer">Event Link</a>
        </>
      ) : (
        <a className="btn" href={event_url} style={{ backgroundColor: bg_color, color: font_color }} target="_blank" rel="noopener noreferrer">Ticket/Event Link</a>
      )}

      {top_artists.length > 0 && (
        <div className="artists-list">
          <p><i className="fa-solid fa-headphones"></i> Artists:</p>
          <ul>
            {top_artists.map((artist, i) => (
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
              color: genre.font_color || "#fff"
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
            __html: description.replace(/\n/g, '<br/>')
          }}
        />
      )}

    </ModalLayout>
  )
}

export default EventModal
