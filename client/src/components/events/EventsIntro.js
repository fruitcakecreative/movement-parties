import React from 'react';

function EventsIntro({
  lastUpdated,
  totalCount,
  pastEventsCount,
  eventsByDayStats = [],
  isLoaded,
}) {
  const showMeta =
    isLoaded &&
    (lastUpdated != null ||
      totalCount != null ||
      pastEventsCount != null ||
      (eventsByDayStats && eventsByDayStats.length > 0));

  return (
    <div className="section info-con">
      <div className="container">
        {showMeta && (
          <div className="events-meta mb-sm" style={{ opacity: 0.9, fontSize: '0.9rem' }}>
            {lastUpdated && (
              <p>
                <span>Last update:</span>{' '}
                {new Date(lastUpdated).toLocaleString('en-US', {
                  dateStyle: 'medium',
                  timeStyle: 'short',
                })}
              </p>
            )}
            {pastEventsCount != null && (
              <p class="hide">
                <span>Past events (archived):</span> {pastEventsCount}
              </p>
            )}
            {totalCount != null && (
              <p>
                <span>Future events:</span> {totalCount}
              </p>
            )}
            {eventsByDayStats.length > 0 && (
              <div className="events-meta-by-day mt-xs">
                <ul
                  style={{
                    margin: 0,
                    paddingLeft: '1.1rem',
                    listStyle: 'disc',
                    textAlign: 'left',
                  }}
                >
                </ul>
              </div>
            )}
          </div>
        )}
        <h3 className="mini-heading">
          Relevant Info <i className="fa-solid fa-circle-info"></i>
        </h3>
        <ul>
          <li>
            The site scrapes basic event data from various major platforms. All other events + specific event info that
            isn&apos;t scrapable is manually updated by me.
            <b>
              {' '}
              So please reach out (via socials) if you don&apos;t see an event that should be included
              or if you notice any incorrect info.
            </b>
          </li>
          <li>
            The timelines are mobile-friendly, but more info is available on the desktop version
            of the site and it is a bit easier to navigate.
          </li>
          <li>
            You can click on both events on the timeline and venues on the left for more
            information. I am still updating all the venue info so be patient with me there{' '}
            <i className="fa-regular fa-heart"></i>
          </li>
        </ul>
      </div>

      <div className="container">
        <h3 className="mini-heading">
          Connect with Me <i className="fa-solid fa-heart"></i>
        </h3>

        <div className="socials flex-wrap">
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="https://instagram.com/carlymarsh"
          >
            <i className="highlight icon fa-brands fa-instagram"></i> Instagram
          </a>
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="https://facebook.com/carly.marsh1"
          >
            <i className="highlight icon fa-brands fa-square-facebook"></i> Facebook
          </a>
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="mailto:carlypmarsh@gmail.com"
          >
            <i className="highlight icon fa-solid fa-envelope"></i> carlypmarsh@gmail.com
          </a>
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="https://www.linkedin.com/in/carly-marsh-a4735316a/"
          >
            <i className="highlight icon fa-brands fa-linkedin"></i> LinkedIn *sigh*
          </a>
        </div>
      </div>

      <div className="container">
        <h3 className="mini-heading">
          Support the Cause <i className="fa-solid fa-handshake-angle"></i>
        </h3>

        <p className="mb-sm">
          I made this out of pure love for the party and expect nothing in return. But, I do pay
          for the domain, server and software costs. If you&apos;d like to show me some love or buy
          me a coffee for my efforts, I wouldn&apos;t mind <i className="fa-regular fa-heart"></i>
        </p>

        <div className="flex mb-sm">
          <a className="button" target="_blank" rel="noreferrer" href="https://venmo.com/u/CarlyMarsh7">
            Venmo
          </a>
          <a className="button" target="_blank" rel="noreferrer" href="https://cash.app/$carlymarsh7">
            CashApp
          </a>
          <a className="button" target="_blank" rel="noreferrer" href="https://paypal.me/carlypmarsh">
            PayPal
          </a>
        </div>

        <p>
          <span className="highlight bold">carlypmarsh@gmail.com</span>
          <br />
          <span className="etrans-blurb">
            e-transfer email for my fellow Canadians{' '}
            <i className="fa-brands fa-canadian-maple-leaf"></i>
          </span>
        </p>
      </div>
    </div>
  );
}

export default EventsIntro;
