import { Disclosure } from '@headlessui/react';

const costOptions = ['Free', 'Under $20', 'Under $50'];
const ageOptions = ['All Ages', '18+', '21+'];

const FiltersDropdown = ({
  selected,
  setSelected,
  genreOptions,
  artistOptions,
  searchQuery,
  setSearchQuery,
  filteredArtists,
  setFilteredArtists,
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
      <Disclosure>
        {({ open }) => (
          <>
            <Disclosure.Button className="dropdown-btn">
              <span>Other Filters</span>
              <span className="dropdown-arrow">{open ? '▴' : '▾'}</span>
            </Disclosure.Button>
            <Disclosure.Panel className="dropdown-options">
              <div className="option-item artists">
                <input
                  type="text"
                  placeholder="Search Artists..."
                  className=""
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
                  <div className="option-item artist-search">
                    {filteredArtists.map((artist) => (
                      <div
                        key={artist}
                        className="option-item"
                        onClick={() => {
                          setSelected((prev) => ({
                            ...prev,
                            artist: [artist], // or [...prev.artist, artist] for multi-select
                          }));
                          setSearchQuery('');
                          setFilteredArtists([]);
                        }}
                      >
                        {artist}
                      </div>
                    ))}
                  </div>
                )}
              </div>

              {/* Genre Section */}
              <Disclosure>
                {({ open }) => (
                  <>
                    <Disclosure.Button className="option-item">
                      <span className="genre">Genre</span>{' '}
                      <span className="arrow">{open ? '▴' : '▾'}</span>
                    </Disclosure.Button>
                    <Disclosure.Panel className="option-item-wrapper">
                      {genreOptions.map((g) => (
                        <div
                          key={g}
                          className="option-item genre"
                          onClick={() => toggle('genre', g)}
                        >
                          <input type="checkbox" readOnly checked={selected.genre?.includes(g)} />
                          {g}
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
                  <div key={c} className="option-item child cost" onClick={() => toggle('cost', c)}>
                    <input type="checkbox" readOnly checked={selected.cost?.includes(c)} />
                    {c}
                  </div>
                ))}
              </div>

              {/* Age Section */}
              <div className="small-opt-wrapper age-wrapper">
                <div className="option-item parent age">Age:</div>
                {ageOptions.map((c) => (
                  <div key={c} className="option-item child age" onClick={() => toggle('age', c)}>
                    <input type="checkbox" readOnly checked={selected.age?.includes(c)} />
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
