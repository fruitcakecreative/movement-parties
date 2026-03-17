import { Disclosure } from '@headlessui/react';

const costOptions = ['Free', 'Under $20', 'Under $50'];
const ageOptions = ['All Ages', '18+', '21+'];
const partyOptions = [
  { label: 'Pool or Beach party', value: 'Pool' },
    { label: 'Restaurant/Bar/Lounge', value: 'Restaurant/Bar/Lounge' },
    { label: 'Small Intimate Venue', value: 'Small Intimate Venue' },
  { label: 'Boat party', value: 'Boat' },
  { label: 'Rooftop', value: 'Rooftop Bar' },
  { label: 'Music Venue/Event Space', value: 'Music Venue/Event Space' },
  { label: 'Nightclub/Club', value: 'Nightclub/Club' }
];

const FiltersDropdown = ({
  selected,
  setSelected,
  genreOptions,
  artistOptions,
  venueOptions,
  locationOptions,
  searchQuery,
  setSearchQuery,
  filteredArtists,
  setFilteredArtists,
  venueSearchQuery,
  setVenueSearchQuery,
  filteredVenues,
  setFilteredVenues,
}) => {
  const toggle = (category, value) => {
    const exists = selected[category]?.includes(value);
    setSelected((prev) => ({
      ...prev,
      [category]: exists
        ? prev[category].filter((v) => v !== value)
        : [...(prev[category] || []), value],
    }));
  };

  return (
    <div className="dropdown-wrapper filters">
    {/* Party Type Section */}
    <div className="small-opt-wrapper party-wrapper">
      <div className="hide-movement option-item bold parent party">Event Type Legend (click to filter):</div>
      <div className="hide-movement pill-row flex-wrap">
        {partyOptions.map((party) => (
          <button
            type="button"
            key={party.value}
            className={`${party.value} button pill-btn ${
              selected.venueType?.includes(party.value) ? 'active' : ''
            }`}
            onClick={() => toggle('venueType', party.value)}
          >
            {party.label}
          </button>
        ))}
      </div>
    </div>
      <Disclosure>
        {({ open }) => (
          <>
            <Disclosure.Button className="bold full-width dropdown-btn">
              <span>Other Filters</span>
              <span className="dropdown-arrow">{open ? '▴' : '▾'}</span>
            </Disclosure.Button>

            <Disclosure.Panel className="flex flex-column padding dropdown-options">

              {/* Artist Search */}
              <div className="full-width option-item artists mb-sm">
                <input
                  type="text"
                  placeholder="Search Artists..."
                  className="full-width"
                  value={searchQuery}
                  onChange={(e) => {
                    const q = e.target.value;
                    setSearchQuery(q);
                    setFilteredArtists(
                      artistOptions.filter((artist) =>
                        artist.toLowerCase().includes(q.toLowerCase())
                      )
                    );
                  }}
                />

                {searchQuery && filteredArtists.length > 0 && (
                  <div className="artist-search-wrapper">
                  <div className="option-item artist-search">
                    {filteredArtists.map((artist) => (
                      <div
                        key={artist}
                        className="option-item"
                        onClick={() => {
                          setSelected((prev) => ({
                            ...prev,
                            artist: [artist],
                          }));
                          setSearchQuery('');
                          setFilteredArtists([]);
                        }}
                      >
                        {artist}
                      </div>
                    ))}
                  </div>
                  </div>
                )}
              </div>

              {/* Venue Search */}
              <div className="full-width option-item venues mb-sm">
                <input
                  type="text"
                  placeholder="Search Venues..."
                  className="full-width"
                  value={venueSearchQuery}
                  onChange={(e) => {
                    const q = e.target.value.toLowerCase();
                    setVenueSearchQuery(e.target.value);
                    setFilteredVenues(
                      venueOptions
                        .filter((v) => {
                          const searchStr = [v.name, v.subheading]
                            .filter(Boolean)
                            .join(' ')
                            .toLowerCase();
                          return searchStr.includes(q);
                        })
                        .filter((v) => !selected.venue?.includes(v.name))
                    );
                  }}
                />

                {venueSearchQuery && filteredVenues.length > 0 && (
                  <div className="venue-search-wrapper">
                    <div className="option-item venue-search">
                      {filteredVenues.map((v) => (
                        <div
                          key={v.name}
                          className="option-item"
                          onClick={() => {
                            setSelected((prev) => ({
                              ...prev,
                              venue: [...(prev.venue || []), v.name],
                            }));
                            setVenueSearchQuery('');
                            setFilteredVenues([]);
                          }}
                        >
                          {v.subheading && v.subheading.toLowerCase() !== v.name.toLowerCase()
  ? `${v.name} (${v.subheading})`
  : v.name}
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>

              {/* Genre Section */}
              <Disclosure>
                {({ open }) => (
                  <>
                    <Disclosure.Button className="mb-xs full-width option-item">
                      <span className="genre">Genre</span>
                      <span className="arrow">{open ? '▴' : '▾'}</span>
                    </Disclosure.Button>

                    <Disclosure.Panel className="option-item-wrapper">
                      {genreOptions.map((g) => (
                        <div
                          key={g}
                          className="option-item genre"
                          onClick={() => toggle('genre', g)}
                        >
                          <input
                            type="checkbox"
                            readOnly
                            checked={selected.genre?.includes(g)}
                          />
                          {g}
                        </div>
                      ))}
                    </Disclosure.Panel>
                  </>
                )}
              </Disclosure>

              {/* Location Section */}
              <Disclosure>
                {({ open }) => (
                  <>
                    <Disclosure.Button className="full-width option-item">
                      <span className="location">Location</span>
                      <span className="arrow">{open ? '▴' : '▾'}</span>
                    </Disclosure.Button>

                    <Disclosure.Panel className="option-item-wrapper">
                      {locationOptions.map((loc) => (
                        <div
                          key={loc}
                          className="option-item location"
                          onClick={() => toggle('location', loc)}
                        >
                          <input
                            type="checkbox"
                            readOnly
                            checked={selected.location?.includes(loc)}
                          />
                          {loc}
                        </div>
                      ))}
                    </Disclosure.Panel>
                  </>
                )}
              </Disclosure>

              {/* Cost Section */}
              <div className="small-opt-wrapper cost-wrapper">
                <div className="option-item parent cost">Cost:</div>
                {costOptions.map((c) => (
                  <div
                    key={c}
                    className="option-item child cost"
                    onClick={() => toggle('cost', c)}
                  >
                    <input
                      type="checkbox"
                      readOnly
                      checked={selected.cost?.includes(c)}
                    />
                    {c}
                  </div>
                ))}
              </div>

              {/* Age Section */}
              <div className="small-opt-wrapper age-wrapper">
                <div className="option-item parent age">Age:</div>
                {ageOptions.map((c) => (
                  <div
                    key={c}
                    className="option-item child age"
                    onClick={() => toggle('age', c)}
                  >
                    <input
                      type="checkbox"
                      readOnly
                      checked={selected.age?.includes(c)}
                    />
                    {c}
                  </div>
                ))}
              </div>
            </Disclosure.Panel>
          </>
        )}
      </Disclosure>
    </div>
  );
};

export default FiltersDropdown;
