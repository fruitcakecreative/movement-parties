import { useEffect, useState } from "react";
import FindFriends from "./FindFriends"

function FriendshipSection() {
  const [activeTab, setActiveTab] = useState("friends");
  const [friends, setFriends] = useState([]);
  const [pending, setPending] = useState([]);

  const tags = [
    { key: "friends", label: "All Friends" },
    { key: "add", label: "Find Friends" },
  ];

  return (
  <div className="friendship-section">
      <div className="friendship-menu">
        {tags.map(({ key, label }) => (
          <span
            key={key}
            className={`tag ${activeTab === key ? "active" : ""}`}
            onClick={() => setActiveTab(key)}
          >
            {label}
          </span>
        ))}
      </div>

      <div className="friendship-con">

      {activeTab === "friends" && (
        <div className="friend-list-con">
        {friends.map((f) => (
          <div className="friend-con" key={f.id}>
            <div className="img-con">
              <img
                src={ f.picture || f.avatar_url || "/images/placeholder.png"}
                alt="Profile" />
            </div>

            <p>{f.username}</p>
          </div>
        ))}
      </div>
      )}

      {activeTab === "requests" && (
        pending.length > 0 ? (
          <ul>
            {pending.map((user) => (
              <li key={user.id}>
                {user.username}
                <button onClick={'none'}>Accept</button>
              </li>
            ))}
          </ul>
        ) : (
          <p>No Friend Requests</p>
        )
      )}

      {activeTab === "add" && (
        <FindFriends />
      )}

    </div>

  </div>

)};

export default FriendshipSection;
