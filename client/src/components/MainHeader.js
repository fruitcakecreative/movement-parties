import React from "react";
import { useNavigate } from "react-router-dom";
import { Disclosure } from '@headlessui/react';

const cityKey = process.env.REACT_APP_CITY_KEY;
const logoSrc = `${process.env.PUBLIC_URL}/${cityKey}/logo.png`;

const navigation = [
  { name: 'Home', href: '/' },
  { name: 'Party Timelines', href: '/' },
  { name: 'Post a Ticket', href: '/tickets' },
  { name: 'Find a Ticket', href: '/tickets/new' },
];

function MainHeader() {

  const navigate = useNavigate();

  const profileClick = () => {
    const user = JSON.parse(localStorage.getItem("user"));
    navigate(user ? "/profile" : "/login");
  };

  return (
  <div className="header-con">
    <div className="logo-con"><img alt={`${cityKey} parties logo`} src={logoSrc} /></div>
    <div className="menu-con">
      <div className="hide profile">
        <button onClick={profileClick}><i className="fa-solid fa-user"></i></button>
      </div>
      <Disclosure as="nav" className="hide">
        {({ open }) => (
          <>
                <div className="m-hide">
                  {navigation.map((item) => (
                    <a key={item.name} href={item.href} className="">
                      {item.name}
                    </a>
                  ))}
                </div>

                <div className="d-hide">
                  <Disclosure.Button className="open-close-but">
                    {open ? <i className="fa-solid fa-xmark"></i>: <i className="fa-solid fa-bars"></i>}
                  </Disclosure.Button>
                </div>
            <Disclosure.Panel className="mobile-menu">

              {navigation.map((item) => (
                <a key={item.name} href={item.href} className="">
                  {item.name}
                </a>
              ))}
            </Disclosure.Panel>
          </>
        )}
      </Disclosure>


      </div>

  </div>
)};

export default MainHeader;
