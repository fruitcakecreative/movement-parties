import React, { useEffect, useState } from "react";
import { Link, useLocation } from "react-router-dom";
import { Disclosure, DisclosureButton, DisclosurePanel } from "@headlessui/react";

const siteTitle = process.env.REACT_APP_PAGE_TITLE || "Movement Parties";

function MainHeader() {
  const location = useLocation();
  const [hasSessionUser, setHasSessionUser] = useState(
    () => typeof window !== "undefined" && !!localStorage.getItem("user")
  );

  useEffect(() => {
    setHasSessionUser(!!localStorage.getItem("user"));
  }, [location.pathname]);

  const accountHref = hasSessionUser ? "/profile" : "/login";
  const accountLabel = hasSessionUser ? "Profile" : "Login";

  return (
    <header className="app-site-header" role="banner">
      <div className="container app-site-header__inner">
        <h1 className="app-site-header__brand">
          <Link to="/">{siteTitle}</Link>
        </h1>
        <Disclosure as="nav" className="app-site-header__nav">
          {({ close }) => (
            <>
              <DisclosureButton
                type="button"
                className="app-site-header__menu-trigger"
                aria-label="Menu"
              >
                <i className="fa-solid fa-bars" aria-hidden />
              </DisclosureButton>
              <DisclosurePanel className="app-site-header__panel">
                <Link
                  to={accountHref}
                  className="app-site-header__panel-link"
                  onClick={() => close()}
                >
                  {accountLabel}
                </Link>
              </DisclosurePanel>
            </>
          )}
        </Disclosure>
      </div>
    </header>
  );
}

export default MainHeader;
