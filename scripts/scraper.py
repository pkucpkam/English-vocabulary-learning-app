import requests
from bs4 import BeautifulSoup
import json
from tqdm import tqdm
import time
import os

def get_cambridge_vi_meaning(word):
    url = f"https://dictionary.cambridge.org/dictionary/english-vietnamese/{word}"
    headers = {
        "User-Agent": "Mozilla/5.0"
    }

    print(f"🔗 Đang crawl: {url}")  # In ra link

    try:
        res = requests.get(url, headers=headers, timeout=10)

        if res.status_code != 200:
            print(f"❌ Không thể truy cập {url} - Status: {res.status_code}")
            return []

        soup = BeautifulSoup(res.text, "html.parser")


        vi_translations = soup.select('span.trans.dtrans[lang="vi"]')


        if not vi_translations:
            print("⚠️  Không tìm thấy thẻ chứa nghĩa!")
        
        meanings = list({item.get_text(strip=True) for item in vi_translations})
        return meanings
    except Exception as e:
        print(f"❌ Lỗi khi lấy nghĩa của từ '{word}': {e}")
        return []

# Đọc danh sách từ
with open("words.txt", "r", encoding="utf-8") as f:
    word_list = [line.strip() for line in f if line.strip()]

# Đọc dữ liệu đã có (nếu có)
output_file = "vocab_dataset.json"
if os.path.exists(output_file):
    with open(output_file, "r", encoding="utf-8") as f:
        vocab_data = json.load(f)
else:
    vocab_data = []

# Tạo set chứa các từ đã lưu rồi, để tránh trùng lặp
crawled_words = {item["word"] for item in vocab_data}

# Crawl từng từ và lưu ngay
for word in tqdm(word_list, desc="Đang dịch từ Cambridge..."):
    if word in crawled_words:
        continue  # bỏ qua từ đã crawl

    meanings = get_cambridge_vi_meaning(word)
    if meanings:
        vocab_data.append({
            "word": word,
            "meanings": meanings
        })

        # Ghi ngay vào file
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(vocab_data, f, ensure_ascii=False, indent=2)

        print(f"✅ Đã lưu: {word}")
    else:
        print(f"⚠️  Không tìm thấy nghĩa: {word}")

    time.sleep(1)  # ngủ 1s để tránh bị chặn
