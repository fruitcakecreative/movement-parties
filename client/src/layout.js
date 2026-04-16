import React, { useLayoutEffect } from 'react';
import { Outlet } from 'react-router-dom';
import { showSheTheyForwardFilter } from './utils/cityFeatureFlags';
import { applySheTheyThemeToDocument, readSheTheyForwardEnabled } from './utils/sheTheyTheme';

function Layout() {
  useLayoutEffect(() => {
    if (!showSheTheyForwardFilter) return;
    applySheTheyThemeToDocument(readSheTheyForwardEnabled());
  }, []);

  return (
    <>
      <main>
        <Outlet />
      </main>
    </>
  )
}

export default Layout;
