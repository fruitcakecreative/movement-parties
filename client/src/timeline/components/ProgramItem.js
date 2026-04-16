import React from 'react';
import { ProgramBox, ProgramContent, useProgram } from '@nessprim/planby-pro';
import formatVenueName from '../../utils/formatVenueName';
import { useIsMobile } from '../hooks/useIsMobile';
import { getEventDisplayData } from '../../utils/eventDisplay';
import {
  filterArtistsHideHePresenting,
  programSheTheyPctClassName,
  sheTheyForwardLineupPercent,
} from '../../utils/pronounDisplay';

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

  const sheTheyPct =
    sheTheyForwardTimeline ? sheTheyForwardLineupPercent(displayArtists) : null;

  const sheTheyUnknown = sheTheyForwardTimeline && sheTheyPct === null;
  const sheTheyZero = sheTheyForwardTimeline && sheTheyPct === 0;
  const sheTheyCompact = sheTheyUnknown || sheTheyZero;

  const useSheTheyShell = sheTheyForwardTimeline;

  const sheTheyFilled =
    sheTheyForwardTimeline && sheTheyPct != null && sheTheyPct > 0;

  const sheTheyHigh =
    sheTheyForwardTimeline && sheTheyPct != null && sheTheyPct >= 75;

  /** Card rim: below 50% subtle, 50–74 stronger; 75%+ uses `party-content--she-they-high`. */
  const sheTheyFilledBandClass =
    sheTheyFilled && sheTheyPct != null
      ? sheTheyPct < 50
        ? 'party-content--she-they-band-lt50'
        : sheTheyPct < 75
          ? 'party-content--she-they-band-50-74'
          : ''
      : '';

  const showSheTheyFill = sheTheyFilled;

  /** Extra width so rounded corners don’t make the bar look short (~+5%). */
  const sheTheyFillWidthPct = sheTheyFilled
    ? Math.min(100, sheTheyPct + 5)
    : 0;

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
      className={[
        'party-box',
        formatVenueName(venueName),
        sheTheyHigh ? 'party-box--she-they-spotlight' : '',
        sheTheyCompact ? 'party-box--she-they-compact' : '',
      ]
        .filter(Boolean)
        .join(' ')}
      onClick={handleClick}
    >
    <ProgramContent
        width={styles.width}
        className={[
          'party-content',
          useSheTheyShell && 'party-content--she-they-progress',
          sheTheyUnknown && 'party-content--she-they-unknown',
          sheTheyZero && 'party-content--she-they-zero',
          sheTheyFilled && 'party-content--she-they-filled',
          sheTheyFilledBandClass,
          sheTheyCompact && 'party-content--she-they-compact',
          sheTheyHigh && 'party-content--she-they-high',
        ]
          .filter(Boolean)
          .join(' ')}
        style={{
          '--card-bg': useSheTheyShell ? undefined : cardBg,
          '--card-font': useSheTheyShell ? undefined : cardFont,
          position: 'relative',
          overflow: showSheTheyFill ? 'hidden' : useSheTheyShell ? 'visible' : undefined,
          backgroundColor: useSheTheyShell ? undefined : cardBg,
          color: useSheTheyShell ? undefined : cardFont,
        }}
      >
        {showSheTheyFill && (
          <div
            className="program-she-they-fill"
            aria-hidden
            style={{ width: `${sheTheyFillWidthPct}%` }}
          />
        )}
        <div
          className={`title-wrapper${sheTheyCompact ? ' title-wrapper--she-they-compact' : ''}`}
          style={{
            position: 'absolute',
            zIndex: 1,
            left: `${8 + clampedOffset}px`,
            top:
              sheTheyForwardTimeline && (sheTheyPct != null || sheTheyUnknown)
                ? sheTheyCompact
                  ? 2
                  : 4
                : 8,
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            maxWidth: `${maxTitleWidth}px`,
          }}
        >
          {sheTheyUnknown && (
            <p className="program-she-they-pct program-she-they-pct--unknown">Lineup TBA</p>
          )}
          {!sheTheyUnknown && sheTheyForwardTimeline && sheTheyPct != null && (
            <p className={programSheTheyPctClassName(sheTheyPct)}>
              {sheTheyPct}% She/They artists
            </p>
          )}
          <p className="title">{displayTitle}</p>
          <span className="tooltip">{fullTitle}</span>
        </div>

        {!sheTheyCompact && (
          <div
            className={`bottom-half${sheTheyForwardTimeline ? ' bottom-half--she-they-minimal' : ''}`}
            style={{ position: 'relative', zIndex: 1 }}
          >
            <div className="left-side">
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

              {!sheTheyForwardTimeline && (
                <>
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
                </>
              )}
            </div>

            {!sheTheyForwardTimeline && (
              <div className="right-side">
                <p className="time-venue">
                  <span className="m-hide emoji">
                    <i className="fa-solid fa-clock"></i>&nbsp;
                  </span>
                  <span className="m-hide time">
                    {displayStartTime}-{displayEndTime}&nbsp;
                  </span>
                  <span className="m-hide emoji">
                    <i className="fa-solid fa-map-pin"></i>&nbsp;
                  </span>
                  <span className="m-hide venue">{venueName}</span>
                </p>

                <p className={`m-hide ${ticketLabel}`}>
                  <span className="emoji">
                    <i className="fa-solid fa-ticket"></i>
                  </span>{' '}
                  {ticketLabel}
                  <span className="tier"> {ticketTier}</span>
                </p>
              </div>
            )}
          </div>
        )}
      </ProgramContent>
    </ProgramBox>
  );
};

export default ProgramItem;
