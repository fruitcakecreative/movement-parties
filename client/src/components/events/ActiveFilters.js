import React from 'react';
import { formatGenreFilterLabel } from '../../utils/genreGroups';
import { showSheTheyForwardFilter } from '../../utils/cityFeatureFlags';

function ActiveFilters({
  filterSelections,
  setFilterSelections,
  hasActiveFilters,
  resetFilters,
}) {
  if (!hasActiveFilters) return null;

  return (
    <div className="active-filters">
      {showSheTheyForwardFilter && filterSelections.sheTheyForwardTimeline && (
        <button
          type="button"
          key="she-they-forward-timeline"
          className="filter-pill she-they-forward"
          onClick={() =>
            setFilterSelections((prev) => ({ ...prev, sheTheyForwardTimeline: false }))
          }
        >
          She/they–forward timeline <span className="x">&times;</span>
        </button>
      )}
      {Object.entries(filterSelections).flatMap(([category, values]) => {
        if (category === 'sheTheyForwardTimeline') return [];
        return values.map((val) => {
          const key = `${category}-${val}`.replace(/\s+/g, '-').toLowerCase();
          const label = category === 'genre' ? formatGenreFilterLabel(val) : val;

          return (
            <button
              key={key}
              type="button"
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
        });
      })}

      <button className="filter-reset" onClick={resetFilters}>
        Reset All Filters
      </button>
    </div>
  );
}

export default ActiveFilters;
