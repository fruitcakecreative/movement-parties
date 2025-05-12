import React from "react";
import { useNavigate } from "react-router-dom";
import { Disclosure } from '@headlessui/react';

const navigation = [
  { name: 'Home', href: '/' },
  { name: 'Party Timelines', href: '/' },
  { name: 'Post a Ticket', href: '/tickets' },
  { name: 'Find a Ticket', href: '/tickets/new' },
];

function Header() {

  const navigate = useNavigate();

  return (
  <div className="header-con">
    <div className="logo-con"><img alt="movement parties logo" src="/images/logo_mobile.png" /></div>
  </div>
)};

export default Header;
