import requests
import json
import time
import argparse
from datetime import datetime, timedelta
from ticket_scraper import fetch_ticket_info
import random
import os
import glob
import subprocess

URL = 'https://ra.co/graphql'
HEADERS = {
    'Content-Type': 'application/json',
    'Referer': 'https://ra.co/events/uk/london',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0'
}
QUERY_TEMPLATE_PATH = "graphql_query_template.json"
DELAY = 1

rails_app_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../"))
output_dir = os.path.join(rails_app_path, "db")
os.makedirs(output_dir, exist_ok=True)

# delete .json files older than 3 days
json_files = glob.glob(os.path.join(output_dir, "events_*.json"))
three_days_ago = time.time() - 3 * 86400
for file in json_files:
    if os.path.getmtime(file) < three_days_ago:
        os.remove(file)

filename = f"events_{datetime.now().strftime('%Y%m%d_%H%M')}.json"
output_path = os.path.join(output_dir, filename)

class EventFetcher:
    def __init__(self, areas, listing_date_gte, listing_date_lte):
        self.payload = self.generate_payload(areas, listing_date_gte, listing_date_lte)

    @staticmethod
    def generate_payload(areas, listing_date_gte, listing_date_lte):
        with open(QUERY_TEMPLATE_PATH, "r") as file:
            payload = json.load(file)

        payload["variables"]["filters"]["areas"]["eq"] = areas
        payload["variables"]["filters"]["listingDate"]["gte"] = listing_date_gte
        payload["variables"]["filters"]["listingDate"]["lte"] = listing_date_lte

        return payload

    def get_events(self, page_number):
        print(f"\Getting events {page_number}", flush=True)
        self.payload["variables"]["page"] = page_number
        response = requests.post(URL, headers=HEADERS, json=self.payload)

        try:
            response.raise_for_status()
            data = response.json()
        except (requests.exceptions.RequestException, ValueError):
            print(f"Error: {response.status_code}", flush=True)
            return []

        if 'data' not in data or data["data"] is None:
            print(f"Error: {data}", flush=True)
            return []

        return data["data"]["eventListings"]["data"]

    def fetch_all_events(self):
        all_events = []
        page_number = 1

        while True:
            print(f"\nFetching page {page_number}...", flush=True)
            events = self.get_events(page_number)
            if not events:
                print("No more events.", flush=True)
                break

            for event in events:
                event_id = event["event"]["id"]
                print(f"→ Fetching ticket info for event {event_id}...", flush=True)
                ticket_data = fetch_ticket_info(event_id)
                if ticket_data:
                    event["ticket_info"] = {
                        "tier": ticket_data["tier"],
                        "price": ticket_data["price"],
                        "current_tier": ticket_data["current_tier"]
                    }
                    print(f"✓ Ticket info added for {event_id}", flush=True)
                else:
                    print(f"✗ Failed to fetch ticket info for {event_id}", flush=True)
                time.sleep(random.uniform(2, 4))

            all_events.extend(events)
            page_number += 1
            time.sleep(DELAY)

        return all_events

    def save_events_to_json(self, events, output_file):
        print(f"\nSaving {len(events)} events to {output_file}...", flush=True)
        with open(output_file, "w", encoding="utf-8") as file:
            json.dump(events, file, indent=4)
        print("Done.", flush=True)

def main():
    parser = argparse.ArgumentParser(description="Fetch events from ra.co and save them to a JSON file.")
    parser.add_argument("areas", type=int, help="The area code to filter events.")
    parser.add_argument("start_date", type=str, help="The start date (YYYY-MM-DD).")
    parser.add_argument("end_date", type=str, help="The end date (YYYY-MM-DD).")
    parser.add_argument("-o", "--output", type=str, help="(Ignored)")

    args = parser.parse_args()

    listing_date_gte = f"{args.start_date}T00:00:00.000Z"
    listing_date_lte = f"{args.end_date}T23:59:59.999Z"

    event_fetcher = EventFetcher(args.areas, listing_date_gte, listing_date_lte)
    all_events = event_fetcher.fetch_all_events()
    event_fetcher.save_events_to_json(all_events, output_path)

if __name__ == "__main__":
    main()
