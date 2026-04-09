import React from 'react';
import { ProgramBox, ProgramContent, useProgram } from '@nessprim/planby-pro';
import formatVenueName from '../../utils/formatVenueName';
import { useIsMobile } from '../hooks/useIsMobile';
import { getEventDisplayData } from '../../utils/eventDisplay';
import { filterArtistsHideHePresenting } from '../../utils/pronounDisplay';

const ProgramItem = ({ program, scrollLeft, openEvent, sheTheyForwardTimeline = false, ...rest }) => {
  const { styles } = useProgram({ program, ...rest });
  const isMobile = useIsMobile();
  const isShortMobileEvent = isMobile && (program.position?.width || 0) <= 210;
  const isShortEvent = (program.position?.width || 0) <= 300;

  const {
    fullTitle,
    displayTitle,
    visibleGenres,
    compactStartTime,
    compactEndTime,
    displayStartTime,
    displayEndTime,
    displayArtists,
    venueName,
    ticketLabel,
    ticketTier,
    cardBg,
    cardFont,
  } = getEventDisplayData(program.data, { isMobile, isShortMobileEvent, isShortEvent });

  const artistsOnCard = sheTheyForwardTimeline
    ? filterArtistsHideHePresenting(displayArtists)
    : displayArtists;

  const programLeft = program.position?.left || 0;
  const titleOffset = Math.max(0, scrollLeft - programLeft);
  const clampedOffset = Math.min(titleOffset, program.position.width - 100);
  const maxTitleWidth = program.position.width - (8 + clampedOffset + 12);

  const handleClick = () => {
    openEvent?.(program.data.event_id || program.data.id);
  };

  return (
    <ProgramBox
      width={styles.width}
      style={styles.position}
      className={`party-box ${formatVenueName(venueName)}`}
      onClick={handleClick}
    >
    <ProgramContent
        width={styles.width}
        className="party-content"
        style={{
          '--card-bg': cardBg,
          '--card-font': cardFont,
          backgroundColor: cardBg,
          color: cardFont,
          border: 'none',
        }}
      >
        <div
          className="title-wrapper"
          style={{
            position: 'absolute',
            left: `${8 + clampedOffset}px`,
            top: 8,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            maxWidth: `${maxTitleWidth}px`,
          }}
        >
          <p className="title">{displayTitle}</p>
          <span className="tooltip">{fullTitle}</span>
        </div>

        <div className="bottom-half">
          <div className="left-side" style={{ borderColor: cardFont }}>
            <p className="d-hide top-artists">
              <i className="fa-solid fa-headphones"></i>&nbsp;
              {artistsOnCard.length > 0 ? (
                artistsOnCard.map((artist, i) => (
                  <span key={`${artist.id}-${i}`} className="artist-name">
                    {artist.name}
                    {i < artistsOnCard.length - 1 ? ', ' : ''}
                  </span>
                ))
              ) : (
                <span className="artist-name">TBA</span>
              )}
            </p>

            <div className="genre-tags">
              <div className="progam-pills">
                {visibleGenres.slice(0, 3).map((genre) => (
                  <span
                    key={genre.id}
                    className={`genre-pill ${genre.id}`}
                    style={{
                      backgroundColor: genre.hex_color || '#ccc',
                      color: genre.font_color || '#000',
                    }}
                  >
                    {genre.short_name || genre.name}
                  </span>
                ))}
              </div>

              <div>
                <span className="d-hide time time-mobile flex-center">
                  <i className="fa-solid fa-clock"></i>{' '}
                  {compactStartTime}-{compactEndTime}&nbsp;
                </span>
              </div>
            </div>
          </div>

          <div className="right-side" style={{ borderColor: cardFont }}>
            <p className="time-venue">
              <span className="hide-m emoji">
                <i className="fa-solid fa-clock"></i>&nbsp;
              </span>
              <span className="hide-m time">
                {displayStartTime}-{displayEndTime}&nbsp;
              </span>
              <span className="hide-m emoji">
                <i className="fa-solid fa-map-pin"></i>&nbsp;
              </span>
              <span className="hide-m venue">{venueName}</span>
            </p>

            <p className={`hide-m ${ticketLabel}`}>
              <span className="emoji">
                <i className="fa-solid fa-ticket"></i>
              </span>{' '}
              {ticketLabel}
              <span className="tier"> {ticketTier}</span>
            </p>
          </div>
        </div>
      </ProgramContent>
    </ProgramBox>
  );
};

export default ProgramItem;
