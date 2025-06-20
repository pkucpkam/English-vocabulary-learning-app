import requests
from bs4 import BeautifulSoup
import json
from tqdm import tqdm
import time
import os

def get_cambridge_vi_meaning(word):
    url = f"https://dictionary.cambridge.org/dictionary/english-vietnamese/{word}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }

    print(f"🔗 Đang crawl: {url}")

    try:
        res = requests.get(url, headers=headers, timeout=10)

        if res.status_code != 200:
            print(f"❌ Không thể truy cập {url} - Status: {res.status_code}")
            return []

        soup = BeautifulSoup(res.text, "html.parser")

        # Lấy tất cả các khối nghĩa
        def_blocks = soup.select('div.def-body.ddef_b.ddef_b-t')
        meanings_data = []

        for block in def_blocks:
            # Lấy nghĩa tiếng Việt
            translation = block.select_one('span.trans.dtrans[lang="vi"]')
            if not translation:
                continue
            meaning = translation.get_text(strip=True)

            # Lấy câu ví dụ, giữ khoảng trắng giữa các thẻ
            example = block.select_one('div.examp.dexamp span.eg.deg')
            example_text = example.get_text(separator=" ", strip=True) if example else ""

            meanings_data.append({
                "meaning": meaning,
                "example": example_text
            })

        if not meanings_data:
            print("⚠️ Không tìm thấy thẻ chứa nghĩa!")

        # Lấy phát âm UK
        uk_pronunciation = soup.select_one('span.ipa.dipa')
        pronunciation = uk_pronunciation.get_text(strip=True) if uk_pronunciation else ""

        # Debug: In ra để kiểm tra
        if not pronunciation:
            print(f"⚠️ Không tìm thấy phát âm UK cho '{word}'")
            uk_block = soup.select_one('span.uk.dpron-i')
            if uk_block:
                print(f"🔍 HTML của span.uk.dpron-i: {uk_block}")
            else:
                print("🔍 Không tìm thấy span.uk.dpron-i")

        return {
            "meanings": meanings_data,
            "pronunciation_uk": pronunciation
        }

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

    result = get_cambridge_vi_meaning(word)
    if result and result["meanings"]:
        vocab_data.append({
            "word": word,
            "meanings": result["meanings"],
            "pronunciation_uk": result["pronunciation_uk"]
        })

        # Ghi ngay vào file
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(vocab_data, f, ensure_ascii=False, indent=2)

        print(f"✅ Đã lưu: {word} - Phát âm UK: {result['pronunciation_uk']}")
        for meaning_data in result["meanings"]:
            print(f"  Nghĩa: {meaning_data['meaning']} - Ví dụ: {meaning_data['example']}")
    else:
        print(f"⚠️ Không tìm thấy nghĩa: {word}")

    time.sleep(1)  # ngủ 1s để tránh bị chặn