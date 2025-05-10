import { useState, useEffect } from "react";

function TicketForm() {
  const [postType, setPostType] = useState("sell");
  const [eventId, setEventId] = useState("");
  const [contactInfo, setContactInfo] = useState("");
  const [events, setEvents] = useState([]);
  const [price, setPrice] = useState("");
  const [lookingFor, setLookingFor] = useState("");
  const [note, setNote] = useState("");

  useEffect(() => {
    const fetchEvents = async () => {
      const res = await fetch("http://localhost:3001/api/events");
      const data = await res.json();
      setEvents(
        data.sort((a, b) => {
          const nameA = `${a.venue.name} - ${a.title}`.toLowerCase();
          const nameB = `${b.venue.name} - ${b.title}`.toLowerCase();
          return nameA.localeCompare(nameB);
        })
      );

    };
    fetchEvents();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await fetch("http://localhost:3001/api/ticket_posts", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
      body: JSON.stringify({
        ticket_post: {
          post_type: postType,
          event_id: eventId,
          contact_info: contactInfo,
        },
      }),
    });
    const data = await res.json();
    console.log(data);
  };

  return (
    <div className="form-page">
      <h2>Create Ticket Post</h2>
      <form onSubmit={handleSubmit}>
        <label>Post Type:</label>
        <select value={postType} onChange={(e) => setPostType(e.target.value)}>
          <option value="sell">Sell</option>
          <option value="trade">Trade</option>
          <option value="gift">Gift</option>
        </select>

        <label>Event:</label>
        <select value={eventId} onChange={(e) => setEventId(e.target.value)}>
          <option value="">Select event</option>
          {events.map((ev) => (
            <option key={ev.id} value={ev.id}>
              {ev.venue.name} - {ev.title}
            </option>
          ))}
        </select>

        {postType === "sell" && (
            <>
              <label>Price:</label>
              <input type="text" value={price} onChange={(e) => setPrice(e.target.value)} />
            </>
          )}

          {postType === "trade" && (
            <>
              <label>Looking For:</label>
              <input type="text" value={lookingFor} onChange={(e) => setLookingFor(e.target.value)} />
            </>
          )}

          <label>Note:</label>
          <textarea value={note} onChange={(e) => setNote(e.target.value)} />


        <label>Contact Info:</label>
        <input
          type="text"
          value={contactInfo}
          onChange={(e) => setContactInfo(e.target.value)}
        />

        <button type="submit">Post</button>
      </form>
    </div>
  );
}

export default TicketForm;
