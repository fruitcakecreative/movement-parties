import { useEffect, useState } from "react";
import {
  fetchUserEvents,
  saveUserEventStatus,
  deleteUserEventStatus,
} from "../../services/api";

function UserEventButtons({ eventId, bgColor, fontColor }) {
  const [userAttending, setUserAttending] = useState(false);
  const [userInterested, setUserInterested] = useState(false);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await fetchUserEvents();
        const attending = data.attending?.some(e => e.id === Number(eventId));
        const interested = data.interested?.some(e => e.id === Number(eventId));

        setUserAttending(attending);
        setUserInterested(interested);
      } catch (err) {
        console.error("Not logged in or failed to fetch user events");
      }
    };

    load();
  }, [eventId]);

  const updateEventStatus = async (status, enable) => {
    try {
      if (enable) {
        await saveUserEventStatus(eventId, status);
      } else {
        await deleteUserEventStatus(eventId, status);
      }

      if (status === "attending") {
        setUserAttending(enable);
        if (enable) setUserInterested(false);
      } else if (status === "interested") {
        setUserInterested(enable);
        if (enable) setUserAttending(false);
      }
    } catch (err) {
      console.error("Failed to update event status:", err);
    }
  };

  const attendingButtonClass = userAttending
    ? "user-button attending user-attending"
    : "user-button attending not-attending";

  const interestedButtonClass = userInterested
    ? "user-button interested user-interested"
    : "user-button interested not-interested";

  return (
    <div className="userButtonCon">
      <button
        onClick={() => updateEventStatus("attending", !userAttending)}
        className={attendingButtonClass}
        style={{ backgroundColor: bgColor, borderColor: bgColor, color: fontColor }}
      >
        <i className="fa-solid fa-plus"></i>
        <span>Attending</span>
      </button>
      <button
        onClick={() => updateEventStatus("interested", !userInterested)}
        className={interestedButtonClass}
        style={{ backgroundColor: bgColor, color: fontColor }}
      >
        <i className="fa-solid fa-star"></i>
        <span> Interested</span>
      </button>
    </div>
  );
}

export default UserEventButtons;
