import { useEffect, useState } from "react";

const useFriendAttendees = (eventId) => {
  const [friendAttendees, setFriendAttendees] = useState([]);

  useEffect(() => {
    if (!eventId) return;

    const user = JSON.parse(localStorage.getItem("user"));
    if (!user?.token) return;

    fetch(`http://localhost:3001/api/user_events/${eventId}/friend_attendees`, {
      headers: {
        Authorization: `Bearer ${user.token}`,
      },
    })
      .then(res => res.json())
      .then(data => setFriendAttendees(data))
      .catch(err => console.error("Friend fetch failed:", err));
  }, [eventId]);

  return friendAttendees;
};

export default useFriendAttendees;
