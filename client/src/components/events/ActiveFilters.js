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
          className="filter-pill filter-pill--toggle filter-pill--no-boys"
          onClick={() =>
            setFilterSelections((prev) => ({
              ...prev,
              sheTheyForwardTimeline: false,
              sheTheyOver50Lineup: false,
            }))
          }
        >
          No Boys Club <span className="x">&times;</span>
        </button>
      )}
      {showSheTheyForwardFilter &&
        filterSelections.sheTheyForwardTimeline &&
        filterSelections.sheTheyOver50Lineup && (
          <button
            type="button"
            className="filter-pill filter-pill--toggle filter-pill--she-they-50"
            onClick={() =>
              setFilterSelections((prev) => ({ ...prev, sheTheyOver50Lineup: false }))
            }
          >
            50%+ she/they lineup <span className="x">&times;</span>
          </button>
        )}
      {filterSelections.addedLastWeekOnly && (
        <button
          type="button"
          className="filter-pill filter-pill--toggle filter-pill--just-added"
          onClick={() =>
            setFilterSelections((prev) => ({ ...prev, addedLastWeekOnly: false }))
          }
        >
          JUST ADDED <span className="x">&times;</span>
        </button>
      )}
      {Object.entries(filterSelections).flatMap(([category, values]) => {
        if (
          category === 'sheTheyForwardTimeline' ||
          category === 'sheTheyOver50Lineup' ||
          category === 'addedLastWeekOnly'
        ) {
          return [];
        }
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
