import React, { useLayoutEffect } from 'react';

function DetailsShell({
  isOpen,
  onClose,
  mainScrollRef,
  desktopScrollRef,
  children,
}) {
  useLayoutEffect(() => {
    if (!isOpen) return;

    const isMobile = window.innerWidth < 768;

    if (isMobile) {
      const mobileScrollY = window.scrollY;

      document.body.style.position = 'fixed';
      document.body.style.top = `-${mobileScrollY}px`;
      document.body.style.left = '0';
      document.body.style.right = '0';
      document.body.style.width = '100%';
      document.body.style.overflow = 'hidden';

      return () => {
        document.body.style.position = '';
        document.body.style.top = '';
        document.body.style.left = '';
        document.body.style.right = '';
        document.body.style.width = '';
        document.body.style.overflow = '';
        window.scrollTo(0, mobileScrollY);
      };
    }

    const savedDesktopScroll = desktopScrollRef.current || 0;

    if (mainScrollRef.current) {
      mainScrollRef.current.scrollTop = savedDesktopScroll;
    }

    document.documentElement.style.overflow = 'hidden';
    document.body.style.overflow = 'hidden';

    return () => {
      document.documentElement.style.overflow = '';
      document.body.style.overflow = '';

      requestAnimationFrame(() => {
        window.scrollTo(0, savedDesktopScroll);
      });
    };
  }, [isOpen, mainScrollRef, desktopScrollRef]);

  if (!isOpen) return null;

  return (
    <>
      <aside className="event-details-panel desktop-only dark-bg">
        {children}
      </aside>

      <div className="event-details-overlay mobile-only dark-bg">
        {children}
      </div>
    </>
  );
}

export default DetailsShell;
