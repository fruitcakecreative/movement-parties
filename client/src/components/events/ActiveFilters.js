import React from 'react';
import { formatGenreFilterLabel } from '../../utils/genreGroups';

function ActiveFilters({
  filterSelections,
  setFilterSelections,
  hasActiveFilters,
  resetFilters,
}) {
  if (!hasActiveFilters) return null;

  return (
    <div className="active-filters">
      {Object.entries(filterSelections).flatMap(([category, values]) =>
        values.map((val) => {
          const key = `${category}-${val}`.replace(/\s+/g, '-').toLowerCase();
          const label = category === 'genre' ? formatGenreFilterLabel(val) : val;

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
              {label} <span className="x">&times;</span>
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
