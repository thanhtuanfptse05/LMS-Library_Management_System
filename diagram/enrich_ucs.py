import re
import os

def enrich_text(text, row_type):
    # strip html tags for processing, except <br>
    text = text.replace('\n', ' ').strip()
    
    lines = [x.strip() for x in re.split(r'<br/?>', text) if x.strip()]
    if not lines and text:
        lines = [text]
        
    def clean(t):
        return re.sub(r'<[^>]*>', '', t).strip()

    if row_type in ['Preconditions', 'Postconditions', 'Business Rules']:
        out = []
        for line in lines:
            line = clean(line)
            if not line: continue
            if line.startswith('- '):
                line = '• ' + line[2:]
            elif not line.startswith('• '):
                line = '• ' + line
            out.append(line)
            
        if row_type == 'Preconditions':
            if not any('System is operational' in x for x in out):
                out.append('• System is operational and database is accessible.')
        if row_type == 'Postconditions':
            if not any('audit' in x.lower() for x in out):
                out.append('• System logs the transaction in AuditLogs.')
                
        return '<br>'.join(out)

    elif row_type == 'Normal Flow':
        out = []
        has_end = False
        for i, line in enumerate(lines):
            line = clean(line)
            if not line: continue
            if not re.match(r'^\d+\.', line):
                line = f"{i+1}. {line}"
            out.append(line)
            if 'ends successfully' in line.lower():
                has_end = True
        
        if not has_end and out:
            last_num = int(re.match(r'^(\d+)\.', out[-1]).group(1)) if re.match(r'^(\d+)\.', out[-1]) else len(out)
            out.append(f"{last_num+1}. Use case ends successfully.")
        return '<br><br>'.join(out)
        
    elif row_type == 'Alternative Flows':
        out = []
        if not lines or all(clean(x).lower() in ['none.', 'none', ''] for x in lines):
            out.append('<b>Alternative Flow A (User cancels operation):</b>')
            out.append('A1. At any step before submission, user clicks "Cancel".')
            out.append('A2. System discards any unsaved changes and returns to the previous screen.')
            out.append('A3. Use case ends.')
        else:
            out.append('<b>Alternative Flow A:</b>')
            for i, line in enumerate(lines):
                line = clean(line)
                if not line: continue
                if not re.match(r'^[A-Z]\d+\.', line):
                    line = f"A{i+1}. {line}"
                out.append(line)
        return '<br><br>'.join(out)
        
    elif row_type == 'Exceptions':
        out = []
        out.append('<b>Exception Flow:</b>')
        out.append('E1. At any step, if a database transaction fails or network error occurs, system displays a failure message.')
        out.append('E2. System logs the error in AuditLogs and rolls back any partial data.')
        out.append('E3. User is advised to retry or contact Administrator.')
        
        idx = 4
        for line in lines:
            line = clean(line)
            if not line or line.lower() in ['none.', 'none']: continue
            if line.startswith('- '):
                line = line[2:]
            out.append(f"E{idx}. {line}")
            idx += 1
            
        out.append(f"E{idx}. Use case ends abnormally.")
        return '<br><br>'.join(out)
        
    return text

def process_file():
    with open('detailed-UC-specifications.md', 'r', encoding='utf-8') as f:
        content = f.read()

    tables = re.findall(r'<table.*?>.*?</table>', content, re.DOTALL)
    
    new_content = content
    
    for table in tables:
        rows = re.findall(r'<tr>(.*?)</tr>', table, re.DOTALL)
        new_table = table
        
        # We will parse each row, modify it, and reconstruct the table
        # Specifically targeting indices:
        # row 5 (Preconditions), 6 (Post), 7 (Normal), 8 (Alt), 9 (Exceptions), 12 (BR)
        # Note: 0-indexed.
        
        row_types = {
            5: 'Preconditions',
            6: 'Postconditions',
            7: 'Normal Flow',
            8: 'Alternative Flows',
            9: 'Exceptions',
            12: 'Business Rules'
        }
        
        for r_idx, row in enumerate(rows):
            if r_idx in row_types:
                cells = re.findall(r'(<td[^>]*>)(.*?)(</td>)', row, re.DOTALL)
                if len(cells) >= 2:
                    # cells[1] is the data cell for these rows because they have 2 columns (header, data)
                    header_tag, data_content, end_tag = cells[1]
                    enriched = enrich_text(data_content, row_types[r_idx])
                    
                    new_row = row.replace(data_content, f"\n{enriched}\n")
                    new_table = new_table.replace(row, new_row)
                    
        # Add Non-Functional Requirements row before the end of the table
        nfr_row = """  <tr>
    <td><b>Non-Functional Requirements:</b></td>
    <td colspan="3">
      • Response time must be less than 3 seconds.<br>
      • All data transmitted must be encrypted via TLS 1.2+.<br>
      • The UI must be responsive and accessible.
    </td>
  </tr>\n"""
        
        # Insert before </table>
        modified_table = new_table.replace('</table>', nfr_row + '</table>')
        new_content = new_content.replace(table, modified_table)

    with open('detailed-UC-specifications-enriched.md', 'w', encoding='utf-8') as f:
        f.write(new_content)
        
    print("Done writing enriched MD")

if __name__ == '__main__':
    process_file()
