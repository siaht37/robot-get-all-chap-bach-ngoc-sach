from bs4 import BeautifulSoup
import json

def extract_chapters(html):
    soup = BeautifulSoup(html, 'html.parser')
    chapters = []
    items = soup.select('li.chuong-item')
    for item in items:
        chap = item.select_one('span.chuong-name').get_text(strip=True)
        url = item.select_one('a.chuong-link')['href']
        chapter = {'chap': chap, 'url': url}
        chapters.append(chapter)
    return chapters

def convert_to_json(data):
    return json.dumps(data, ensure_ascii=False, indent=4)
