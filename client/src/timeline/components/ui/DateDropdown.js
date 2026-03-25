import { Listbox } from '@headlessui/react';
import React from 'react';

import { formatFestivalDayShort } from '../../../utils/timelineSchedule';

const DateDropdown = ({ selectedDate, setSelectedDate, dates, timeZone = 'America/New_York' }) => {
  return (
    <div className="w-64 dropdown-wrapper">
      <Listbox value={selectedDate} onChange={setSelectedDate}>
        <Listbox.Button className="bold full-width dropdown-btn">
          {selectedDate === 'all'
            ? 'All Days'
            : formatFestivalDayShort(selectedDate, timeZone)}
          <span className="dropdown-arrow">▾</span>
        </Listbox.Button>
        <Listbox.Options className="dropdown-options">
          {['all', ...dates].map((date) => (
            <Listbox.Option key={date} value={date}>
              {({ selected, active }) => (
                <div
                  className={`padding-sm option-item ${selected ? 'selected' : ''} ${active ? 'active' : ''}`}
                >
                  {date === 'all'
                    ? 'All Days'
                    : formatFestivalDayShort(date, timeZone)}
                </div>
              )}
            </Listbox.Option>
          ))}
        </Listbox.Options>
      </Listbox>
    </div>
  );
};

export default DateDropdown;
