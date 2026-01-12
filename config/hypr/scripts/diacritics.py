#!/usr/bin/env python3
import subprocess
import json
import urllib.request
import sys
import re

API_URL = "http://localhost:1234/v1/chat/completions"

SYSTEM_PROMPT = (
    "You are a sophisticated text processing engine for the Czech language. "
    "Your ONLY task is to correct the input text by adding missing diacritics "
    "(háčky a čárky), fixing spelling errors, and correcting basic grammar. "
    "Do not change the meaning or tone. "
    "IMPORTANT: Output ONLY the corrected text. Do not say 'Here is the text' or 'Sure'. "
    "If the input is already correct, output it exactly as is."
)

MODEL_NAME = "local-model" 

def notify(title, message, urgency="normal"):
    try:
        subprocess.run(['notify-send', '-u', urgency, title, message])
    except FileNotFoundError:
        pass

def get_clipboard():
    try:
        return subprocess.check_output(['wl-paste'], text=True).strip()
    except Exception:
        notify("Error", "Clipboard empty.", "critical")
        sys.exit(1)

def set_clipboard(text):
    try:
        process = subprocess.Popen(['wl-copy'], stdin=subprocess.PIPE, text=True)
        process.communicate(input=text)
    except Exception as e:
        notify("Error", f"Clipboard write failed: {e}", "critical")

def clean_response(text):
    text = re.sub(r'<think>.*?</think>', '', text, flags=re.DOTALL)
    text = re.sub(r'^```(czech|text)?\n', '', text)
    text = re.sub(r'\n```$', '', text)
    return text.strip()

def query_lm_studio(prompt):
    payload = {
        "model": MODEL_NAME,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": prompt}
        ],
        "temperature": 0.3,
        "max_tokens": -1,
        "stream": False
    }

    headers = {'Content-Type': 'application/json'}
    data = json.dumps(payload).encode('utf-8')

    try:
        req = urllib.request.Request(API_URL, data=data, headers=headers)
        with urllib.request.urlopen(req) as response:
            result = json.load(response)
            return clean_response(result['choices'][0]['message']['content'])
    except Exception as e:
        notify("API Error", str(e), "critical")
        sys.exit(1)

def main():
    user_input = get_clipboard()
    if not user_input: return

    notify("Czech Corrector", "Adding diacritics...", "low")
    
    corrected_text = query_lm_studio(user_input)
    
    set_clipboard(corrected_text)
    notify("Czech Corrector", "Text fixed and copied!")

if __name__ == "__main__":
    main()

