import os
import re

pets_dir = "/workspaces/prueba/Survival/plugins/MCPets/Pets"
out_file = "/workspaces/prueba/Survival/plugins/MythicMobs/items/pet_items_get.yml.new"

pet_files = []
for root, dirs, files in os.walk(pets_dir):
    for f in sorted(files):
        if f.endswith('.yml') and 'nogs_menagerie' not in root:
            pet_files.append(os.path.join(root, f))

entries = []

def strip_color(s):
    s = re.sub(r'§x(?:§[0-9A-Fa-f]){6}', '', s)
    s = re.sub(r'§.', '', s)
    return s.strip()

for pf in pet_files:
    try:
        with open(pf, 'r', encoding='utf-8') as fh:
            text = fh.read()
    except Exception:
        continue
    m_id = re.search(r'^Id:\s*(\S+)', text, flags=re.M)
    if not m_id:
        continue
    pet_id = m_id.group(1).strip()
    icon_block = ''
    m_icon_start = re.search(r'^Icon:\s*$', text, flags=re.M)
    if m_icon_start:
        start = m_icon_start.end()
        rest = text[start:]
        lines = rest.splitlines()
        block_lines = []
        for ln in lines:
            if ln == '' or ln.startswith(' ') or ln.startswith('\t'):
                block_lines.append(ln)
            else:
                break
        icon_block = '\n'.join(block_lines)
    m_mat = re.search(r'^[ \t]*Material:\s*(\S+)', icon_block, flags=re.M)
    material = m_mat.group(1).strip() if m_mat else 'BRICK'
    m_name = re.search(r'^[ \t]*Name:\s*(.+)', icon_block, flags=re.M)
    name = strip_color(m_name.group(1)) if m_name else pet_id
    m_cmd = re.search(r'^[ \t]*CustomModelData:\s*(\d+)', icon_block, flags=re.M)
    cmd = int(m_cmd.group(1)) if m_cmd else 0

    item_key = f"Item_{pet_id}"
    display_name = name
    entry = []
    entry.append(f"{item_key}:")
    entry.append(f"  Id: {material}")
    entry.append(f"  Display: '&6Huevo de {display_name}'")
    entry.append(f"  CustomModelData: {cmd}")
    entry.append("  Lore:")
    entry.append(f"  - '&7Un huevo mágico de {display_name}.'")
    entry.append("  - ''")
    entry.append("  - '&e➤ Click Derecho para desbloquear'")
    entry.append("  Skills:")
    entry.append(f"  - skill{{s=Unlock_Pet_{pet_id}}} @Self ~onUse")
    entry.append("")
    entries.append('\n'.join(entry))

with open(out_file, 'w', encoding='utf-8') as outfh:
    outfh.write('\n'.join(entries))

print('WROTE', out_file)
