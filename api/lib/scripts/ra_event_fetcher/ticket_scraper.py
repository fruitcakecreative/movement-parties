from bs4 import BeautifulSoup
import requests
import time

def fetch_ticket_info(event_id, retries=3):
    ticket_url = f"https://ra.co/widget/event/{event_id}/embedtickets"
    headers = {
        "User-Agent": "Mozilla/5.0",
        "Referer": f"https://ra.co/events/{event_id}"
    }

    for attempt in range(retries):
        try:
            response = requests.get(ticket_url, headers=headers, timeout=5)
            response.raise_for_status()
            break
        except requests.RequestException as e:
            print(f"[Retry {attempt+1}] Error fetching ticket iframe for {event_id}: {e}")
            time.sleep(2 + attempt)
    else:
        return None

    soup = BeautifulSoup(response.text, "html.parser")
    ticket_items = soup.select('ul[data-ticket-info-selector-id="tickets-info"] > li')
    live_ticket = soup.select_one("li.onsale")

    tier = None
    price = None
    current_tier = None

    if live_ticket and ticket_items:
        tier = live_ticket.select_one("div.pr8").get_text(strip=True)
        price = live_ticket.select_one("div.type-price").get_text(strip=True)
        total_waves = len(ticket_items)
        for i, li in enumerate(ticket_items, 1):
            if "onsale" in li.get("class", []):
                current_tier = f"{i} of {total_waves}"
                break

    return {
        "tier": tier,
        "price": price,
        "current_tier": current_tier
    }


if __name__ == "__main__":
    result = fetch_ticket_info("2124720")
    print(result)
