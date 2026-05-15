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
      (data.interested || []).forEach((e) => {
        if (e?.id != null) map[e.id] = "interested";
      });
      (data.attending || []).forEach((e) => {
        if (e?.id != null) map[e.id] = "attending";
      });
      setStatusByEventId(map);
    } catch {
      setStatusByEventId({});
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh, location.pathname]);

  const setBusy = useCallback((eventId, isBusy) => {
    setPending((p) => ({ ...p, [eventId]: isBusy }));
  }, []);

  const getStatus = useCallback(
    (eventId) => {
      if (eventId == null) return null;
      return statusByEventId[eventId] || null;
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
      if (eventId == null) return;
      const prev = statusByEventId[eventId];
      setStatusByEventId((s) => ({ ...s, [eventId]: status }));
      setBusy(eventId, true);
      try {
        await saveUserEventStatus(eventId, status);
      } catch {
        setStatusByEventId((s) => {
          const n = { ...s };
          if (prev) n[eventId] = prev;
          else delete n[eventId];
          return n;
        });
        throw new Error("Could not save");
      } finally {
        setBusy(eventId, false);
      }
    },
    [statusByEventId, setBusy]
  );

  const clearStatus = useCallback(
    async (eventId) => {
      if (eventId == null) return;
      const prev = statusByEventId[eventId];
      setStatusByEventId((s) => {
        const n = { ...s };
        delete n[eventId];
        return n;
      });
      setBusy(eventId, true);
      try {
        await deleteUserEventStatus(eventId);
      } catch {
        if (prev) {
          setStatusByEventId((s) => ({ ...s, [eventId]: prev }));
        }
        throw new Error("Could not remove");
      } finally {
        setBusy(eventId, false);
      }
    },
    [statusByEventId, setBusy]
  );

  const toggleInterested = useCallback(
    async (eventId) => {
      const cur = statusByEventId[eventId];
      if (cur === "interested") await clearStatus(eventId);
      else await setStatus(eventId, "interested");
    },
    [statusByEventId, clearStatus, setStatus]
  );

  const toggleAttending = useCallback(
    async (eventId) => {
      const cur = statusByEventId[eventId];
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
      isPending: (eventId) => !!pending[eventId],
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
