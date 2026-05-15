import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import { useLocation } from "react-router-dom";
import {
  fetchUserEvents,
  saveUserEventStatus,
  deleteUserEventStatus,
} from "../services/api";
import { coalesceEventList } from "../utils/profileEventsByDay";

function readHasAuthToken() {
  try {
    const raw = localStorage.getItem("user");
    if (!raw) return false;
    const u = JSON.parse(raw);
    return !!(u.authentication_token || u.token);
  } catch {
    return false;
  }
}

/** Stable map key — JSON / DOM can give ids as numbers or digit strings. */
function statusMapKey(eventId) {
  if (eventId == null || eventId === "") return null;
  if (typeof eventId === "number") {
    return Number.isFinite(eventId) ? eventId : null;
  }
  const s = String(eventId).trim();
  if (s === "" || s === "null" || s === "undefined") return null;
  if (/^\d+$/.test(s)) return Number(s);
  return s;
}

const UserEventsContext = createContext(null);

export function UserEventsProvider({ children }) {
  const location = useLocation();
  const [statusByEventId, setStatusByEventId] = useState({});
  const [pending, setPending] = useState({});

  const refresh = useCallback(async () => {
    if (!readHasAuthToken()) {
      setStatusByEventId({});
      return;
    }
    try {
      const data = await fetchUserEvents();
      const map = {};
      // Same shape as profile: API may use `interested`/`attending` or enum keys `"0"`/`"1"`.
      const interestedList = coalesceEventList(data, "interested", "0", 0);
      const attendingList = coalesceEventList(data, "attending", "1", 1);
      interestedList.forEach((e) => {
        const k = statusMapKey(e?.id);
        if (k != null) map[k] = "interested";
      });
      attendingList.forEach((e) => {
        const k = statusMapKey(e?.id);
        if (k != null) map[k] = "attending";
      });
      setStatusByEventId(map);
    } catch {
      setStatusByEventId({});
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh, location.pathname]);

  // iOS Safari: restore from back-forward cache can leave React state stale while session is fine.
  useEffect(() => {
    const onPageShow = (e) => {
      if (e.persisted && readHasAuthToken()) refresh();
    };
    window.addEventListener("pageshow", onPageShow);
    return () => window.removeEventListener("pageshow", onPageShow);
  }, [refresh]);

  const setBusy = useCallback((eventId, isBusy) => {
    const k = statusMapKey(eventId);
    if (k == null) return;
    setPending((p) => ({ ...p, [k]: isBusy }));
  }, []);

  const getStatus = useCallback(
    (eventId) => {
      const k = statusMapKey(eventId);
      if (k == null) return null;
      return statusByEventId[k] ?? null;
    },
    [statusByEventId]
  );

  const isAuthenticated = useMemo(() => {
    void location.pathname;
    void location.key;
    return readHasAuthToken();
  }, [location.pathname, location.key]);

  const setStatus = useCallback(
    async (eventId, status) => {
      const k = statusMapKey(eventId);
      if (k == null) return;
      const prev = statusByEventId[k];
      setStatusByEventId((s) => ({ ...s, [k]: status }));
      setBusy(k, true);
      try {
        await saveUserEventStatus(eventId, status);
      } catch {
        setStatusByEventId((s) => {
          const n = { ...s };
          if (prev) n[k] = prev;
          else delete n[k];
          return n;
        });
        throw new Error("Could not save");
      } finally {
        setBusy(k, false);
      }
    },
    [statusByEventId, setBusy]
  );

  const clearStatus = useCallback(
    async (eventId) => {
      const k = statusMapKey(eventId);
      if (k == null) return;
      const prev = statusByEventId[k];
      setStatusByEventId((s) => {
        const n = { ...s };
        delete n[k];
        return n;
      });
      setBusy(k, true);
      try {
        await deleteUserEventStatus(eventId);
      } catch {
        if (prev) {
          setStatusByEventId((s) => ({ ...s, [k]: prev }));
        }
        throw new Error("Could not remove");
      } finally {
        setBusy(k, false);
      }
    },
    [statusByEventId, setBusy]
  );

  const toggleInterested = useCallback(
    async (eventId) => {
      const k = statusMapKey(eventId);
      if (k == null) return;
      const cur = statusByEventId[k];
      if (cur === "interested") await clearStatus(eventId);
      else await setStatus(eventId, "interested");
    },
    [statusByEventId, clearStatus, setStatus]
  );

  const toggleAttending = useCallback(
    async (eventId) => {
      const k = statusMapKey(eventId);
      if (k == null) return;
      const cur = statusByEventId[k];
      if (cur === "attending") await clearStatus(eventId);
      else await setStatus(eventId, "attending");
    },
    [statusByEventId, clearStatus, setStatus]
  );

  const value = useMemo(
    () => ({
      getStatus,
      toggleInterested,
      toggleAttending,
      refresh,
      isAuthenticated,
      isPending: (eventId) => {
        const k = statusMapKey(eventId);
        return k != null && !!pending[k];
      },
    }),
    [
      getStatus,
      toggleInterested,
      toggleAttending,
      refresh,
      isAuthenticated,
      pending,
    ]
  );

  return (
    <UserEventsContext.Provider value={value}>
      {children}
    </UserEventsContext.Provider>
  );
}

export function useUserEvents() {
  const ctx = useContext(UserEventsContext);
  if (!ctx) {
    throw new Error("useUserEvents must be used within UserEventsProvider");
  }
  return ctx;
}
