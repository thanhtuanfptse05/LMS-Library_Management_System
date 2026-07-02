import re

mapping = {
    "UC-07": "BR-38",
    "UC-08": "BR-38",
    "UC-12": "BR-38",
    "UC-15": "BR-38",
    "UC-22": "BR-38",
    "UC-23": "BR-37",
    "UC-24": "BR-31, BR-38",
    "UC-25": "BR-38",
    "UC-29": "BR-44",
    "UC-30": "BR-38",
    "UC-31": "BR-19, BR-38",
    "UC-35": "BR-31, BR-43",
    "UC-37": "BR-37",
    "UC-38": "BR-22, BR-35",
    "UC-41": "BR-32, BR-34",
    "UC-47": "BR-37",
    "UC-48": "BR-37",
    "UC-49": "BR-19",
    "UC-52": "BR-38"
}

with open('detailed-UC-specifications.md', 'r', encoding='utf-8') as f:
    text = f.read()

sections = text.split('## ')
new_sections = [sections[0]]

for section in sections[1:]:
    match = re.match(r'(UC-\d+)', section)
    if match:
        uc_id = match.group(1)
        if uc_id in mapping:
            pattern = re.compile(r'(<td><b>Business Rules:</b></td>\s*<td[^>]*>)None\.?(</td>)', re.DOTALL)
            section = pattern.sub(rf'\g<1>{mapping[uc_id]}\2', section)
    new_sections.append(section)

updated_text = '## '.join(new_sections)

with open('detailed-UC-specifications.md', 'w', encoding='utf-8') as f:
    f.write(updated_text)

print("Updated detailed-UC-specifications.md successfully!")
