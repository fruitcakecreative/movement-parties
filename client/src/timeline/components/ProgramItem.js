import React, { useState } from 'react';
import { ProgramBox, ProgramContent, useProgram } from '@nessprim/planby-pro';
import formatVenueName from '../../utils/formatVenueName';
import ProgramModal from './modals/ProgramModal';
import { useIsMobile } from '../hooks/useIsMobile';

const ProgramItem = ({ program, scrollLeft, ...rest }) => {
  const [isOpen, setIsOpen] = useState(false);
  const { styles } = useProgram({ program, ...rest });
  const {
    title,
    short_title,
    start_time,
    end_time,
    bg_color,
    font_color,
    ticket_label,
    ticket_tier,
    genres = [],
    top_artists = [],
    venue = [],
  } = program.data;

  const isMobile = useIsMobile();

  const displayTitle = isMobile && short_title ? short_title : title;

  //calculated styles for marquee moving title on long events
  const programLeft = program.position?.left || 0;
  const titleOffset = Math.max(0, scrollLeft - programLeft);
  const clampedOffset = Math.min(titleOffset, program.position.width - 100);
  const maxTitleWidth = program.position.width - (8 + clampedOffset + 12);

  const openModal = () => {
    document.body.style.overflow = 'hidden';
    setIsOpen(true);
  };

  const closeModal = () => {
    document.body.style.overflow = '';
    setIsOpen(false);
  };

  return (
    <>
      <ProgramBox
        width={styles.width}
        style={styles.position}
        className={`party-box ${formatVenueName(venue.name)}`}
        onClick={openModal}
      >
        <ProgramContent
          width={styles.width}
          className="party-content"
          style={{
            backgroundColor: bg_color,
            color: font_color,
            borderColor: bg_color,
            borderWidth: '3px',
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
            <span className="tooltip">{title}</span>
          </div>

          <div className="bottom-half">
            <div className="left-side" style={{ borderColor: font_color }}>
              <p className="hide-m top-artists">
                <i className="fa-solid fa-headphones"></i>&nbsp;
                {top_artists.length > 0 ? (
                  top_artists.map((artist, i) => (
                    <span key={`${artist.id}-${i}`} className="artist-name">
                      {artist.name}
                      {i < top_artists.length - 1 ? ', ' : ''}
                    </span>
                  ))
                ) : (
                  <span className="artist-name">TBA</span>
                )}
              </p>
              <p className="genre-tags">
                {genres.map((genre, i) => (
                  <span
                    key={genre.id}
                    className="genre-pill"
                    style={{
                      backgroundColor: genre.hex_color || '#ccc',
                      color: genre.font_color || '#fff',
                    }}
                  >
                    {genre.short_name || genre.name}
                  </span>
                ))}
              </p>
            </div>

            <div className="right-side" style={{ borderColor: font_color }}>
              <p className="time-venue">
                <span className="hide-m emoji">
                  <i className="fa-solid fa-clock"></i>&nbsp;
                </span>
                <span className="hide-m time">
                  {' '}
                  {start_time}-{end_time}&nbsp;
                </span>
                <span className="hide-m emoji">
                  {' '}
                  <i className="fa-solid fa-map-pin"></i>&nbsp;
                </span>
                <span className="hide-m venue">{venue.name}</span>
              </p>
              <p className={`hide-m ${ticket_label}`}>
                <span className="emoji">
                  <i className="fa-solid fa-ticket"></i>
                </span>{' '}
                {ticket_label}
                <span className="tier"> {ticket_tier}</span>
              </p>
            </div>
          </div>
        </ProgramContent>
      </ProgramBox>

      <ProgramModal isOpen={isOpen} onClose={closeModal} data={program.data} />
    </>
  );
};

export default ProgramItem;
