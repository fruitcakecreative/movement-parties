import React, { useLayoutEffect } from 'react';
import { Outlet } from 'react-router-dom';
import MainHeader from './components/MainHeader';
import { UserEventsProvider } from './context/UserEventsContext';
import { showSheTheyForwardFilter } from './utils/cityFeatureFlags';
import { applySheTheyThemeToDocument, readSheTheyForwardEnabled } from './utils/sheTheyTheme';

function Layout() {
  useLayoutEffect(() => {
    if (!showSheTheyForwardFilter) return;
    applySheTheyThemeToDocument(readSheTheyForwardEnabled());
  }, []);

  return (
    <UserEventsProvider>
      <div className="app-layout">
        <MainHeader />
        <main className="app-layout__main">
          <Outlet />
        </main>
      </div>
    </UserEventsProvider>
  );
}

export default Layout;
