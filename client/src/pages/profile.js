import { useEffect, useState } from "react";
import ModalLayout from "../components/ModalLayout";
import MiniProgramBox from "../planby/components/MiniProgramBox";

import { userLogout,
        fetchUserInfo,
        fetchUserEvents } from "../services/api";

function Profile() {
  const [user, setUser] = useState(null);
  const [userEvents, setUserEvents] = useState({});
  const [avatarFile, setAvatarFile] = useState(null);
  const [profile, setProfile] = useState(null);
  const [isOpen, setIsOpen] = useState(false);
  const [activeTab, setActiveTab] = useState("friends");



  const openModal = () => {
      document.body.style.overflow = 'hidden';
      setIsOpen(true);
    };

  const closeModal = () => {
    document.body.style.overflow = '';
    setIsOpen(false);
  };

  useEffect(() => {
    fetchUserInfo()
      .then((data) => {
        setUser(data);
      })
      .catch(() => {
        window.location.href = "/login";
      });
  }, []);

  useEffect(() => {
    if (!user) return;

    fetchUserInfo()
      .then((data) => setProfile(data))
      .catch((error) => console.error("Error fetching user info:", error));

    fetchUserEvents()
      .then((data) => setUserEvents(data))
      .catch((err) => console.error("Failed to fetch user events", err));
  }, [user]);


  const attEventsByDay = userEvents.attending?.reduce((acc, event) => {
    const dateStr = new Date(event.formatted_start_time).toLocaleDateString("en-US", {
      weekday: "long",
    });
    acc[dateStr] = acc[dateStr] || [];
    acc[dateStr].push(event);
    return acc;
  }, {});

  const tags = [
    { key: "friends", label: "All Friends" },
    { key: "requests", label: "Friend Requests" },
    { key: "add", label: "Add Friends" },
  ];

  if (!user || !profile) return null;

  return (
    <>
    <div className="page-con">

      <div className="profile-dashboard">

        <div className="heading">
          <div className="avatar-con">
              <img
                src={user.avatar_url || user.picture || "/images/placeholder.png"}
                alt="Profile" />
          </div>
            <h2>Hi, {user.name || user.username || user.email}</h2>
        </div>


      <button onClick={openModal}>edit profile settings</button>

      {attEventsByDay?.length > 0 && (
        Object.entries(attEventsByDay).map(([day, events]) => (
          <div key={day} className="group-day">
            <h5>{day}</h5>
            {events.map((event, i) => (
              <MiniProgramBox key={event.id || i} event={event} onClick={'none'} />
            ))}
          </div>
        ))
      )}


      {userEvents.interested?.length > 0 && (
        <>
          <h3>Interested</h3>
          <ul>
            {userEvents.interested.map((event) => (
              <li key={event.id}>{event.title}</li>
            ))}
          </ul>
        </>
      )}

      {userEvents.attending?.length > 0 && (
        <>
          <h3>Attending</h3>
          <ul>
            {userEvents.attending.map((event) => (
              <li key={event.id}>{event.title}</li>
            ))}
          </ul>
        </>
      )}

      <button onClick={userLogout}>
        Log out
      </button>
    </div>
  </div>
    <ModalLayout
      isOpen={isOpen}
      onClose={closeModal}
      parent='none'
      className="edit-profile"
      header={<h3>edit profile settings</h3>}
    >
      <div className="profile-photo">
        <p className="heading">Change profile photo:</p>
        <input type="file" onChange={(e) => setAvatarFile(e.target.files[0])} />
        <button class="white-bg" onClick={'none'}>Upload Profile Picture</button>
      </div>

    </ModalLayout>
    </>
  );
}

export default Profile;
