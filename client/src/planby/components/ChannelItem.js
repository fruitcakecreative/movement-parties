import { ChannelBox, ChannelLogo } from "@nessprim/planby-pro";
import formatVenueName from "../../helpers/formatVenueName";
import MiniProgramBox from "../components/MiniProgramBox";
import EventModalStandalone from "../../components/EventModalStandalone";

const ChannelItem = ({ channel, allEvents, modalStack, setModalStack }) => {
  const {
    position,
    logo,
    name,
    title,
    short_name,
    subheading,
    tba_class,
    location_tba,
    bg_color,
    font_color,
    address,
    location,
  } = channel;

  const isMobile = window.innerWidth < 768;
  const channelTitle = isMobile && short_name ? short_name : name;

  const eventsAtVenue = allEvents.filter(e => e.venue?.name === name);

  const groupedByDay = eventsAtVenue.reduce((acc, event) => {
    const dateStr = new Date(event.formatted_start_time).toLocaleDateString("en-US", {
      weekday: "long",
    });
    acc[dateStr] = acc[dateStr] || [];
    acc[dateStr].push(event);
    return acc;
  }, {});

  const openVenueModal = () => {
    let event;
        if (location_tba && eventsAtVenue.length > 1) {
          event = eventsAtVenue.find((e) =>
            channelTitle === e.title || channelTitle === e.short_title
          ) || eventsAtVenue[0];
        } else {
          event = eventsAtVenue[0];
        }

    if (location_tba && event) {
      document.body.style.overflow = 'hidden';
      setModalStack(prev => [
        ...prev,
        {
          isOpen: true,
          header: <h2 style={{ color: font_color }}>{event.title}</h2>,
          onClose: () => {
            setModalStack(prev => prev.slice(0, -1));
            document.body.style.overflow = '';
          },
          innerStyle: { borderColor: bg_color, scrollBarColor: bg_color },
          topRowStyle: { borderColor: bg_color, backgroundColor: bg_color, color: font_color },
          children: <EventModalStandalone event={event} venueHex={bg_color} fontHex={font_color} />,
        },
      ]);
      return;
    }

    document.body.style.overflow = 'hidden';
    setModalStack(prev => [
      ...prev,
      {
        isOpen: true,
        parent: 'venue',
        className: formatVenueName(name),
        innerStyle: {scrollBarColor: bg_color },
        topRowStyle: {color: 'white' },
        header: (
          <div className="venue-logo-name">
            <div className="venue-logo"><img alt="venue logo" src={`/images/${logo}`} /></div>
              <div className="venue-name"><h3 style={{ color: bg_color }}>{name}</h3></div>
          </div>
        ),
        children: (
          <>
            <p>{location}</p>
            <p>{address}</p>
            <div className="venue-events">
              <h4>All Events:</h4>
              {Object.entries(groupedByDay).map(([day, events]) => (
                <div key={day} className="group-day">
                  <h5>{day}</h5>
                  {events.map((event, i) => (
                    <MiniProgramBox
                      key={i}
                      event={event}
                      onClick={() => {
                        setModalStack(prev => [
                          ...prev,
                          {
                            isOpen: true,
                            header: <h2>{event.title}</h2>,
                            onClose: () => setModalStack(prev => prev.slice(0, -1)),
                            innerStyle: { borderColor: bg_color, scrollBarColor: bg_color },
                            topRowStyle: { borderColor: bg_color, backgroundColor: bg_color, color: font_color },
                            children: <EventModalStandalone event={event} venueHex={bg_color} />,
                          },
                        ]);
                      }}
                    />
                  ))}
                </div>
              ))}
            </div>
          </>
        ),
        onClose: () => {
          setModalStack(prev => prev.slice(0, -1));
          document.body.style.overflow = '';
        },
      },
    ]);
  };

  return (
    <div className={`channel-wrapper ${formatVenueName(name)} ${tba_class}`}>
      <ChannelBox {...position} className="channel-box" onClick={openVenueModal}>
        <div className="channel-box-inner" style={{ borderColor: bg_color }}>
          {logo ? (
            <ChannelLogo
              src={`/images/${logo}`}
              alt={name}
              className="venue-logo"
              style={subheading ? { height: "50%" } : {}}
            />
          ) : (
            <div className="party-venue">
              <p>{channelTitle}</p>
            </div>
          )}
          {subheading && <p className={`venue-subheading ${tba_class}`}>{subheading}</p>}
        </div>
      </ChannelBox>
    </div>
  );
};

export default ChannelItem;
