import {
  firstNameFromUserName,
  partitionEventsForShareGrid,
  scheduleShareTitle,
} from './generateScheduleShareImage';
import { partitionProfileExtraForShare } from './profileExtraInfo';

describe('scheduleShareTitle', () => {
  it('uses first word as first name', () => {
    expect(firstNameFromUserName('Alex Johnson')).toBe('Alex');
    expect(scheduleShareTitle('Alex Johnson')).toBe("Alex's Movement Schedule");
  });

  it('handles single-word names', () => {
    expect(scheduleShareTitle('Riley')).toBe("Riley's Movement Schedule");
  });
});

describe('partitionEventsForShareGrid', () => {
  const tz = 'America/Detroit';

  it('keeps attending and interested separate per day slot', () => {
    const eventsByDay = [
      [
        '2025-05-23',
        {
          attending: [{ id: 1, title: 'A', formatted_start_time: '2025-05-23T22:00:00-04:00' }],
          interested: [{ id: 2, title: 'B', formatted_start_time: '2025-05-23T23:00:00-04:00' }],
        },
      ],
    ];

    const slots = partitionEventsForShareGrid(eventsByDay, tz);
    expect(slots.friday.attending).toHaveLength(1);
    expect(slots.friday.interested).toHaveLength(1);
    expect(slots.friday.attending[0].event.title).toBe('A');
    expect(slots.friday.interested[0].event.title).toBe('B');
  });

  it('partitions profile extra for share layout', () => {
    const parts = partitionProfileExtraForShare({
      weekends_attended: '3',
      hometown: 'Chicago',
      artist_excited: 'Carl Cox',
      favorite_venue: 'TV Lounge',
      movement_pro_tip: 'Stay hydrated.',
    });
    expect(parts.weekend?.label).toBe('3rd Movement Weekend');
    expect(parts.weekend?.tier).toBe('regular');
    expect(parts.facts).toHaveLength(3);
    expect(parts.facts[0].shortLabel).toBe('From');
    expect(parts.proTip).toBe('Stay hydrated.');
  });

  it('maps Saturday to saturday slot', () => {
    const eventsByDay = [
      [
        '2025-05-24',
        {
          attending: [{ id: 3, title: 'Sat', formatted_start_time: '2025-05-24T20:00:00-04:00' }],
          interested: [],
        },
      ],
    ];
    const slots = partitionEventsForShareGrid(eventsByDay, tz);
    expect(slots.saturday.attending).toHaveLength(1);
    expect(slots.friday.attending).toHaveLength(0);
  });
});
