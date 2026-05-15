import React from "react";
import { Link, useLocation } from "react-router-dom";
import { Disclosure, DisclosureButton, DisclosurePanel } from "@headlessui/react";

const siteTitle = process.env.REACT_APP_PAGE_TITLE || "Movement Parties";

const navLinks = [
  { to: "/profile", label: "Profile" },
  { to: "/", label: "Event Timelines" },
];

function linkIsActive(pathname, to) {
  if (to === "/") return pathname === "/";
  return pathname === to;
}

function MainHeader() {
  const { pathname } = useLocation();

  return (
    <header className="app-site-header" role="banner">
      <div className="container app-site-header__inner">
        <h1 className="app-site-header__brand">
          <Link to="/">{siteTitle}</Link>
        </h1>
        <Disclosure as="nav" className="app-site-header__nav" aria-label="Site">
          {({ close }) => (
            <>
              <DisclosureButton
                type="button"
                className="app-site-header__menu-trigger"
                aria-label="Open menu"
              >
                <i className="fa-solid fa-bars" aria-hidden />
              </DisclosureButton>
              <DisclosurePanel className="app-site-header__panel">
                {navLinks.map(({ to, label }) => {
                  const active = linkIsActive(pathname, to);
                  return (
                    <Link
                      key={to}
                      to={to}
                      className={
                        active
                          ? "app-site-header__panel-link app-site-header__panel-link--active"
                          : "app-site-header__panel-link"
                      }
                      aria-current={active ? "page" : undefined}
                      onClick={() => close()}
                    >
                      {label}
                    </Link>
                  );
                })}
              </DisclosurePanel>
            </>
          )}
        </Disclosure>
      </div>
    </header>
  );
}

export default MainHeader;
