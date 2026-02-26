import { useEffect, useState } from "react";
import {
  fetchFriendshipList,
  sendFriendRequest,
  acceptFriendRequest,
  cancelFriendRequest,
  rejectFriendRequest,
} from "../../../services/api";



function FindFriends() {
  const [inputFocused, setInputFocused] = useState(false);
  const [friendUsername, setFriendUsername] = useState("");
  const [allUsers, setAllUsers] = useState([]);

  useEffect(() => {
    fetchFriendshipList()
      .then(setAllUsers)
      .catch(console.error);
  }, []);

  const handleCancel = async (username, id) => {
    await cancelFriendRequest(username);
    updateUserStatus(id, "none");
  };

  const handleReject = async (id) => {
    await rejectFriendRequest(id);
    updateUserStatus(id, "none");
  };

  const updateUserStatus = (id, newStatus) => {
    setAllUsers((prev) =>
      prev.map((u) => (u.id === id ? { ...u, friendship_status: newStatus } : u))
    );
  };

  const handleAdd = async (username, id) => {
    await sendFriendRequest(username);
    updateUserStatus(id, "pending");
  };

  const handleAccept = async (id) => {
    await acceptFriendRequest(id);
    updateUserStatus(id, "friends");
  };

  const filteredUsers = allUsers.filter((u) => {
    const name = friendUsername.toLowerCase();
    return (
      u.username.toLowerCase().includes(name) ||
      u.name?.toLowerCase().includes(name) ||
      u.email?.toLowerCase().includes(name)
    );
  });

  if (!Array.isArray(allUsers)) return null;

  return (
    <div className="find-friends">
      <input
        placeholder="Search by name, email or username"
        value={friendUsername}
        onChange={(e) => setFriendUsername(e.target.value)}
        onFocus={() => setInputFocused(true)}
        onBlur={(e) => {
          setTimeout(() => {
            if (
              e.currentTarget &&
              e.currentTarget.parentNode &&
              !e.currentTarget.parentNode.contains(document.activeElement)
            ) {
              setInputFocused(false);
            }
          }, 0);
        }}
      />

      {inputFocused && (
        <div className="search-results">
          {(friendUsername ? filteredUsers : allUsers).map((u) => (
            <div key={u.id} className="search-result-item">
              <div className="profile">
                <img
                  src={u.avatar_url || u.picture || "/images/placeholder.png"}
                  className="profile-photo"
                  alt=""
                />
                <p>{u.name}</p>
              </div>

              {u.friendship_status === "none" && (
                <button
                  className="friendship-btn add"
                  onClick={() => handleAdd(u.username, u.id)}
                >
                  <i className="fa-solid fa-plus"></i> Add
                </button>
              )}

              {u.friendship_status === "pending" && (
                <div className="request-buttons">
                  <button className="friendship-btn pending" disabled>
                    <i className="fa-solid fa-hourglass-half"></i> Pending
                  </button>
                  <button
                    className="friendship-btn reject"
                    onClick={() => handleCancel(u.username, u.id)}
                  >
                    <i className="fa-solid fa-xmark"></i>
                  </button>
                </div>
              )}

              {u.friendship_status === "requested" && (
                <div className="request-buttons">
                  <button
                    className="friendship-btn accept"
                    onClick={() => handleAccept(u.id)}
                  >
                    <i className="fa-solid fa-check"></i> Accept
                  </button>
                  <button
                    className="friendship-btn reject"
                    onClick={() => handleReject(u.id)}
                  >
                    <i className="fa-solid fa-xmark"></i>
                  </button>
                </div>
              )}
              {u.friendship_status === "friends" && (
                <button className="friendship-btn friends" disabled>
                  <i className="fa-solid fa-heart"></i> Friends
                </button>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default FindFriends;
