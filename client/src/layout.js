import React from 'react';
import { Outlet } from 'react-router-dom';
import MainHeader from './components/MainHeader';

const Layout = () => (
  <>
    <MainHeader />
    <main>
      <Outlet />
    </main>
  </>
);

export default Layout;
