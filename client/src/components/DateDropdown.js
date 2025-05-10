import { Listbox } from "@headlessui/react";

const DateDropdown = ({ selectedDate, setSelectedDate, dates }) => {
  return (
    <div className="w-64 dropdown-wrapper">
      <Listbox value={selectedDate} onChange={setSelectedDate}>
        <Listbox.Button className="dropdown-btn">
          {selectedDate === "all"
            ? "All Days"
            : new Date(`${selectedDate}T12:00:00`).toLocaleDateString("en-US", {
                weekday: "short",
                month: "short",
                day: "numeric",
              })}
              <span className="dropdown-arrow">▾</span>
        </Listbox.Button>
        <Listbox.Options className="dropdown-options">
          {["all", ...dates].map((date) => (
            <Listbox.Option key={date} value={date}>
              {({ selected, active }) => (
                <div
                  className={`option-item ${selected ? "selected" : ""} ${
                    active ? "active" : ""
                  }`}
                >
                  {date === "all"
                    ? "All Days"
                    : new Date(`${date}T12:00:00`).toLocaleDateString("en-US", {
                        weekday: "short",
                        month: "short",
                        day: "numeric",
                      })}
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
