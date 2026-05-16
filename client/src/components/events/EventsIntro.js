import React from 'react';
import { Link, useLocation } from 'react-router-dom';

function EventsIntro({
  lastUpdated,
  totalCount,
  pastEventsCount,
  isLoaded,
}) {
  const showMeta =
    isLoaded &&
    (lastUpdated != null || totalCount != null || pastEventsCount != null);

  const location = useLocation();
  const hasAccount =
    typeof window !== 'undefined' && !!window.localStorage.getItem('user');
  void location.pathname;

  return (
    <div className="section info-con" id="site-guide">
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
              <p className="hide">
                <span>Past events (archived):</span> {pastEventsCount}
              </p>
            )}
            {totalCount != null && (
              <p>
                <span>Future events:</span> {totalCount}
              </p>
            )}
          </div>
        )}
        <p className="mb-lg" style={{ lineHeight: 1.45, fontSize: '0.9rem', opacity: 0.88 }}>
          Welcome! This website is a community-driven, unbiased, all-inclusive event listing hub for events happening in Detroit on Memorial Day weekend. 
          I auto-import events from Resident Advisor twice a day, otherwise everything is manually entered by me. If you see any wrong information or something is missing, please reach out via socials.
        </p>
        <div className="mb-sm">
          <a
            className="button mb-sm"
            href="https://instagram.com/movementparties"
            target="_blank"
            rel="noopener noreferrer"
          >
            <i className="fa-brands fa-instagram" aria-hidden /> Follow @movementparties on Insta
          </a>
        </div>
        <h4 className="mini-heading mt-lg">
          What&apos;s new{' '}
          <i className="fa-solid fa-circle-info" aria-hidden />
        </h4>
        <p className="mb-xs" style={{ lineHeight: 1.5, maxWidth: '40rem' }}>
          You can create a <strong>user profile</strong> now, save events you're interested in or attending, and add friends to see what they will be up to. 
        </p>
        <div
          className="events-intro-actions mb-sm flex flex-wrap"
          style={{ gap: '10px', alignItems: 'center' }}
        >
          {hasAccount ? (
            <Link to="/profile" className="button">
              View Your Profile
            </Link>
          ) : (
            <>
              <Link to="/signup" className="button">
                Sign Up
              </Link>
              <Link to="/login" className="button button--secondary">
                Log in
              </Link>
            </>
          )}
        </div>
      </div>

      <div className="container">
        <h4 className="mini-heading">
          Connect with Me <i className="fa-solid fa-heart" aria-hidden />
        </h4>

        <div className="socials flex-wrap">
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="https://instagram.com/carlymarsh"
          >
            <i className="highlight icon fa-brands fa-instagram" aria-hidden /> Instagram
          </a>
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="https://facebook.com/carly.marsh1"
          >
            <i className="highlight icon fa-brands fa-square-facebook" aria-hidden /> Facebook
          </a>
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="mailto:carlypmarsh@gmail.com"
          >
            <i className="highlight icon fa-solid fa-envelope" aria-hidden /> carlypmarsh@gmail.com
          </a>
          <a
            className="flex-center"
            target="_blank"
            rel="noreferrer"
            href="https://www.linkedin.com/in/carly-marsh-a4735316a/"
          >
            <i className="highlight icon fa-brands fa-linkedin" aria-hidden /> LinkedIn *sigh*
          </a>
        </div>
      </div>

      <div className="container">
        <h4 className="mini-heading">
          Support the Cause <i className="fa-solid fa-handshake-angle" aria-hidden />
        </h4>

        <p className="mb-sm">
          I made this out of pure love for the party and expect nothing in return. But, I do pay
          for the domain, server and software costs. If you&apos;d like to show me some love or buy
          me a coffee for my efforts, I wouldn&apos;t mind <i className="fa-regular fa-heart" aria-hidden />
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
            <i className="fa-brands fa-canadian-maple-leaf" aria-hidden />
          </span>
        </p>
      </div>
    </div>
  );
}

export default EventsIntro;
