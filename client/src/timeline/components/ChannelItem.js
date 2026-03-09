import { ChannelBox, ChannelLogo } from '@nessprim/planby-pro';
import formatVenueName from '../../utils/formatVenueName';
import { useIsMobile } from '../hooks/useIsMobile';

const ChannelItem = ({ channel, openVenue }) => {
  const {
    position,
    logo,
    name,
    short_name,
    subheading,
    tba_class,
    location_tba,
    bg_color,
  } = channel;

  const isMobile = useIsMobile();
  const channelTitle = isMobile && short_name ? short_name : name;

  const handleClick = () => {
    if (location_tba) return;
    openVenue?.(channel.id);
  };

  return (
    <div className={`channel-wrapper ${formatVenueName(name)} ${tba_class || ''}`}>
      <ChannelBox
        {...position}
        className="channel-box"
        onClick={handleClick}
      >
        <div className="channel-box-inner" style={{ borderColor: bg_color }}>
          {logo ? (
            <ChannelLogo
              src={logo}
              alt={name}
              className="venue-logo"
              style={subheading ? { height: 'auto' } : {}}
            />
          ) : (
            <div className="party-venue">
              <p>{channelTitle}</p>
            </div>
          )}

          {subheading && (
            <p className={`venue-subheading ${tba_class || ''}`}>
              {subheading}
            </p>
          )}
        </div>
      </ChannelBox>
    </div>
  );
};

export default ChannelItem;
