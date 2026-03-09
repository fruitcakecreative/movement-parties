import React from 'react';

function ActiveFilters({
  filterSelections,
  setFilterSelections,
  hasActiveFilters,
  resetFilters,
}) {
  if (!hasActiveFilters) return null;

  return (
    <div
      className="active-filters"
      style={{ margin: '10px 30px', display: 'flex', flexWrap: 'wrap', gap: '10px' }}
    >
      {Object.entries(filterSelections).flatMap(([category, values]) =>
        values.map((val) => {
          const key = `${category}-${val}`.replace(/\s+/g, '-').toLowerCase();

          return (
            <button
              key={key}
              className={`filter-pill ${category}`}
              onClick={() =>
                setFilterSelections((prev) => ({
                  ...prev,
                  [category]: prev[category].filter((v) => v !== val),
                }))
              }
            >
              {val} <span className="x">&times;</span>
            </button>
          );
        })
      )}

      <button className="filter-reset" onClick={resetFilters}>
        Reset All Filters
      </button>
    </div>
  );
}

export default ActiveFilters;
