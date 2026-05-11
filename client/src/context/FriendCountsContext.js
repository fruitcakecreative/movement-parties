import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import { fetchFriendEventCountsBatch } from "../services/api";

const FriendCountsContext = createContext(null);

/**
 * Loads friend attending/interested counts for a set of event ids (one batch request).
 * Use with EventStatusControls / ProgramItem / EventCard on the same page.
 */
export function FriendCountsProvider({ eventIds, children }) {
  const [counts, setCounts] = useState(undefined);

  const sortedKey = useMemo(() => {
    const s = new Set(
      (eventIds || [])
        .filter((id) => id != null)
        .map((id) => String(id))
    );
    return [...s].sort().join(",");
  }, [eventIds]);

  useEffect(() => {
    const ids = sortedKey
      ? sortedKey.split(",").map((x) => Number(x)).filter((n) => !Number.isNaN(n))
      : [];
    if (ids.length === 0) {
      setCounts({});
      return undefined;
    }

    let cancelled = false;
    setCounts(undefined);
    fetchFriendEventCountsBatch(ids)
      .then((data) => {
        if (!cancelled) setCounts(data);
      })
      .catch(() => {
        if (!cancelled) setCounts({});
      });
    return () => {
      cancelled = true;
    };
  }, [sortedKey]);

  const value = useMemo(() => {
    return {
      get: (eventId) => {
        if (eventId == null) {
          return { friendsInterested: undefined, friendsAttending: undefined };
        }
        if (counts === undefined) {
          return { friendsInterested: undefined, friendsAttending: undefined };
        }
        return (
          counts[String(eventId)] || {
            friendsInterested: 0,
            friendsAttending: 0,
          }
        );
      },
    };
  }, [counts]);

  return (
    <FriendCountsContext.Provider value={value}>
      {children}
    </FriendCountsContext.Provider>
  );
}

export function useFriendCounts() {
  return (
    useContext(FriendCountsContext) || {
      get: () => ({
        friendsInterested: undefined,
        friendsAttending: undefined,
      }),
    }
  );
}
