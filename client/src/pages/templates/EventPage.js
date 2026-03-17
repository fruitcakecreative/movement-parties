import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { fetchEventById } from '../../services/api';
import { getEventDisplayData } from '../../utils/eventDisplay';
import { formatDescription } from '../../utils/formatDescription';

const EventPage = () => {
  const { id } = useParams();
  const [event, setEvent] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    const loadEvent = async () => {
      try {
        const data = await fetchEventById(id);
        setEvent(data);
      } catch (error) {
        console.error('Error fetching event:', error);
      } finally {
        setIsLoaded(true);
      }
    };

    loadEvent();
  }, [id]);

  if (!isLoaded) return <p>Loading event...</p>;
  if (!event) return <p>Event not found</p>;

  const eventDisplay = getEventDisplayData(event);

  return (
    <div className="event-page container">
      <div
        className="party-content"
        style={{  
        }}
      >
        <h1 className="title">{eventDisplay.displayTitle}</h1>

        <p className="event-date">
          <i className="fa-solid fa-calendar"></i> {eventDisplay.dateLabel}
        </p>

        <p className="time">
          <i className="fa-solid fa-clock"></i> {eventDisplay.start}–{eventDisplay.end}
        </p>


        <p className="venue">
          <i className="fa-solid fa-map-pin"></i> {eventDisplay.venue?.name}
        </p>

        {eventDisplay.venue?.location && <p>{eventDisplay.venue.location}</p>}
        {eventDisplay.venue?.address && <p>{eventDisplay.venue.address}</p>}

        <p className="tickets">
          <i className="fa-solid fa-ticket"></i> {eventDisplay.ticketLabel}{' '}
          <span className="tier">{eventDisplay.ticketTier}</span>
        </p>

        {eventDisplay.age && <p className="age">Age: {eventDisplay.age}</p>}

        {!!eventDisplay.genres.length && (
          <div className="genre-tags">
            {eventDisplay.genres.map((genre) => (
              <span
                key={genre.id}
                className="genre-pill"
                style={{
                  backgroundColor: genre.hex_color || '#ccc',
                  color: genre.font_color || '#fff',
                  borderColor: genre.hex_color || '#ccc',
                  marginRight: 6,
                }}
              >
                {genre.short_name || genre.name}
              </span>
            ))}
          </div>
        )}

        <div className="artists-list">
          <p>
            <i className="fa-solid fa-headphones"></i> Artists:
          </p>
          {eventDisplay.artists.length > 0 ? (
            <ul>
              {eventDisplay.artists.map((artist) => (
                <li key={artist.id}>{artist.name}</li>
              ))}
            </ul>
          ) : (
            <p>TBA</p>
          )}
        </div>

        <div className="event-links">
          {eventDisplay.ticketUrl && (
            <a
              className="btn"
              style={{
                backgroundColor: eventDisplay.cardFont,
                color: eventDisplay.cardBg,
              }}
              href={eventDisplay.ticketUrl}
              target="_blank"
              rel="noopener noreferrer"
            >
              Ticket Link
            </a>
          )}

          {eventDisplay.eventUrl && (
            <a
              className="btn"
              style={{
                backgroundColor: eventDisplay.cardFont,
                color: eventDisplay.cardBg,
              }}
              href={eventDisplay.eventUrl}
              target="_blank"
              rel="noopener noreferrer"
            >
              Event Link
            </a>
          )}
        </div>

        {eventDisplay.description && (
          <div
            className="event-desc"
            dangerouslySetInnerHTML={{
              __html: formatDescription(eventDisplay.description),
            }}
          />
        )}
      </div>
      {eventDisplay.imageSrc && (
        <div className="event-hero-image">
          <img src={eventDisplay.imageSrc} alt={eventDisplay.displayTitle} />
        </div>
      )}

    </div>
  );
};

export default EventPage;
